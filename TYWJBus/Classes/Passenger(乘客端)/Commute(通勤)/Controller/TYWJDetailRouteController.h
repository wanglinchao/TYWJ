//
//  TYWJDetailRouteController.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/29.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TYWJRouteListInfo,TYWJTicketListInfo,TYWJTicketListMonthInfo,TYWJDriverRouteListInfo;


@interface TYWJDetailRouteController : UIViewController

/* TYWJDriverRouteListInfo */
@property (copy, nonatomic) TYWJDriverRouteListInfo *driverListInfo;
/* routeListInfo */
@property (copy, nonatomic) TYWJRouteListInfo *routeListInfo;
/* 是否是线路详情页面 */
@property (assign, nonatomic) BOOL isDetailRoute;
/* ticket */
@property (strong, nonatomic) TYWJTicketListInfo *ticket;
/* 余座 */
@property (strong, nonatomic) NSArray *lastSeats;
/*车票状态*/
@property (assign, nonatomic) NSInteger stateValue;
@end
