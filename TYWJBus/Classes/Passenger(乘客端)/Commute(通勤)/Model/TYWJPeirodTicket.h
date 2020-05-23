//
//  TYWJPeirodTicket.h
//  TYWJBus
//
//  Created by Harley He on 2018/7/2.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYWJPeriodTicketInfo : NSObject

/* 城市id */
@property (strong, nonatomic) NSString *cityID;
/* title */
@property (copy, nonatomic) NSString *title;
/* 价格 */
@property (copy, nonatomic) NSString *price;
/* ticketID */
@property (copy, nonatomic) NSString *ticketID;
/* 天数 */
@property (copy, nonatomic) NSString *days;


@end

@interface TYWJPeriodDetailTicket : NSObject

/* 线路编号 */
@property (copy, nonatomic) NSString *routeNum;
/* purchaseDate */
@property (copy, nonatomic) NSString *purchaseDate;
/* 价格 */
@property (copy, nonatomic) NSString *price;
/* 截止日期 */
@property (copy, nonatomic) NSString *endDate;
/* 状态 */
@property (copy, nonatomic) NSString *status;
/* ticketId */
@property (copy, nonatomic) NSString *ticketID;
/* phoneNum */
@property (copy, nonatomic) NSString *phoneNum;
/* 城市ID */
@property (copy, nonatomic) NSString *cityID;
/* 城市 */
@property (copy, nonatomic) NSString *city;
/* startDate */
@property (copy, nonatomic) NSString *startDate;


@end

@interface TYWJPeriodTicket : NSObject

/* text */
@property (copy, nonatomic) NSString *text;
/* ticketInfo */
@property (strong, nonatomic) TYWJPeriodTicketInfo *ticketInfo;
/* ticketInfo */
@property (strong, nonatomic) TYWJPeriodDetailTicket *detailTicket;

@end


