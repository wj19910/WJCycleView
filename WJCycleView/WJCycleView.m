//
//  WJCycleView.m
//  ShanQi
//
//  Created by Wangjing on 2019/1/15.
//  Copyright © 2019 Shanqi. All rights reserved.
//

#import "WJCycleView.h"
#import "WJWeakProxy.h"


@interface WJCycleView ()
@property (nonatomic, strong) UIView<WJCycleItemViewProtocol> *previousItemView;
@property (nonatomic, strong) UIView<WJCycleItemViewProtocol> *curItemView;
@property (nonatomic, strong) UIView<WJCycleItemViewProtocol> *nextItemView;

@property (nonatomic, strong) UITapGestureRecognizer *tapGes;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGesPreview;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGesNext;

@property (nonatomic, assign) __block NSInteger itemIdx;    // 当前显示的数据序号
@property (nonatomic, strong) NSTimer *timer;               // 定时器
@property (nonatomic, assign) BOOL isScrolling;             // 是否正在滚动动画进行中

@end

@implementation WJCycleView

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

- (void)setup
{
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    
    _dataSourceArr = [NSMutableArray array];
    self.scrollDirection = WJCycleScrollDirectionHorizontal;
    self.isAutoScrolling = YES;
    self.autoScrollTimeInterval = 4.0;
    self.scrollAnimateDruing = 0.25;
    self.itemIdx = NSNotFound;
    
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)]];
    
    
    _pageCtrl = [[UIPageControl alloc] init];
    _pageCtrl.userInteractionEnabled = NO;
}

 -(void)setScrollDirection:(WJCycleScrollDirection)scrollDirection
{
    _scrollDirection = scrollDirection;
 
    [self removeGestureRecognizer:_swipeGesPreview];
    [self removeGestureRecognizer:_swipeGesNext];
    
    self.swipeGesPreview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesAction:)];
    self.swipeGesNext = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesAction:)];
    
    if(_scrollDirection == WJCycleScrollDirectionVertical)
    {
        _swipeGesPreview.direction = UISwipeGestureRecognizerDirectionDown;
        _swipeGesNext.direction = UISwipeGestureRecognizerDirectionUp;
    }
    else
    {
        _swipeGesPreview.direction = UISwipeGestureRecognizerDirectionRight;
        _swipeGesNext.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    [self addGestureRecognizer:_swipeGesPreview];
    [self addGestureRecognizer:_swipeGesNext];
}

- (void)dealloc
{
    [self cancelTimer];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)ges
{
    if(nil != _didSelectItem)
    {
        __weak typeof(self) weakSelf = self;
        _didSelectItem(weakSelf, weakSelf.dataSourceArr[weakSelf.itemIdx]);
    }
}

