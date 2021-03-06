//
//  TYWJLoginTool.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJLoginTool.h"
#import "TYWJSingleLocation.h"
#import "ZLPopoverView.h"

static NSString * const kSavedImgName = @"avatar.png";

static id _instance = nil;

@interface TYWJLoginTool()<NSCopying>

@end

@implementation TYWJLoginTool

#pragma mark - 单例实现
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[TYWJLoginTool alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

#pragma mark - 初始化实现
- (instancetype)init {
    if (self = [super init]) {
        [self getLoginInfo];
    }
    return self;
}

#pragma mark - 内部方法
- (BOOL)getLoginStatus{
    BOOL loginStatus = [[ZLUserDefaults objectForKey:TYWJLoginStatusString] boolValue];
    return loginStatus;
}
- (void)getLoginInfo {
    id loginStatus = [ZLUserDefaults objectForKey:TYWJLoginStatusString];
    if ([loginStatus intValue]) {
        self.loginStatus = [loginStatus intValue];
    }else {
        self.loginStatus = 0;
    }
    
    self.passengerLoginPwd = [ZLUserDefaults objectForKey:TYWJLoginPassengerPwdString];
    self.driverLoginPwd = [ZLUserDefaults objectForKey:TYWJLoginDriverPwdString];
    self.phoneNum = [ZLUserDefaults objectForKey:TYWJLoginPhoneNumString];
    self.nickname = [ZLUserDefaults objectForKey:TYWJLoginNickanmeString];
    self.avatarString = [ZLUserDefaults objectForKey:TYWJLoginAvatarString];
    self.uid = [ZLUserDefaults objectForKey:TYWJLoginUidString];

    
    

    
    
//    if (self.nickname == nil || [self.nickname isEqualToString:@""]) {
//        self.nickname = self.phoneNum;
//    }
}
#pragma mark - 对外方法

- (void)saveLoginInfo {
    [ZLUserDefaults setObject:self.passengerLoginPwd forKey:TYWJLoginPassengerPwdString];
    [ZLUserDefaults setObject:self.driverLoginPwd forKey:TYWJLoginDriverPwdString];
    [ZLUserDefaults setObject:@(self.loginStatus) forKey:TYWJLoginStatusString];
    if (self.phoneNum) {
       [ZLUserDefaults setObject:self.phoneNum forKey:TYWJLoginPhoneNumString];
    }
    if (self.nickname) {
        [ZLUserDefaults setObject:self.nickname forKey:TYWJLoginNickanmeString];
    }
    if (self.avatarString) {
        [ZLUserDefaults setObject:self.avatarString forKey:TYWJLoginAvatarString];
    }
    if (self.uid) {
        [ZLUserDefaults setObject:self.uid forKey:TYWJLoginUidString];
    }
    [ZLUserDefaults synchronize];
    [self getLoginInfo];
    [ZLNotiCenter postNotificationName:TYWJModifyUserInfoNoti object:nil];


}

- (void)delLoginInfo {
    
  
    
    [ZLUserDefaults setObject:@(0) forKey:TYWJLoginStatusString];
    [ZLUserDefaults setObject:@"" forKey:TYWJLoginNickanmeString];
    [ZLUserDefaults setObject:@"" forKey:TYWJLoginDriverPwdString];
    [ZLUserDefaults setObject:@"" forKey:TYWJLoginPassengerPwdString];
    [ZLUserDefaults setObject:@"" forKey:TYWJLoginUidString];
    [ZLUserDefaults setObject:@"" forKey:TYWJLoginAvatarString];
    [ZLUserDefaults setObject:@"" forKey:TYWJLoginPhoneNumString];
    
    
    [ZLUserDefaults synchronize];
    [self getLoginInfo];

    [ZLNotiCenter postNotificationName:TYWJModifyUserInfoNoti object:nil];

    
    [[TYWJSingleLocation stantardLocation] stopUpdatingLocation];
}






+ (void)checkUniqueLoginWithVC:(UIViewController *)vc {
    
}

//- (NSString *)phoneNum {
//    return @"";
//}
@end
