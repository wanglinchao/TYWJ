//
//  MBProgressHUD+ZL.m
//  ZLPlayNews
//
//  Created by hezhonglin on 16/11/2.
//  Copyright © 2016年 TsinHzl. All rights reserved.
//

#import "MBProgressHUD+ZL.h"
#import <objc/runtime.h>

static UIWindow *defaultWindow_ = nil;

@implementation MBProgressHUD (ZL)

#pragma mark 显示信息

+ (void)zl_showMessageInCustomWindow:(NSString *)message {
    defaultWindow_ = [[UIWindow alloc] init];
    defaultWindow_.backgroundColor = [UIColor clearColor];
    defaultWindow_.frame = [UIScreen mainScreen].bounds;
    defaultWindow_.hidden = NO;
    [self zl_showMessage:message toView:defaultWindow_];
}

+ (void)zl_hideHUDInCustomWindow {
    [self zl_hideHUDForView:defaultWindow_];
    defaultWindow_.hidden = YES;
    defaultWindow_ = nil;
}

+ (void)zl_show:(NSString *)text icon:(NSString *)icon view:(UIView *)view afterDelay:(NSTimeInterval)time
{
//    [self zl_hideHUD];
    if (view == nil) {
        view = [self getDefaultWindow];
    }
    [MBProgressHUD hideAllHUDsForView:view animated:NO];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    hud.margin = 12.0f;
//    hud.userInteractionEnabled = NO;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.square = NO;
    hud.animationType = MBProgressHUDAnimationZoomOut;
    // 1秒之后再消失
    [hud hide:YES afterDelay:time];
}

#pragma mark 显示错误信息
+ (void)zl_showAlert:(NSString *)alert toView:(UIView *)view afterDelay:(NSTimeInterval)time
{
    [self zl_show:alert icon:@"info.png" view:view afterDelay:time];
}

+ (void)zl_showAlert:(NSString *)alert afterDelay:(NSTimeInterval)time
{
    [self zl_show:alert icon:@"info.png" view:nil afterDelay:time];
}

+ (void)zl_showError:(NSString *)error toView:(UIView *)view{
    [self zl_show:error icon:nil view:view afterDelay:1.5];
}

+ (void)zl_showSuccess:(NSString *)success toView:(UIView *)view
{
    [self zl_show:success icon:@"success.png" view:view afterDelay:1.5];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)zl_showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) {
        view = [self getDefaultWindow];
    }
    [MBProgressHUD hideAllHUDsForView:view animated:NO];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.activityIndicatorColor = ZLNavTextColor;
    hud.labelText = message;
    hud.animationType = MBProgressHUDAnimationZoomOut;
//    hud.userInteractionEnabled = NO;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    return hud;
}

+ (void)zl_showSuccess:(NSString *)success
{
    [self zl_showSuccess:success toView:nil];
}

+ (void)zl_showError:(NSString *)error
{
    [MBProgressHUD hideAllHUDsForView:CURRENTVIEW animated:YES];
    if ([TYWJCommonTool isBlankString:error]) {
        error = @"异常错误";
    }
    [self zl_showError:error toView:nil];
}

+ (void)zl_showAlert:(NSString *)message
{
    [self zl_showAlert:message afterDelay:1.0];
}

+ (MBProgressHUD *)zl_showMessage:(NSString *)message
{
    return [self zl_showMessage:message toView:nil];
}

+ (void)zl_hideHUDForView:(UIView *)view
{
    if (view == nil) {
        view = [self getDefaultWindow];
        [self hideHUDForView:view animated:YES];
        defaultWindow_ = nil;
        return;
    }
    [self hideHUDForView:view animated:YES];
}

+ (void)zl_hideHUD
{
    [self zl_hideHUDForView:nil];
}

+ (UIWindow *)getDefaultWindow {
    if (!defaultWindow_) {
        defaultWindow_ = [UIApplication sharedApplication].delegate.window;
    }
    return defaultWindow_;
}

@end
