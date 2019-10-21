//
//  WJWeakProxy.m
//  WJCycleView
//
//  Created by Wangjing on 2019/10/14.
//

#import "WJWeakProxy.h"

@implementation WJWeakProxy

+ (instancetype)proxyWithTarget:(id)target
{
    WJWeakProxy *proxy = [WJWeakProxy alloc];
    proxy.target = target;
    return proxy;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:_target];
}

- (nullable NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [_target methodSignatureForSelector:sel];
}

@end
