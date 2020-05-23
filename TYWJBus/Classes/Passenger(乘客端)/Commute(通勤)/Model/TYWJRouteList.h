//
//  TYWJRouteList.h
//  TYWJBus
//
//  Created by Harllan He on 2018/6/1.
//  Copyright © 2018 Harllan He. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TYWJRouteListInfo : NSObject

/* 线路号 */
@property (copy, nonatomic) NSString *routeNum;
/* 线路 */
@property (copy, nonatomic) NSString *routeName;
/* 起始站 */
@property (copy, nonatomic) NSString *startingStop;
/* 下车站 */
@property (copy, nonatomic) NSString *stopStop;
/* 原价 */
@property (copy, nonatomic) NSString *oriPrice;
/* 发车时间 */
@property (copy, nonatomic) NSString *startingTime;
/* 到站时间 */
@property (copy, nonatomic) NSString *stopTime;
/* 票价 */
@property (copy, nonatomic) NSString *price;
/* 是否是全票 */
@property (copy, nonatomic) NSString *isFullPrice;
/* 车牌号 */
@property (copy, nonatomic) NSString *carLicenseNum;
/* 车状态 */
@property (copy, nonatomic) NSString *carStatus;
/* 城市id */
@property (copy, nonatomic) NSString *cityID;
/* type */
@property (copy, nonatomic) NSString *type;
/* 起始站id */
@property (copy, nonatomic) NSString *startStopId;
/* 下车站id */
@property (copy, nonatomic) NSString *stopStopId;

@end

@interface TYWJRouteList : NSObject

/* text */
@property (copy, nonatomic) NSString *text;
/* xlmc */
@property (copy, nonatomic) NSString *xlmc;

/* routeListInfo */
@property (strong, nonatomic) TYWJRouteListInfo *routeListInfo;

@end
