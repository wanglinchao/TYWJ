//
//  TYWJTicketList.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/15.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYWJTicketListInfo : NSObject

/* yhm */
@property (copy, nonatomic) NSString *userName;
/* 线路编号 */
@property (copy, nonatomic) NSString *routeID;
/* 路线起始站 */
@property (copy, nonatomic) NSString *startStation;
/* 路线终点站 */
@property (copy, nonatomic) NSString *desStation;
/* 乘车站 */
@property (copy, nonatomic) NSString *beginStation;
/* 终点站 */
@property (copy, nonatomic) NSString *endStation;
/* 购票时间 */
@property (copy, nonatomic) NSString *buyTicketTime;
/* 乘车日期 */
@property (copy, nonatomic) NSString *getupDate;
/* 价格 */
@property (copy, nonatomic) NSString *price;
/* 乘车状态 */
@property (copy, nonatomic) NSString *status;
/* 票id */
@property (copy, nonatomic) NSString *ticketID;
/* 车牌号 */
@property (copy, nonatomic) NSString *carLicense;
/* 上车时间 */
@property (copy, nonatomic) NSString *getupTime;
/* 下车时间 */
@property (copy, nonatomic) NSString *getdownTime;
/* 城市id */
@property (copy, nonatomic) NSString *cityID;
/* 线路名称 */
@property (copy, nonatomic) NSString *routeName;
/* ticketToken */
@property (copy, nonatomic) NSString *ticketToken;
@end


@interface TYWJTicketListMonthInfo : NSObject

/* 购票时间 */
@property (copy, nonatomic) NSString *boughtTime;
/* 线路编号 */
@property (copy, nonatomic) NSString *routeID;
/* 月票月份 */
@property (copy, nonatomic) NSString *month;
/* 月票年份 */
@property (copy, nonatomic) NSString *year;
/* 上车站点 */
@property (copy, nonatomic) NSString *startStatation;
/* 下车站点 */
@property (copy, nonatomic) NSString *desStation;
/* 车牌号 */
@property (copy, nonatomic) NSString *carLicense;
/* 上车时间 */
@property (copy, nonatomic) NSString *getupTime;
/* 下车时间 */
@property (copy, nonatomic) NSString *getdownTime;
/* 乘车状态 */
@property (copy, nonatomic) NSString *status;
/* 票id */
@property (copy, nonatomic) NSString *ticketID;
@end


@interface TYWJTicketList : NSObject

/* text */
@property (copy, nonatomic) NSString *text;
/* yhm */
@property (copy, nonatomic) NSString *yhm;
/* TYWJTicketListInfo */
@property (strong, nonatomic) TYWJTicketListInfo *listInfo;

@end
