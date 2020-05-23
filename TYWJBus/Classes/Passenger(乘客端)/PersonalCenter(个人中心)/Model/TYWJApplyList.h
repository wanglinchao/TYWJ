//
//  TYWJApplyList.h
//  TYWJBus
//
//  Created by tywj on 2020/3/12.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJApplyListInfo : NSObject

/* phone */
@property (copy, nonatomic) NSString *yhm;
/* upStaion */
@property (copy, nonatomic) NSString *jtzz;
/* downStaion */
@property (copy, nonatomic) NSString *gsdz;
/* upTime */
@property (copy, nonatomic) NSString *sbsj;
/* downTime */
@property (copy, nonatomic) NSString *xbsj;
/* cityID */
@property (copy, nonatomic) NSString *cs;
/* upLong */
@property (copy, nonatomic) NSString *qjingdu;
/* upLat */
@property (copy, nonatomic) NSString *qweidu;
/* downLong */
@property (copy, nonatomic) NSString *zjingdu;
/* downLat */
@property (copy, nonatomic) NSString *zweidu;
/* kind */
@property (copy, nonatomic) NSString *kind;
/* 发起时间 */
@property (copy, nonatomic) NSString *update_time;
/* 乘车人数 */
@property (copy, nonatomic) NSString *ccrs;
/* 线路类型 */
@property (copy, nonatomic) NSString *line_kind;
/* 状态 */
@property (copy, nonatomic) NSString *mache_status;
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
/* type */
@property (copy, nonatomic) NSString *type;
/* 起始站id */
@property (copy, nonatomic) NSString *startStopId;
/* 下车站id */
@property (copy, nonatomic) NSString *stopStopId;
/* ppid */
@property (copy, nonatomic) NSString *ppid;
/* 线路状态 */
@property (copy, nonatomic) NSString *status;
/* Line_number */
@property (copy, nonatomic) NSString *Line_number;
/* sbid */
@property (copy, nonatomic) NSString *sbid;
/* sbState */
@property (copy, nonatomic) NSString *sbState;
/* xbid */
@property (copy, nonatomic) NSString *xbid;
/* xbState */
@property (copy, nonatomic) NSString *xbState;


@end

@interface TYWJApplyList : NSObject

/* text */
@property (copy, nonatomic) NSString *text;
/* yhm */
@property (copy, nonatomic) NSString *yhm;

/* applyListInfo */
@property (strong, nonatomic) TYWJApplyListInfo *applyListInfo;

@end

NS_ASSUME_NONNULL_END
