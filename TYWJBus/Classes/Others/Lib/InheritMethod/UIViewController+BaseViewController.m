//
//  UIViewController+BaseViewController.m
//  jhj
//
//  Created by 王琳超 on 2016/12/23.
//  Copyright © 2016年 jhj. All rights reserved.
//

#import "UIViewController+BaseViewController.h"
#import "TYWJChooseUserTypeWindow.h"
#import "AddUMMethod.h"
@implementation UIViewController (BaseViewController)
+ (void)exchangeMethod{

    [AddUMMethod exchangeInstanceMethod:[self class] method1Sel:@selector(presentViewController: animated: completion:) method2Sel:@selector(newPresentViewController: animated: completion:)];
        [AddUMMethod exchangeInstanceMethod:[self class] method1Sel:@selector(dismissViewControllerAnimated: completion:) method2Sel:@selector(newDismissViewControllerAnimated: completion:)];

}
- (void)newPresentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion API_AVAILABLE(ios(5.0)){
//    viewControllerToPresent.modalPresentationStyle = 0;
    [self newPresentViewController:viewControllerToPresent animated:flag completion:completion];
}
- (void)newDismissViewControllerAnimated: (BOOL)flag completion:(void (^ __nullable)(void))completion API_AVAILABLE(ios(5.0)){
    [self newDismissViewControllerAnimated:flag completion:completion];
    NSString *name = NSStringFromClass([self class]);
    if ([name isEqualToString:@"TXWebViewController"]) {
            [ZLNotiCenter postNotificationName:@"showVhooseUserTypeView" object:nil];

    }
}
@end
