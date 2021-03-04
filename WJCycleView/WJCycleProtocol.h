//
//  WJCycleProtocol.h
//  WJCycleViewExample
//
//  Created by Wangjing on 2019/10/11.
//  Copyright © 2019 Wangjing. All rights reserved.
//

#import <Foundation/NSArray.h>

/// 数据源 协议
@protocol WJCycleItemProtocol <NSObject>

@end


/// 自定义 Item 视图协议
@protocol WJCycleItemViewProtocol <NSObject>

- (void)setItem:(id<WJCycleItemProtocol>)item;

@end










