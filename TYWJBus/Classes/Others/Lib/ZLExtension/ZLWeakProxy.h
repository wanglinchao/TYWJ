//
//  ZLWeakProxy.h
//  TYWJBus
//
//  Created by MacBook on 2019/1/9.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLWeakProxy : NSProxy

+ (instancetype)proxyWithTarget:(id)target;
- (instancetype)initWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
