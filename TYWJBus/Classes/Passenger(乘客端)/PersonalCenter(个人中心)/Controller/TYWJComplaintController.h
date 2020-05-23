//
//  TYWJComplaintController.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/21.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBaseController.h"
@class TYWJTicketListInfo,TYWJTicketListMonthInfo;


@interface TYWJComplaintController : TYWJBaseController

/* TYWJTicketListInfo */
@property (strong, nonatomic) TYWJTicketListInfo *ticket;
/* TYWJTicketListMonthInfo */
@property (strong, nonatomic) TYWJTicketListMonthInfo *monthTicket;
/* 是否是退票界面 */
@property (assign, nonatomic) BOOL isRefundTicket;

@end
