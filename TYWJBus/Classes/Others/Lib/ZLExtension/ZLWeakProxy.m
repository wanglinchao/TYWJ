//
//  ZLWeakProxy.m
//  TYWJBus
//
//  Created by MacBook on 2019/1/9.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import "ZLWeakProxy.h"

@interface ZLWeakProxy()

/* target */
@property (weak, nonatomic) id target;

@end

@implementation ZLWeakProxy

+ (instancetype)proxyWithTarget:(id)target {
    return [[ZLWeakProxy alloc] initWithTarget:target];
}

- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL sel = invocation.selector;
    if ([self.target respondsToSelector:sel]) {
        [invocation invokeWithTarget:self.target];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [self.target respondsToSelector:aSelector];
}

@end
