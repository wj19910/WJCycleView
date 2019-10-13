//
//  WJCycleProtocol.h
//  WJCycleViewExample
//
//  Created by Wangjing on 2019/10/11.
//  Copyright © 2019 Wangjing. All rights reserved.
//

#import <Foundation/NSArray.h>


/// 数据源类型
typedef NS_ENUM(NSUInteger, WJCycleItemType)
{
    WJCycleItemType_Local = 0,      // 加载本地图片
    WJCycleItemType_Remote          // 加载远程图片
};



/// 数据源类型 协议
@protocol WJCycleItemProtocol <NSObject>

@property (nonatomic, assign) WJCycleItemType type;     // 资源类型
@property (nonatomic, strong) NSString *localName;      // 本体图片名称 itemType == WJCycleItemType_Local 时有效
@property (nonatomic, strong) NSURL *remoteUrl;      // 远程图片URL itemType == WJCycleItemType_Remote 时有效

@end





/// 自定义 Item 视图协议
@protocol WJCycleItemViewProtocol <NSObject>

- (void)setItem:(id<WJCycleItemProtocol>)item;

@end
