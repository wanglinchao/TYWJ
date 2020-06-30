//
//  TYWJJsonRequestUrls.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/26.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYWJJsonRequestUrls : NSObject

+ (instancetype)sharedRequest;

/* 线路表 */
@property (copy, nonatomic) NSString *detailRoute;
/* 购买单次车票 */
@property (copy, nonatomic) NSString *purchaseSingleTicket;
/* 购买月票 */
@property (copy, nonatomic) NSString *purchaseMonthTicket;
/* 退票 */
@property (copy, nonatomic) NSString *quitTicket;
/* topay */
@property (copy, nonatomic) NSString *toPay;
/* 周期票购买 */
@property (copy, nonatomic) NSString *monthTicketToPay;
/* 周期票购买 */
@property (copy, nonatomic) NSString *periodTicketToPay;
/* 是否是在审核中 */
@property (copy, nonatomic) NSString *isCheckingApp;
/* 取消订单 */
@property (copy, nonatomic) NSString *cancelOrder;
/* 显示余座 */
@property (copy, nonatomic) NSString *lastSeats;
/* 月票 */
@property (copy, nonatomic) NSString *monthTicket;

#pragma mark - 司机打卡相关

/* 司机打卡 */
@property (copy, nonatomic) NSString *driverClockIn;
/* 司机打卡登录 */
@property (copy, nonatomic) NSString *signUpLogin;
/* 获取路线 */
@property (copy, nonatomic) NSString *trips;
/* 录入油耗 */
@property (copy, nonatomic) NSString *logMileage;
/* 获取车牌号 */
@property (copy, nonatomic) NSString *carNumbers;
/* 行车记录 */
@property (copy, nonatomic) NSString *userTrips;
/* 修改密码 */
@property (copy, nonatomic) NSString *password;
/* 绩效 */
@property (copy, nonatomic) NSString *bonus;
/* 上传经纬度 */
@property (copy, nonatomic) NSString *uploadDriverGps;
/* 批量上传经纬度 */
@property (copy, nonatomic) NSString *batchUploadDriverGps;
/* 获取自由行的头部图片 */
@property (copy, nonatomic) NSString *bannerImageInfo;
/* 获取广告图片 */
@property (copy, nonatomic) NSString *ADsImageInfo;

@end
