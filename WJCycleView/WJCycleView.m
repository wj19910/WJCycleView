//
//  WJCycleView.m
//  ShanQi
//
//  Created by Wangjing on 2019/1/15.
//  Copyright © 2019 Shanqi. All rights reserved.
//

#import "WJCycleView.h"
#import "WJWeakProxy.h"


@interface WJCycleView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView<WJCycleItemViewProtocol> *previousItemView;
@property (nonatomic, strong) UIView<WJCycleItemViewProtocol> *curItemView;
@property (nonatomic, strong) UIView<WJCycleItemViewProtocol> *nextItemView;
@property (nonatomic, strong) UIPageControl *pageCtrl;

@property (nonatomic, strong) NSMutableArray<id<WJCycleItemProtocol>> *dataSourceArr; /// 数据源
@property (nonatomic, assign) NSInteger itemIdx; /// 当前显示的数据序号
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) CGPoint startDragOffset;  // 开始拖拽时的偏移量位置
@end

@implementation WJCycleView

#pragma mark - Public
- (void)reloadDataWithSource:(NSArray<id<WJCycleItemProtocol>> *)dataSrouceArr
{
    [_dataSourceArr removeAllObjects];
    [_dataSourceArr addObjectsFromArray:dataSrouceArr];

    [self reloadData];
    [self startTimer];
}

- (void)setCustomItemView:(UIView<WJCycleItemViewProtocol> *(^)(void))customItemView
{
    _customItemView = customItemView;

    for(UIView *subView in _scrollView.subviews)
    {
        [subView removeFromSuperview];
    }

    if(nil != _customItemView)
    {
        _previousItemView = _customItemView();
        _curItemView = _customItemView();
        _nextItemView = _customItemView();
    }

    if(nil == _previousItemView || nil == _curItemView || nil == _nextItemView)
    {
        _previousItemView = [[WJCycleItemView alloc] init];
        _curItemView = [[WJCycleItemView alloc] init];
        _nextItemView = [[WJCycleItemView alloc] init];
    }

    [_scrollView addSubview:_previousItemView];
    [_scrollView addSubview:_curItemView];
    [_scrollView addSubview:_nextItemView];
}

- (void)setPageControlHidden:(BOOL)pageControlHidden
{
    _pageControlHidden = pageControlHidden;
    _pageCtrl.hidden = _pageControlHidden;
}

- (void)setAutoScrollDisable:(BOOL)autoScrollDisable
{
    _autoScrollDisable = autoScrollDisable;

    if(_autoScrollDisable)
    {
        [self cancelTimer];
    }
    else
    {
        [self startTimer];
    }
}

- (void)setAutoScrollTimeInterval:(NSTimeInterval)autoScrollTimeInterval
{
    _autoScrollTimeInterval = MAX(1, MIN(autoScrollTimeInterval, NSIntegerMax));

    // 替换自动滚动时间后，重启定时器
    [self cancelTimer];
    [self startTimer];
}



#pragma mark - Private
- (void)dealloc
{
    [self cancelTimer];

#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _scrollView.frame = self.bounds;

    if(_dataSourceArr.count > 1)
    {
        if(_scrollDirection == WJCycleScrollDirectionHorizontal)
        {
            _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * 3, _scrollView.bounds.size.height);
            [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width, 0) animated:NO];

            _previousItemView.frame = CGRectMake(_scrollView.bounds.size.width * 0, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
            _curItemView.frame = CGRectMake(_scrollView.bounds.size.width * 1, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
            _nextItemView.frame = CGRectMake(_scrollView.bounds.size.width * 2, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        }
        else
        {
            _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, _scrollView.bounds.size.height * 3);
            [_scrollView setContentOffset:CGPointMake(0, _scrollView.bounds.size.height) animated:NO];

            _previousItemView.frame = CGRectMake(0, _scrollView.bounds.size.height * 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
            _curItemView.frame = CGRectMake(0, _scrollView.bounds.size.height * 1, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
            _nextItemView.frame = CGRectMake(0, _scrollView.bounds.size.height * 2, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        }
    }
    else
    {
        _scrollView.contentSize = _scrollView.bounds.size;
        [_scrollView setContentOffset:CGPointZero animated:NO];

        _previousItemView.frame = _scrollView.bounds;
        _curItemView.frame = _scrollView.bounds;
        _nextItemView.frame = _scrollView.bounds;
    }


    CGSize tmpSize = [_pageCtrl sizeForNumberOfPages:_pageCtrl.numberOfPages];
    tmpSize.width += 16.0;
    tmpSize.height -= 16.0;
    if(_pageControlAlignment == WJCyclePageControlAlignmentRight)
    {
        _pageCtrl.frame = CGRectMake(self.bounds.size.width - tmpSize.width, self.bounds.size.height - tmpSize.height, tmpSize.width, tmpSize.height);
    }
    else
    {
        _pageCtrl.frame = CGRectMake((self.bounds.size.width - tmpSize.width) / 2.0, self.bounds.size.height - tmpSize.height, tmpSize.width, tmpSize.height);
    }
}

- (void)setup
{
    // public
    {
        self.scrollDirection = WJCycleScrollDirectionHorizontal;
        self.pageControlAlignment = WJCyclePageControlAlignmentRight;
        self.autoScrollDisable = NO;
        self.autoScrollTimeInterval = 4.0;

        self.dataSourceArr = [NSMutableArray array];
        self.itemIdx = 0;
    }

    // self
    {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)]];
    }

    // scrollView
    {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }

    // itemViews
    {
        [self setCustomItemView:nil];
    }

    // pageCtrl
    {
        self.pageCtrl = [[UIPageControl alloc] init];
        _pageCtrl.hidesForSinglePage = YES;
        if(nil != _pageControllConfiguration)
        {
            __weak typeof(self) weakSelf = self;
            _pageControllConfiguration(weakSelf.pageCtrl);
        }
        [self addSubview:_pageCtrl];
    }
}

