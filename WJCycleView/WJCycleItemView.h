//
//  WJCycleItemView.h
//  Huanba
//
//  Created by Wangjing on 2019/1/18.
//  Copyright © 2019 Wangjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJCycleProtocol.h"


/// 数据源类型
typedef NS_ENUM(NSInteger, WJCycleItemType) {
    WJCycleItemTypeLocal = 0,   // 本地图片
    WJCycleItemTypeUrl,         // 远程图片
};


/// 示例轮播数据源
@interface WJCycleItem : NSObject <WJCycleItemProtocol>

@property (nonatomic, assign) WJCycleItemType type;     // 类型
@property (nonatomic, strong) NSString *imgSrc;         // 图片数据
@property (nonatomic, strong) id linkObj;               // 关联值（可用与透传数据）

+ (instancetype)itemWithType:(WJCycleItemType)type imageSource:(NSString *)imgSrc;

@end






/// 示例轮播视图
@interface WJCycleItemView : UIImageView <WJCycleItemViewProtocol>

/// 数据源
@property (nonatomic, strong) WJCycleItem *item;

/// 设置数据源处理方式（全局设置一次即可）
+ (void)setupItemHandleAction:(void (^)(WJCycleItemView *itemView))action;

@end



