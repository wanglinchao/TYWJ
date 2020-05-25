//
//  TYWJGetCurrentController.h
//  TYWJBus
//
//  Created by tywj on 2020/5/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^loginSuccessBlock)(void);

@interface TYWJGetCurrentController : NSObject



+ (UIViewController *) currentViewController;
+ (void)showLoginViewWithSuccessBlock:(loginSuccessBlock)success;
@end

NS_ASSUME_NONNULL_END
