//
//  WJCycleView.h
//  ShanQi
//
//  Created by Wangjing on 2019/1/15.
//  Copyright © 2019 Shanqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJCycleItemView.h"



/// 轮播滚动方向
typedef NS_ENUM(NSInteger, WJCycleScrollDirection)
{
    WJCycleScrollDirectionHorizontal = 0,   // 水平
    WJCycleScrollDirectionVertical          // 竖直
};

/// 无限轮播视图组件
@interface WJCycleView : UIView

/// 数据源
@property (nonatomic, strong, readonly) NSMutableArray<id<WJCycleItemProtocol>> *dataSourceArr;

/// 刷新
- (void)reloadData:(NSArray<id<WJCycleItemProtocol>> *)aNewDataSrouceArr;

/// 点击事件
@property (nonatomic, copy) void (^didSelectItem)(WJCycleView *cycleView, id<WJCycleItemProtocol> item);

/// 滚动方向 默认 WJCycleScrollDirectionHorizontal 水平滚动
@property (nonatomic, assign) WJCycleScrollDirection scrollDirection;

/// 是否自动滚动  默认 YES
@property (nonatomic, assign) BOOL isAutoScrolling;

/// 自动滚动时间间隔  默认 4 秒，区间 [1.0, NSIntegerMax]，超出区间将被忽略
@property (nonatomic, assign) NSTimeInterval autoScrollTimeInterval;

/// 滚动动画执行时长 默认 0.25 秒，区间 (0.1, 1]，超出区间将被忽略
@property (nonatomic, assign) NSTimeInterval scrollAnimateDruing;

/// 自定义Item视图
@property (nonatomic, copy) UIView <WJCycleItemViewProtocol> *(^customItemView)(void);

/// 指示器
@property (nonatomic, strong, readonly) UIPageControl *pageCtrl;


@end
