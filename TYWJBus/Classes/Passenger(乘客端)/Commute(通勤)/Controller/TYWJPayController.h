//
//  TYWJPayController.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/13.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBaseController.h"
@class TYWJRouteListInfo,TYWJPeriodTicketInfo;


@interface TYWJPayController : TYWJBaseController

/* routeListInfo */
@property (copy, nonatomic) TYWJRouteListInfo *routeListInfo;
/* TYWJPeriodTicketInfo */
@property (strong, nonatomic) TYWJPeriodTicketInfo *periodTicket;
/* 乘车日期 */
@property (strong, nonatomic) NSArray *ticketDates;
/* 是否是单次票 */
@property (assign, nonatomic, getter=isSingleTicket) BOOL singleTicket;
/* startStation */
@property (copy, nonatomic) NSString *startStation;
/* desStation */
@property (copy, nonatomic) NSString *desStation;
/* totalFee */
@property (copy, nonatomic) NSString *totalFee;

/* ticketNums */
@property (assign, nonatomic) int ticketNums;

@end
