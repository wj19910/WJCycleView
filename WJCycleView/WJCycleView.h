//
//  WJCycleView.h
//  ShanQi
//
//  Created by Wangjing on 2019/1/15.
//  Copyright © 2019 Shanqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJCycleProtocol.h"



/// 轮播滚动方向
typedef NS_ENUM(NSInteger, WJCycleScrollDirection)
{
    WJCycleScrollDirectionHorizontal = 0,   // 水平
    WJCycleScrollDirectionVertical          // 竖直
};

/// pageControl 指示器对齐方式
typedef NS_ENUM(NSInteger, WJCyclePageControlAlignment)
{
    WJCyclePageControlAlignmentCenter = 0,  // (底部)水平居中显示
    WJCyclePageControlAlignmentRight        // (底部)水平靠右显示
};



/**
 无限轮播视图组件
 */
@interface WJCycleView : UIView

/// 刷新
- (void)reloadDataWithSource:(NSArray<id<WJCycleItemProtocol>> *)dataSrouceArr;

/// 点击事件
@property (nonatomic, copy) void (^didSelectItem)(WJCycleView *cycleView, id<WJCycleItemProtocol> item);





// MARK: - UI配置

/// 自定义Item视图显示样式 不设置则默认使用 WJCycleItemView
@property (nonatomic, copy) UIView<WJCycleItemViewProtocol> * (^customItemView)(void);

/// 滚动方向 默认水平滚动
@property (nonatomic, assign) WJCycleScrollDirection scrollDirection;

/// 自动滚动时间间隔 默认4s
@property (nonatomic, assign) NSTimeInterval autoScrollTimeInterval;

/// 是否隐藏指示器
@property (nonatomic, assign) BOOL pageControlHidden;


/// 指示器自定义配置
@property (nonatomic, copy) void (^pageCtrlConfiguration)(UIPageControl *pageCtrl);

/// 指示器对齐方式
@property (nonatomic, assign) WJCyclePageControlAlignment pageControlAlignment;




@end
