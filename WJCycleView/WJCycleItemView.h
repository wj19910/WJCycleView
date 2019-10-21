//
//  WJCycleItemView.h
//  Huanba
//
//  Created by Wangjing on 2019/1/18.
//  Copyright © 2019 Wangjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJCycleProtocol.h"
#import "WJCycleItem.h"


@interface WJCycleItemView : UIImageView <WJCycleItemViewProtocol>

/// 同意配置数据源处理方式（只需设置一次）
+ (void)setupItemHandling:(void (^)(WJCycleItemView *itemView, WJCycleItem *item))handle;

/// 数据源
@property (nonatomic, strong) WJCycleItem *item;

@end



