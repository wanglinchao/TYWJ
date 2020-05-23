//
//  TYWJSubRouteList.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/7.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TYWJSubRouteListInfo : NSObject

/* 线路编号 */
@property (copy, nonatomic) NSString *routeNum;
/* station */
@property (copy, nonatomic) NSString *station;
/* 经度 */
@property (copy, nonatomic) NSString *longitude;
/* 维度 */
@property (copy, nonatomic) NSString *latitude;
/* time */
@property (copy, nonatomic) NSString *time;
/* 购票id */
@property (copy, nonatomic) NSString *stationID;
/* 站编号 */
@property (copy, nonatomic) NSString *stationNum;
/* 站点图片信息url */
@property (copy, nonatomic) NSString *stationPicUrl;
/* 站点信息url */
@property (copy, nonatomic) NSString *stationInfoUrl;

@end

@interface TYWJSubRouteList : NSObject

/* text */
@property (copy, nonatomic) NSString *text;
/* zmc */
@property (copy, nonatomic) NSString *zmc;
/* station */
@property (copy, nonatomic) NSString *station;

/* routeListInfo */
@property (strong, nonatomic) TYWJSubRouteListInfo *routeListInfo;

@end
