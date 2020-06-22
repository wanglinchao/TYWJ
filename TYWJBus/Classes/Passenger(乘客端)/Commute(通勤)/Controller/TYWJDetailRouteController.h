//
//  TYWJDetailRouteController.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/29.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYWJTripList.h"
@class TYWJRouteListInfo,TYWJTicketListMonthInfo,TYWJDriverRouteListInfo;


@interface TYWJDetailRouteController : UIViewController
@property (strong, nonatomic) TYWJTripList *tripListInfo;
@property (copy, nonatomic) TYWJRouteListInfo *routeListInfo;
/* 是否是线路详情页面 */
@property (assign, nonatomic) BOOL isDetailRoute;

@end
