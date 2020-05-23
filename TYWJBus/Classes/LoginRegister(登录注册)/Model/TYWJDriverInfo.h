//
//  TYWJDriverInfo.h
//  TYWJBus
//
//  Created by MacBook on 2018/12/11.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJDriverInfo : NSObject

/* 创建时间 */
@property (copy, nonatomic) NSString *createTime;
/* deviceId */
@property (copy, nonatomic) NSString *deviceId;
/* driveYear */
@property (copy, nonatomic) NSString *driveYear;
/* driverType */
@property (copy, nonatomic) NSString *driverType;
/* ID */
@property (copy, nonatomic) NSString *ID;
/* idCard */
@property (copy, nonatomic) NSString *idCard;
/* name */
@property (copy, nonatomic) NSString *name;
/* no */
@property (copy, nonatomic) NSString *no;
/* password */
@property (copy, nonatomic) NSString *password;
/* photo */
@property (copy, nonatomic) NSString *photo;
/* pinYin */
@property (copy, nonatomic) NSString *pinYin;
/* registrationId */
@property (copy, nonatomic) NSString *registrationId;
/* salaryLevel */
@property (copy, nonatomic) NSString *salaryLevel;
/* salt */
@property (copy, nonatomic) NSString *salt;
/* sex */
@property (copy, nonatomic) NSString *sex;
/* status */
@property (copy, nonatomic) NSString *status;
/* tel */
@property (copy, nonatomic) NSString *tel;
/* token */
@property (copy, nonatomic) NSString *token;
/* updateTime */
@property (copy, nonatomic) NSString *updateTime;
/* wxOpenId */
@property (copy, nonatomic) NSString *wxOpenId;


@end

NS_ASSUME_NONNULL_END