- (void)swipeGesAction:(UISwipeGestureRecognizer *)ges
{
    if(_isScrolling) { return; }
    
    if(ges.state == UIGestureRecognizerStateBegan)
    {
        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_autoScrollTimeInterval]];
    }
    else if(ges.state == UIGestureRecognizerStateRecognized)
    {
        __weak typeof(self) weakSelf = self;
        
        self.isScrolling = YES;
        if(ges.direction & UISwipeGestureRecognizerDirectionUp)
        {
            CGRect pr = CGRectMake(_previousItemView.frame.origin.x, _previousItemView.frame.origin.y - self.bounds.size.height, _previousItemView.frame.size.width, _previousItemView.frame.size.height);
            CGRect cr = CGRectMake(_curItemView.frame.origin.x, _curItemView.frame.origin.y - self.bounds.size.height, _curItemView.frame.size.width, _curItemView.frame.size.height);
            CGRect nr = CGRectMake(_nextItemView.frame.origin.x, _nextItemView.frame.origin.y - self.bounds.size.height, _nextItemView.frame.size.width, _nextItemView.frame.size.height);
            
            [UIView animateWithDuration:_scrollAnimateDruing animations:^{
                weakSelf.previousItemView.frame = pr;
                weakSelf.curItemView.frame = cr;
                weakSelf.nextItemView.frame = nr;
            } completion:^(BOOL finished) {
                [weakSelf loadNextItem];
                self.isScrolling = NO;
            }];
        }
        else if(ges.direction & UISwipeGestureRecognizerDirectionDown)
        {
            CGRect pr = CGRectMake(_previousItemView.frame.origin.x, _previousItemView.frame.origin.y + self.bounds.size.height, _previousItemView.frame.size.width, _previousItemView.frame.size.height);
            CGRect cr = CGRectMake(_curItemView.frame.origin.x, _curItemView.frame.origin.y + self.bounds.size.height, _curItemView.frame.size.width, _curItemView.frame.size.height);
            CGRect nr = CGRectMake(_nextItemView.frame.origin.x, _nextItemView.frame.origin.y + self.bounds.size.height, _nextItemView.frame.size.width, _nextItemView.frame.size.height);
            
            [UIView animateWithDuration:_scrollAnimateDruing animations:^{
                weakSelf.previousItemView.frame = pr;
                weakSelf.curItemView.frame = cr;
                weakSelf.nextItemView.frame = nr;
            } completion:^(BOOL finished) {
                [weakSelf loadPreviewItem];
                self.isScrolling = NO;
            }];
        }
        else if(ges.direction & UISwipeGestureRecognizerDirectionLeft)
        {
            CGRect pr = CGRectMake(_previousItemView.frame.origin.x - self.bounds.size.width, _previousItemView.frame.origin.y, _previousItemView.frame.size.width, _previousItemView.frame.size.height);
            CGRect cr = CGRectMake(_curItemView.frame.origin.x - self.bounds.size.width, _curItemView.frame.origin.y, _curItemView.frame.size.width, _curItemView.frame.size.height);
            CGRect nr = CGRectMake(_nextItemView.frame.origin.x - self.bounds.size.width, _nextItemView.frame.origin.y, _nextItemView.frame.size.width, _nextItemView.frame.size.height);
            
            [UIView animateWithDuration:_scrollAnimateDruing animations:^{
                weakSelf.previousItemView.frame = pr;
                weakSelf.curItemView.frame = cr;
                weakSelf.nextItemView.frame = nr;
            } completion:^(BOOL finished) {
                [weakSelf loadNextItem];
                self.isScrolling = NO;
            }];
        }
        else if(ges.direction & UISwipeGestureRecognizerDirectionRight)
        {
            CGRect pr = CGRectMake(_previousItemView.frame.origin.x + self.bounds.size.width, _previousItemView.frame.origin.y, _previousItemView.frame.size.width, _previousItemView.frame.size.height);
            CGRect cr = CGRectMake(_curItemView.frame.origin.x + self.bounds.size.width, _curItemView.frame.origin.y, _curItemView.frame.size.width, _curItemView.frame.size.height);
            CGRect nr = CGRectMake(_nextItemView.frame.origin.x + self.bounds.size.width, _nextItemView.frame.origin.y, _nextItemView.frame.size.width, _nextItemView.frame.size.height);
            
            [UIView animateWithDuration:_scrollAnimateDruing animations:^{
                weakSelf.previousItemView.frame = pr;
                weakSelf.curItemView.frame = cr;
                weakSelf.nextItemView.frame = nr;
            } completion:^(BOOL finished) {
                [weakSelf loadPreviewItem];
                self.isScrolling = NO;
            }];
        }
    }
}



#pragma mark - Timer
- (void)startTimer
{
    [self cancelTimer];
    
    if(_dataSourceArr.count <= 1 || !_isAutoScrolling)
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
    if(_isScrolling) { return; }
    
    __weak typeof(self) weakSelf = self;
    if(_scrollDirection == WJCycleScrollDirectionVertical)
    {
        CGRect pr = CGRectMake(_previousItemView.frame.origin.x, _previousItemView.frame.origin.y - self.bounds.size.height, _previousItemView.frame.size.width, _previousItemView.frame.size.height);
        CGRect cr = CGRectMake(_curItemView.frame.origin.x, _curItemView.frame.origin.y - self.bounds.size.height, _curItemView.frame.size.width, _curItemView.frame.size.height);
        CGRect nr = CGRectMake(_nextItemView.frame.origin.x, _nextItemView.frame.origin.y - self.bounds.size.height, _nextItemView.frame.size.width, _nextItemView.frame.size.height);
        
        self.isScrolling = YES;
        [UIView animateWithDuration:_scrollAnimateDruing animations:^{
            weakSelf.previousItemView.frame = pr;
            weakSelf.curItemView.frame = cr;
            weakSelf.nextItemView.frame = nr;
        } completion:^(BOOL finished) {
            [weakSelf loadNextItem];
            weakSelf.isScrolling = NO;
        }];
    }
    else
    {
        CGRect pr = CGRectMake(_previousItemView.frame.origin.x - self.bounds.size.width, _previousItemView.frame.origin.y, _previousItemView.frame.size.width, _previousItemView.frame.size.height);
        CGRect cr = CGRectMake(_curItemView.frame.origin.x - self.bounds.size.width, _curItemView.frame.origin.y, _curItemView.frame.size.width, _curItemView.frame.size.height);
        CGRect nr = CGRectMake(_nextItemView.frame.origin.x - self.bounds.size.width, _nextItemView.frame.origin.y, _nextItemView.frame.size.width, _nextItemView.frame.size.height);
        
        [UIView animateWithDuration:_scrollAnimateDruing animations:^{
            weakSelf.previousItemView.frame = pr;
            weakSelf.curItemView.frame = cr;
            weakSelf.nextItemView.frame = nr;
        } completion:^(BOOL finished) {
            [weakSelf loadNextItem];
        }];
    }
}

