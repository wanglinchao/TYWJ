//
//  TYWJDriverRouteList.h
//  TYWJBus
//
//  Created by Harley He on 2018/7/31.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYWJDriverRouteListInfo : NSObject

/* 线路编号 */
@property (copy, nonatomic) NSString *routeNum;
/* 线路名称 */
@property (copy, nonatomic) NSString *routeName;
/* 起始站 */
@property (copy, nonatomic) NSString *startStation;
/* 终点站 */
@property (copy, nonatomic) NSString *endStation;
/* 线路票价 */
@property (copy, nonatomic) NSString *routePrice;
/* 起始时间 */
@property (copy, nonatomic) NSString *startTime;
/* 结束时间 */
@property (copy, nonatomic) NSString *endTime;
/* 票价 */
@property (copy, nonatomic) NSString *price;
/* 是否启用 */
@property (copy, nonatomic) NSString *isLaunch;
/* 满载人数 */
@property (copy, nonatomic) NSString *passengerNum;
/* 车牌号 */
@property (copy, nonatomic) NSString *license;
/* 手机号 */
@property (copy, nonatomic) NSString *phoneNum;
/* 状态 */
@property (copy, nonatomic) NSString *carStatus;
/* 余票 */
@property (copy, nonatomic) NSString *lastSeats;

@end

@interface TYWJDriverRouteList : NSObject

/* xlbh */
@property (copy, nonatomic) NSString *xlbh;
/* text */
@property (copy, nonatomic) NSString *text;
/* info */
@property (strong, nonatomic) TYWJDriverRouteListInfo *listInfo;

@end
