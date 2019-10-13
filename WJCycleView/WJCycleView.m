//
//  WJCycleView.m
//  ShanQi
//
//  Created by Wangjing on 2019/1/15.
//  Copyright © 2019 Shanqi. All rights reserved.
//

#import "WJCycleView.h"
#import "WJCycleItemView.h"


@interface WJCycleView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView<WJCycleItemViewProtocol> *previousItemView;
@property (nonatomic, strong) UIView<WJCycleItemViewProtocol> *curItemView;
@property (nonatomic, strong) UIView<WJCycleItemViewProtocol> *nextItemView;
@property (nonatomic, strong) UIPageControl *pageCtrl;


@property (nonatomic, strong) NSMutableArray<id<WJCycleItemProtocol>> *dataSourceArr; /// 数据源
@property (nonatomic, assign) NSInteger itemIdx; /// 当前显示的数据序号

@property (nonatomic, assign) CGPoint startDragOffset;
@property (nonatomic, strong) dispatch_source_t timer; // 定时器
@property (nonatomic, assign) BOOL isTimerActive;

@end

@implementation WJCycleView

#pragma mark - Public
- (void)reloadDataWithSource:(NSArray<id<WJCycleItemProtocol>> *)dataSrouceArr
{
    [_dataSourceArr removeAllObjects];
    [_dataSourceArr addObjectsFromArray:dataSrouceArr];

    [self reloadData];
    [self resumeTimer];
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


#pragma mark - Private System
- (void)dealloc
{
    [self destroyTimer];
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
    
    CGSize tmpSize = [_pageCtrl sizeForNumberOfPages:_pageCtrl.numberOfPages];
    tmpSize.width += 16.0;
    tmpSize.height -= 8.0;
    if(_pageControlAlignment == WJCyclePageControlAlignmentRight)
    {
        _pageCtrl.frame = CGRectMake(self.bounds.size.width - tmpSize.width, self.bounds.size.height - tmpSize.height, tmpSize.width, tmpSize.height);
    }
    else
    {
        _pageCtrl.frame = CGRectMake((self.bounds.size.width - tmpSize.width) / 2.0, self.bounds.size.height - tmpSize.height, tmpSize.width, tmpSize.height);
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if(nil == newSuperview)
    {
        [self destroyTimer];
    }
    else
    {
        [self reloadData];
    }
}

#pragma mark - Private Custom
- (void)setup
{
    // public
    {
        _scrollDirection = WJCycleScrollDirectionHorizontal;
        _autoScrollTimeInterval = 4.0;
        _dataSourceArr = [NSMutableArray array];
        _itemIdx = 0;
        _pageControlAlignment = WJCyclePageControlAlignmentCenter;
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
        if(nil != _pageCtrlConfiguration)
        {
            __weak typeof(self) weakSelf = self;
            _pageCtrlConfiguration(weakSelf.pageCtrl);
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

#pragma mark - Timer
- (void)initTimer
{
    __weak typeof(self) weakSelf = self;
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), (_autoScrollTimeInterval * NSEC_PER_SEC), 0);  // 每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        [weakSelf timerTriggerAction];
    });
}

- (void)destroyTimer
{
    if(_timer)
    {
        if(!_isTimerActive)
        {
            dispatch_resume(_timer);
        }
        self.isTimerActive = NO;
        dispatch_source_cancel(_timer);
        self.timer = nil;
    }
}

- (void)resumeTimer
{
    if(_dataSourceArr.count <= 1) { return; }

    if(!_timer)
    {
        [self initTimer];
    }

    if(!_isTimerActive)
    {
        self.isTimerActive = YES;
        dispatch_resume(_timer);
    }
}

- (void)suspendTimer
{
    if(_timer && _isTimerActive)
    {
        dispatch_suspend(_timer);
    }
}

- (void)timerTriggerAction
{
    CGPoint targetOffset = _scrollDirection == WJCycleScrollDirectionHorizontal ? CGPointMake(_scrollView.contentOffset.x + _scrollView.bounds.size.width, _scrollView.contentOffset.y) : CGPointMake(_scrollView.contentOffset.x, _scrollView.contentOffset.y + _scrollView.bounds.size.height);
    [_scrollView setContentOffset:targetOffset animated:YES];
}

#pragma mark - ReloadData
- (void)reloadData
{
    if(_dataSourceArr.count < 1) { return; }

    // config pageControl
    _pageCtrl.numberOfPages = _dataSourceArr.count;
    _pageCtrl.currentPage = _itemIdx;


    // config itemViews's data
    [_curItemView setItem:_dataSourceArr[_itemIdx]];
    [_previousItemView setItem:_dataSourceArr[_itemIdx - 1 >= 0 ? _itemIdx - 1 : _dataSourceArr.count - 1]];
    [_nextItemView setItem:_dataSourceArr[_itemIdx + 1 >= _dataSourceArr.count ? 0 : _itemIdx + 1]];


    // layoutItemViews
    BOOL canScroll = _dataSourceArr.count > 1; // 标志位，记录数据源个数是否大于1，用于判断ScrollView是否可以滚动
    if(_scrollDirection == WJCycleScrollDirectionHorizontal)
    {
        CGPoint offset = canScroll ? CGPointMake(_scrollView.bounds.size.width, 0) : CGPointZero;
        _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * (canScroll ? 3 : 1), _scrollView.bounds.size.height);
        _scrollView.contentOffset = offset;

        _curItemView.frame = CGRectMake(offset.x, offset.y, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        _nextItemView.frame = CGRectMake(offset.x + _scrollView.bounds.size.width, offset.y, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        _previousItemView.frame = CGRectMake(offset.x - _scrollView.bounds.size.width, offset.y, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
    }
    else
    {
        CGPoint offset = canScroll ? CGPointMake(0, _scrollView.bounds.size.height) : CGPointZero;
        _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, _scrollView.bounds.size.height * (canScroll ? 3 : 1));
        _scrollView.contentOffset = offset;

        _curItemView.frame = CGRectMake(offset.x, offset.y, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        _nextItemView.frame = CGRectMake(offset.x, offset.y + _scrollView.bounds.size.height, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        _previousItemView.frame = CGRectMake(offset.x, offset.y - _scrollView.bounds.size.height , _scrollView.bounds.size.width, _scrollView.bounds.size.height);
    }
}

#pragma mark - drag or autoScroll
- (void)loadPreviousItem
{
    NSInteger tmpIdx = _itemIdx - 1;
    if(tmpIdx < 0)
    {
        tmpIdx = _dataSourceArr.count - 1;
    }
    _itemIdx = tmpIdx;


    UIView<WJCycleItemViewProtocol> *tmpItem = _nextItemView;
    _nextItemView = _curItemView;
    _curItemView = _previousItemView;
    _previousItemView = tmpItem;

    [self reloadData];
}

- (void)loadNextItem
{
    NSInteger tmpIdx = _itemIdx + 1;
    if(tmpIdx >= _dataSourceArr.count)
    {
        tmpIdx = 0;
    }
    _itemIdx = tmpIdx;

    UIView<WJCycleItemViewProtocol>  *tmpItem = _previousItemView;
    _previousItemView = _curItemView;
    _curItemView = _nextItemView;
    _nextItemView = tmpItem;

    [self reloadData];
}

- (void)didEndDragScroll
{
    if(_scrollDirection == WJCycleScrollDirectionHorizontal)
    {
        if(_scrollView.contentOffset.x + _scrollView.bounds.size.width / 2.0 < _startDragOffset.x)
        {
            [self loadPreviousItem];
        }
        else if(_scrollView.contentOffset.x - _scrollView.bounds.size.width / 2.0 > _startDragOffset.x)
        {
            [self loadNextItem];
        }
    }
    else
    {
        if(_scrollView.contentOffset.y + _scrollView.bounds.size.height / 2.0 < _startDragOffset.y)
        {
            [self loadPreviousItem];
        }
        else if(_scrollView.contentOffset.y - _scrollView.bounds.size.height / 2.0 > _startDragOffset.y)
        {
            [self loadNextItem];
        }
    }
}

#pragma mark - UIScrollViewDelegate

// 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self suspendTimer];
    self.startDragOffset = scrollView.contentOffset;
}

// 完成拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate) // 没有惯性移动，滚动结束
    {
        [self didEndDragScroll];
        [self resumeTimer];
    }
    else
    {
        // will do something in scrollViewDidEndDecelerating:
    }
}

// 惯性移动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self didEndDragScroll];
    [self resumeTimer];
}

// scrollView 确实完成滚动动画
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self loadNextItem];
}



@end



