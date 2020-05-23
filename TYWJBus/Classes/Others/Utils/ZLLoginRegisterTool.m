//
//  ZLLoginRegisterTool.m
//  YunDuoYouBao
//
//  Created by GY on 2017/11/22.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "ZLLoginRegisterTool.h"


@implementation ZLLoginRegisterTool

/**
 *  Check Email String Valid
 *
 *  @param email
 *
 *  @return email string is valid or not
 */
+ (BOOL) isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**
 *  Check Mobile Number String
 *
 *  @param mobileNum
 *
 *  @return mobile number is valid or not
 */

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    mobileNum = [mobileNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNum = [mobileNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobileNum.length == 11) {
        return YES;
    }
    return NO;
//    if (mobileNum.length == 11) {
//        //   NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//        NSString * MOBILE = @"^((13[0-9])|(14[0-9])|(15[0-9])|(18[0-9])|(17[0-9]))\\d{8}$";
//
//        NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//        NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//        NSString * CT = @"^1((77|33|53|8[09])[0-9]|349)\\d{7}$";
//        // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//        NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//        NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//        NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//        if (([regextestmobile evaluateWithObject:mobileNum] == YES)
//            || ([regextestcm evaluateWithObject:mobileNum] == YES)
//            || ([regextestct evaluateWithObject:mobileNum] == YES)
//            || ([regextestcu evaluateWithObject:mobileNum] == YES))
//        {
//            return YES;
//        }else {
//            [MBProgressHUD zl_showError:@"请输入正确的手机号"];
//            return NO;
//        }
//    }else {
//        [MBProgressHUD zl_showError:@"请输入正确的手机号"];
//        return NO;
//    }
//    NSString *photoRange = @"^1(3[0-9]|4[0-9]|5[0-9]|7[0-9]|8[0-9])\\d{8}$";//正则表达式
//    NSPredicate *regexMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",photoRange];
//    BOOL result = [regexMobile evaluateWithObject:mobileNum];
//    if (result) {
//        return YES;
//    } else {
//        return NO;
//    }
}

/**
 *  Check Password String
 *
 
 *  @param pwNum
 *
 *  @return password string is consist of A-Z and # or not
 */
+ (BOOL)isPasswordValid:(NSString *)pwNum
{
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:pwNum]) {
        return YES ;
    }else
        return NO;
    
}

;
+(BOOL)judgePassWordLegal:(NSString *)pass{
    BOOL result = false;
    if ([pass length] >= 6){
        // 判断长度大于6位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z])[0-9A-Za-z]{6,16}$";
        //        NSString * regex =@"(?=^.{6,16}$)(?=.*[A-Z])(?=.*[a-z])(?!.*\n).*$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    return result;
}

@end
