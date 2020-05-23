//
//  SVProgressHUD+ZL.h
//  YunDuoYouBao
//
//  Created by Harley He on 18/11/2017.
//  Copyright © 2017 GY. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>

@interface SVProgressHUD (ZL)

+ (void)zl_showSuccessWithStatus:(NSString *)status;
+ (void)zl_showErrorWithStatus:(NSString *)status;
+ (void)zl_showWithStatus:(NSString *)status;

+ (void)zl_showBannedUseractivityWithStatus:(NSString *)status;

@end
