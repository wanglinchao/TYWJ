//
//  ZLLoginRegisterTool.h
//  YunDuoYouBao
//
//  Created by GY on 2017/11/22.
//  Copyright © 2017年 GY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLLoginRegisterTool : NSObject

/**
 是否是合法的邮箱地址

 @param email 邮箱地址
 @return 是否合法
 */
+ (BOOL)isValidateEmail:(NSString *)email;

/**
 是否是手机号码

 @param mobileNum 手机号码
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 是否是合法的密码格式

 @param pwNum 密码
 */
+ (BOOL)isPasswordValid:(NSString *)pwNum;

/**
 判断密码是否合法

 @param pass 面膜
 */
+(BOOL)judgePassWordLegal:(NSString *)pass;

@end
