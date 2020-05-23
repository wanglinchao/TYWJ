//
//  TYWJMyRouteController.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/25.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBaseController.h"

typedef enum : NSUInteger {
    TYWJMyRouteControllerTypeSingleTicket = 12222,//单次票
    TYWJMyRouteControllerTypeMonthTicket,//月票
    TYWJMyRouteControllerTypeCommute//接送行程
} TYWJMyRouteControllerType;

@interface TYWJMyRouteController : TYWJBaseController

/* type */
@property (assign, nonatomic) TYWJMyRouteControllerType type;


@end
