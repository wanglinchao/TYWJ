//
//  TYWJDetailRouteController.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/29.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TYWJRouteListInfo,TYWJTicketListMonthInfo,TYWJDriverRouteListInfo;


@interface TYWJDetailRouteController : UIViewController


@property (copy, nonatomic) TYWJRouteListInfo *routeListInfo;
/* 是否是线路详情页面 */
@property (assign, nonatomic) BOOL isDetailRoute;

@property (assign, nonatomic) NSInteger stateValue;
@end
