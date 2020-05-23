//
//  TYWJReturnedTicketController.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/28.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBaseController.h"
@class TYWJTicketListInfo,TYWJTicketListMonthInfo;

@interface TYWJReturnedTicketController : TYWJBaseController

/* TYWJTicketListInfo */
@property (strong, nonatomic) TYWJTicketListInfo *ticket;
/* TYWJTicketListMonthInfo */
@property (strong, nonatomic) TYWJTicketListMonthInfo *monthTicket;
/* 退票原因 */
@property (copy, nonatomic) NSString *returnTicketReason;

@end
