//
//  WJCycleItem.h
//  WJCycleViewExample
//
//  Created by Wangjing on 2019/10/13.
//  Copyright © 2019 Wangjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJCycleProtocol.h"

@interface WJCycleItem : NSObject <WJCycleItemProtocol>

@property (nonatomic, assign) WJCycleItemType type;     // 资源类型
@property (nonatomic, strong) NSString *localName;      // 本体图片名称 itemType == WJCycleItemType_Local 时有效
@property (nonatomic, strong) NSURL *remoteUrl;         // 远程图片URL itemType == WJCycleItemType_Remote 时有效

+ (instancetype)itemWithLocalName:(NSString *)imgName;
+ (instancetype)itemWithRemoteUrl:(NSURL *)imgUrl;
+ (instancetype)itemWithRemoteUrlString:(NSString *)urlStr;

@end