- (void)loadPreviewItem
{
    UIView<WJCycleItemViewProtocol> *tmpItemView = _nextItemView;
    self.nextItemView = _curItemView;
    self.curItemView = _previousItemView;
    self.previousItemView = tmpItemView;
    
    self.itemIdx = _itemIdx - 1 >= 0 ? _itemIdx - 1 : _dataSourceArr.count - 1;
    
    [self reloadItems];
}

- (void)loadNextItem
{
    UIView<WJCycleItemViewProtocol> *tmpItemView = _previousItemView;
    self.previousItemView = _curItemView;
    self.curItemView = _nextItemView;
    self.nextItemView = tmpItemView;
    
    self.itemIdx = _itemIdx + 1 >= _dataSourceArr.count ? 0 : _itemIdx + 1;
    
    [self reloadItems];
}

- (void)reloadItems
{
    if(_scrollDirection == WJCycleScrollDirectionVertical)
    {
        _previousItemView.frame = CGRectMake(0, -self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
        _curItemView.frame = self.bounds;
        _nextItemView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
    }
    else
    {
        _previousItemView.frame = CGRectMake(-self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
        _curItemView.frame = self.bounds;
        _nextItemView.frame = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
    }
    
    if(_dataSourceArr.count <= 0) { return; }
    
    [_previousItemView setItem:_dataSourceArr[_itemIdx - 1 >= 0 ? _itemIdx - 1 : _dataSourceArr.count - 1]];
    [_curItemView setItem:_dataSourceArr[_itemIdx]];
    [_nextItemView setItem:_dataSourceArr[_itemIdx + 1 >= _dataSourceArr.count ? 0 : _itemIdx + 1]];
    _pageCtrl.currentPage = MAX(0, MIN(_itemIdx, _pageCtrl.numberOfPages));
}

#pragma mark - Public

- (void)reloadData:(NSArray<id<WJCycleItemProtocol>> *)aNewDataSrouceArr
{
    for(UIView *sub in self.subviews)
    {
        [sub removeFromSuperview];
    }
    [_dataSourceArr removeAllObjects];
    [_dataSourceArr addObjectsFromArray:aNewDataSrouceArr];
    if(_dataSourceArr.count <= 0)
    {
        self.itemIdx = NSNotFound;
        return;
    }
    

    self.itemIdx = 0;
    
    if(nil != _curItemView)
    {
        self.previousItemView = _customItemView() ?: [[WJCycleItemView alloc] init];
        self.curItemView = _customItemView() ?: [[WJCycleItemView alloc] init];
        self.nextItemView = _customItemView() ?: [[WJCycleItemView alloc] init];
    }
    else
    {
        self.previousItemView = [[WJCycleItemView alloc] init];
        self.curItemView = [[WJCycleItemView alloc] init];
        self.nextItemView = [[WJCycleItemView alloc] init];
    }
    [self addSubview:_previousItemView];
    [self addSubview:_curItemView];
    [self addSubview:_nextItemView];
    [self reloadItems];
    
    
    _pageCtrl.numberOfPages = _dataSourceArr.count;
    CGSize tmpSize = [_pageCtrl sizeForNumberOfPages:_pageCtrl.numberOfPages];
    _pageCtrl.frame = CGRectMake(8.0, self.bounds.size.height - tmpSize.height, self.bounds.size.width - 8.0 * 2, tmpSize.height);
    [self addSubview:_pageCtrl];
    
    
    if(_dataSourceArr.count > 0 && _isAutoScrolling)
    {
        [self startTimer];
    }
}


- (void)setAutoScrollTimeInterval:(NSTimeInterval)autoScrollTimeInterval
{
    _autoScrollTimeInterval = MAX(1, MIN(autoScrollTimeInterval, NSIntegerMax));
    
    // 以新的滚动间隔时间重新设置定时器
    [self cancelTimer];
    [self startTimer];
}

- (void)setScrollAnimateDruing:(NSTimeInterval)scrollAnimateDruing
{
    _scrollAnimateDruing = MAX(0.1, MIN(scrollAnimateDruing, 1.0));
}

@end
