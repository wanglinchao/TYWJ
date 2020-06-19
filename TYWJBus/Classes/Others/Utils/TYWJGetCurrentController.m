//
//  TYWJGetCurrentController.m
//  TYWJBus
//
//  Created by tywj on 2020/5/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJGetCurrentController.h"
#import "TYWJLoginController.h"
@implementation TYWJGetCurrentController
+ (UIViewController *)currentViewController
{
    UIWindow *keyWindow  = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    while (vc.presentedViewController)
    {
        vc = vc.presentedViewController;

        if ([vc isKindOfClass:[UINavigationController class]])
        {
            vc = [(UINavigationController *)vc visibleViewController];
        }
        else if ([vc isKindOfClass:[UITabBarController class]])
        {
            vc = [(UITabBarController *)vc selectedViewController];
        }
    }
    return vc;
}
+ (void)showLoginViewWithSuccessBlock:(loginSuccessBlock)success{
    if (LOGINSTATUS) {
        success();
    }else{
         TYWJLoginController *loginVC = [[TYWJLoginController alloc] init];
         loginVC.modalPresentationStyle = 0;
         loginVC.getSuccess = ^(){
//             success();
         };
        [[TYWJGetCurrentController currentViewController] presentViewController:loginVC animated:YES completion:^{}];
    }
}
@end
