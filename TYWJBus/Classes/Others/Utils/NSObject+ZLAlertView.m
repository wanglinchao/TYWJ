//
//  NSObject+ZLAlertView.m
//  HuLaQuan
//
//  Created by Harley He on 2017/6/21.
//  Copyright © 2017年 hzl All rights reserved.
//

#import "NSObject+ZLAlertView.h"
#import "AlertRootViewController.h"

static UIWindow *window_;

@implementation NSObject (ZLAlertView)

- (void)alertWithTitle:(NSString *)title message:(NSString *)msg finish:(void (^)(void))clickOKblock {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (clickOKblock) {
            clickOKblock();
        }
        window_.hidden = YES;
        window_ = nil;
    }];
    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        window_.hidden = YES;
        window_ = nil;
    }];
    [alert addAction:cancelAc];
    [alert addAction:sureAc];
    window_ = [[UIWindow alloc] init];
    window_.frame = ZLScreenBounds;
    window_.windowLevel = UIWindowLevelAlert;
    window_.backgroundColor = [UIColor clearColor];
    window_.hidden = NO;
    AlertRootViewController *vc = [[AlertRootViewController alloc] init];
    vc.view.backgroundColor = window_.backgroundColor;
    window_.rootViewController = vc;
    [vc presentViewController:alert animated:YES completion:nil];
    
}

@end
