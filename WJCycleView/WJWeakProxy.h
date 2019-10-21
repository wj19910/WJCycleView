//
//  WJWeakProxy.h
//  WJCycleView
//
//  Created by Wangjing on 2019/10/14.
//

#import <Foundation/Foundation.h>


@interface WJWeakProxy : NSProxy
@property (nonatomic, weak) id target;

+ (instancetype)proxyWithTarget:(id)target;

@end