- (void)tapGestureAction:(UIGestureRecognizer *)ges
{
    if(nil != _didSelectItem)
    {
        __weak typeof(self) weakSelf = self;
        _didSelectItem(weakSelf, weakSelf.dataSourceArr[weakSelf.itemIdx]);
    }
}

#pragma mark - reloadData
- (void)reloadData
{
    // 越界预处理
    if(_dataSourceArr.count <= 0) return;

    [_curItemView setItem:_dataSourceArr[_itemIdx]];
    [_previousItemView setItem:_dataSourceArr[_itemIdx - 1 >= 0 ? _itemIdx - 1 : _dataSourceArr.count - 1]];
    [_nextItemView setItem:_dataSourceArr[_itemIdx + 1 >= _dataSourceArr.count ? 0 : _itemIdx + 1]];

    // 配置 pageCtrl
    _pageCtrl.numberOfPages = _dataSourceArr.count;
    _pageCtrl.currentPage = _itemIdx;
    _pageCtrl.hidden = _pageControlHidden || (_dataSourceArr.count <= 1);

    [self setNeedsLayout];
}

#pragma mark - Timer
- (void)startTimer
{
    [self cancelTimer];

    if(_dataSourceArr.count <= 1 || _autoScrollDisable)
    {
        return;
    }

    self.timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:_autoScrollTimeInterval] interval:_autoScrollTimeInterval target:[WJWeakProxy proxyWithTarget:self] selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)cancelTimer
{
    if(_timer)
    {
        if([_timer isValid])
        {
            [_timer invalidate];
        }

        self.timer = nil;
    }
}

- (void)timerAction
{
    if(_scrollDirection == WJCycleScrollDirectionHorizontal)
    {
        [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width * 2, 0) animated:YES];
    }
    else
    {
        [_scrollView setContentOffset:CGPointMake(0, _scrollView.bounds.size.height * 2) animated:YES];
    }
}


#pragma mark - drag or autoScroll
- (void)loadPreviousItem
{
    self.itemIdx = _itemIdx - 1 >= 0 ? _itemIdx - 1 : _dataSourceArr.count - 1;

    UIView<WJCycleItemViewProtocol> *tmpItem = _nextItemView;
    _nextItemView = _curItemView;
    _curItemView = _previousItemView;
    _previousItemView = tmpItem;

    [self reloadData];
}

- (void)loadNextItem
{
    self.itemIdx = _itemIdx + 1 >= _dataSourceArr.count ? 0 : _itemIdx + 1;

    UIView<WJCycleItemViewProtocol>  *tmpItem = _previousItemView;
    _previousItemView = _curItemView;
    _curItemView = _nextItemView;
    _nextItemView = tmpItem;

    [self reloadData];
}


#pragma mark - UIScrollViewDelegate

// 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.startDragOffset = scrollView.contentOffset;

    // 开始拖拽，暂停定时器
    [self cancelTimer];
}

// 完成拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 完成拖拽，启动定时器
    [self startTimer];
}

// 惯性滚动完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(_scrollDirection == WJCycleScrollDirectionHorizontal)
    {
        CGFloat halfWidth = scrollView.bounds.size.width / 2.0;
        if(scrollView.contentOffset.x + halfWidth < _startDragOffset.x)
        {
            [self loadPreviousItem];
        }
        else if(scrollView.contentOffset.x - halfWidth > _startDragOffset.x)
        {
            [self loadNextItem];
        }
    }
    else if(_scrollDirection == WJCycleScrollDirectionVertical)
    {
        CGFloat halfHeight = scrollView.bounds.size.height / 2.0;
        if(scrollView.contentOffset.y + halfHeight < _startDragOffset.y)
        {
            [self loadPreviousItem];
        }
        else if(scrollView.contentOffset.y - halfHeight > _startDragOffset.y)
        {
            [self loadNextItem];
        }
    }
}

// scrollView 滚动动画完成
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self loadNextItem];
}







@end
