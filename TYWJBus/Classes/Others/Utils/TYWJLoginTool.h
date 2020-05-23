//
//  TYWJLoginTool.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYWJDriverInfo.h"

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
/* avatarImg */
@property (strong, nonatomic) UIImage *avatarImg;
/* type 司机还是乘客 */
@property (assign, nonatomic) TYWJLoginType userType;
/* 乘客登录密码 */
@property (copy, nonatomic) NSString *passengerLoginPwd;
/* 司机登录密码 */
@property (copy, nonatomic) NSString *driverLoginPwd;
/* TYWJDriverInfo.h */
@property (strong, nonatomic) TYWJDriverInfo *driverInfo;


+ (instancetype)sharedInstance;

+ (void)checkUniqueLoginWithVC:(UIViewController *)vc;
- (int)getLoginStatus;
- (void)getLoginInfo;
- (void)saveLoginInfo;
- (void)delLoginInfo;


@end
