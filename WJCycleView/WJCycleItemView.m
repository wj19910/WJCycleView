//
//  WJCycleItemView.m
//  Huanba
//
//  Created by Wangjing on 2019/1/18.
//  Copyright © 2019 Wangjing. All rights reserved.
//

#import "WJCycleItemView.h"


void (^wjCycleItemViewDataSourceHandle)(WJCycleItemView *itemView, WJCycleItem *item) = nil;


@implementation WJCycleItemView

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
    self.backgroundColor = [UIColor clearColor];
}

+ (void)setupItemHandling:(void (^)(WJCycleItemView *itemView, WJCycleItem *item))handle
{
    wjCycleItemViewDataSourceHandle = handle;
}

- (void)setItem:(WJCycleItem *)item
{
    _item = item;

    if(nil != _item)
    {
        if(nil != wjCycleItemViewDataSourceHandle)
        {
            __weak typeof(self) weakSelf = self;
            wjCycleItemViewDataSourceHandle(weakSelf, weakSelf.item);
        }
    }
    else
    {
        self.image = nil;
    }
}


@end
