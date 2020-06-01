//
//  TYWJLoginTool.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    TYWJLoginTypeDriver = 10001,
    TYWJLoginTypePassenger,
} TYWJLoginType;

@interface TYWJLoginTool : NSObject

/* 登录状态记录 */
@property (assign, nonatomic) int loginStatus;
/* 电话号码 */
@property (copy, nonatomic) NSString *phoneNum;
/* nickname */
@property (copy, nonatomic) NSString *nickname;

@property (copy, nonatomic) NSString *avatarString;

@property (copy, nonatomic) NSString *uid;

/* 乘客登录密码 */
@property (copy, nonatomic) NSString *passengerLoginPwd;
/* 司机登录密码 */
@property (copy, nonatomic) NSString *driverLoginPwd;


+ (instancetype)sharedInstance;

+ (void)checkUniqueLoginWithVC:(UIViewController *)vc;
- (int)getLoginStatus;
- (void)getLoginInfo;
- (void)saveLoginInfo;
- (void)delLoginInfo;


@end
