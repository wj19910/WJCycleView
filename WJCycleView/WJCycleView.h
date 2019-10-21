//
//  WJCycleView.h
//  ShanQi
//
//  Created by Wangjing on 2019/1/15.
//  Copyright © 2019 Shanqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJCycleProtocol.h"
#import "WJCycleItemView.h"



/// 轮播滚动方向
typedef NS_ENUM(NSInteger, WJCycleScrollDirection)
{
    WJCycleScrollDirectionHorizontal = 0,   // 水平
    WJCycleScrollDirectionVertical          // 竖直
};

/// pageControl 指示器对齐方式
typedef NS_ENUM(NSInteger, WJCyclePageControlAlignment)
{
    WJCyclePageControlAlignmentRight = 0,   // (底部)水平靠右显示
    WJCyclePageControlAlignmentCenter,      // (底部)水平居中显示
};



/**
 无限轮播视图组件
 */
@interface WJCycleView : UIView

/// 重新加载数据源
- (void)reloadDataWithSource:(NSArray<id<WJCycleItemProtocol>> *)dataSrouceArr;

/// 点击事件
@property (nonatomic, copy) void (^didSelectItem)(WJCycleView *cycleView, id<WJCycleItemProtocol> item);




// MARK: - UI配置

/// 自定义Item视图显示样式 不设置则默认使用 WJCycleItemView
@property (nonatomic, copy) UIView<WJCycleItemViewProtocol> * (^customItemView)(void);

/// 滚动方向 默认水平滚动
@property (nonatomic, assign) WJCycleScrollDirection scrollDirection;


/// 是否隐藏指示器
@property (nonatomic, assign) BOOL pageControlHidden;

/// 指示器自定义配置
@property (nonatomic, copy) void (^pageControllConfiguration)(UIPageControl *pageCtrl);

/// 指示器对齐方式
@property (nonatomic, assign) WJCyclePageControlAlignment pageControlAlignment;



// MARK: - 定时器配置

/// 是否禁用（定时器）自动滚动
@property (nonatomic, assign) BOOL autoScrollDisable;

/// 自动滚动时间间隔  默认4s (低于1秒的设置将被忽略)
@property (nonatomic, assign) NSTimeInterval autoScrollTimeInterval;



@end
