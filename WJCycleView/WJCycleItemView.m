//
//  WJCycleItemView.m
//  Huanba
//
//  Created by Wangjing on 2019/1/18.
//  Copyright © 2019 Wangjing. All rights reserved.
//

#import "WJCycleItemView.h"


@implementation WJCycleItem

+ (instancetype)itemWithType:(WJCycleItemType)type imageSource:(NSString *)imgSrc
{
    WJCycleItem *item = [[WJCycleItem alloc] init];
    item.type = type;
    item.imgSrc = imgSrc;
    return item;
}

@end





void (^WJCycleItemViewItemHandleAction)(WJCycleItemView *itemView) = nil;

@implementation WJCycleItemView

- (void)setItem:(WJCycleItem *)item
{
    _item = item;
    
    __weak typeof(self) weakSelf = self;
    void (^actionBlick)(void) = ^{
        if(nil != WJCycleItemViewItemHandleAction)
        {
            WJCycleItemViewItemHandleAction(weakSelf);
        }
    };
    // 确保在主线程执行
    if([NSThread isMainThread]) { actionBlick(); }
    else { dispatch_async(dispatch_get_main_queue(), actionBlick); }
}

+ (void)setupItemHandleAction:(void (^)(WJCycleItemView *itemView))action
{
    WJCycleItemViewItemHandleAction = action;
}

@end
