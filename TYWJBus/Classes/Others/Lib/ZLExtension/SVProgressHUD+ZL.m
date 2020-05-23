//
//  SVProgressHUD+ZL.m
//  YunDuoYouBao
//
//  Created by Harley He on 18/11/2017.
//  Copyright © 2017 GY. All rights reserved.
//

#import "SVProgressHUD+ZL.h"

static CGFloat const ZLMinimumTimeInterval = 1.f;

@implementation SVProgressHUD (ZL)

+ (void)zl_showSuccessWithStatus:(NSString *)status {
    [self initDefaultSettings];
    [SVProgressHUD showSuccessWithStatus:status];
}

+ (void)zl_showErrorWithStatus:(NSString *)status {
    [self initDefaultSettings];
    [SVProgressHUD showErrorWithStatus:status];
}

+ (void)zl_showWithStatus:(NSString *)status {
    [self initDefaultSettings];
    [SVProgressHUD showWithStatus:status];
}

+ (void)zl_showBannedUseractivityWithStatus:(NSString *)status {
    [self initBannedUseractivitySettings];
    
    [SVProgressHUD showWithStatus:status];
}
/**
 默认设置
 */
+ (void)initDefaultSettings {
//    [SVProgressHUD setMaxSupportedWindowLevel:UIWindowLevelStatusBar];
    [SVProgressHUD setMinimumDismissTimeInterval:ZLMinimumTimeInterval];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

+ (void)initBannedUseractivitySettings {
    [self initDefaultSettings];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}
@end
