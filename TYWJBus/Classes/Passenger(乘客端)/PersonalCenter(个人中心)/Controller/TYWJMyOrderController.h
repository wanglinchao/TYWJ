//
//  TYWJMyOrderController.h
//  TYWJBus
//
//  Created by tywj on 2020/5/25.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJBaseController.h"
typedef enum : NSUInteger {
    ALL,//全部
    WAIT_PAY,//待付款
    PAYED,//已付款
    REFUD,//已退款
} TYWJMyOrderControllerType;
//typedef enum : NSUInteger {
//    TYWJMyOrderControllerTypeSingleTicket = 12222,//单次票
//    TYWJMyOrderControllerTypeMonthTicket,//月票
//    TYWJMyOrderControllerTypeCommute//接送行程
//} TYWJMyOrderControllerType;

@interface TYWJMyOrderController : TYWJBaseController

/* type */
@property (assign, nonatomic) TYWJMyOrderControllerType type;


@end

