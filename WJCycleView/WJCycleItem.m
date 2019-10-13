//
//  WJCycleItem.m
//  WJCycleViewExample
//
//  Created by Wangjing on 2019/10/13.
//  Copyright © 2019 Wangjing. All rights reserved.
//

#import "WJCycleItem.h"

@implementation WJCycleItem

+ (instancetype)itemWithLocalName:(NSString *)imgName
{
    WJCycleItem *item = [[WJCycleItem alloc] init];
    item.type = WJCycleItemType_Local;
    item.localName = imgName;
    
    return item;
}

+ (instancetype)itemWithRemoteUrlString:(NSString *)urlStr

{
    return [WJCycleItem itemWithRemoteUrl:[NSURL URLWithString:urlStr]];
}

+ (instancetype)itemWithRemoteUrl:(NSURL *)imgUrl
{
    WJCycleItem *item = [[WJCycleItem alloc] init];
    item.type = WJCycleItemType_Remote;
    item.remoteUrl = imgUrl;
    
    return item;
}

@end

