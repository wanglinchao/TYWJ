//
//  TYWJTripsModel.h
//  TYWJBus
//
//  Created by MacBook on 2018/12/12.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJTripsLine : NSObject

/* arriveId */
@property (copy, nonatomic) NSString *arriveId;
/* departId */
@property (copy, nonatomic) NSString *departId;
/* distance */
@property (copy, nonatomic) NSString *distance;
/* driveToPrice */
@property (copy, nonatomic) NSString *driveToPrice;
/* driverCheckingPrice */
@property (copy, nonatomic) NSString *driverCheckingPrice;
/* elapsedTime */
@property (copy, nonatomic) NSString *elapsedTime;
/* id */
@property (copy, nonatomic) NSString *ID;
/* instructorCheckingPrice */
@property (copy, nonatomic) NSString *instructorCheckingPrice;
/* instructorToPrice */
@property (copy, nonatomic) NSString *instructorToPrice;
/* lineGps */
@property (copy, nonatomic) NSString *lineGps;
/* status */
@property (copy, nonatomic) NSString *status;

@end

@interface TYWJTripsArriveStation : NSObject

/* areaRadius */
@property (copy, nonatomic) NSString *areaRadius;
/* comment */
@property (copy, nonatomic) NSString *comment;
/* createTime */
@property (copy, nonatomic) NSString *createTime;
/* id */
@property (copy, nonatomic) NSString *ID;
/* keywords */
@property (copy, nonatomic) NSString *keywords;
/* latitude */
@property (copy, nonatomic) NSString *latitude;
/* lngLat */
@property (copy, nonatomic) NSString *lngLat;
/* longitude */
@property (copy, nonatomic) NSString *longitude;
/* name */
@property (copy, nonatomic) NSString *name;
/* shortName */
@property (copy, nonatomic) NSString *shortName;
/* type */
@property (copy, nonatomic) NSString *type;

@end

@interface TYWJTripsModel : NSObject
/* arriveStation */
@property (strong, nonatomic) TYWJTripsArriveStation *arriveStation;
/* departStation */
@property (strong, nonatomic) TYWJTripsArriveStation *departStation;
/* line */
@property (strong, nonatomic) TYWJTripsLine *line;

/* arriveId */
@property (copy, nonatomic) NSString *arriveId;
/* arriveLngLat */
@property (copy, nonatomic) NSString *arriveLngLat;
/* arriveMode */
@property (copy, nonatomic) NSString *arriveMode;
/* arriveTime */
@property (copy, nonatomic) NSString *arriveTime;
/* backupArriveIds */
@property (copy, nonatomic) NSString *backupArriveIds;
/* backupStations */
@property (copy, nonatomic) NSString *backupStations;
/* busCostType */
@property (copy, nonatomic) NSString *busCostType;
/* busId */
@property (copy, nonatomic) NSString *busId;
/* carNumber */
@property (copy, nonatomic) NSString *carNumber;
/* categoryName */
@property (copy, nonatomic) NSString *categoryName;
/* createTime */
@property (copy, nonatomic) NSString *createTime;
/* date */
@property (copy, nonatomic) NSString *date;
/* departIdq */
@property (copy, nonatomic) NSString *departId;
/* departLngLat */
@property (copy, nonatomic) NSString *departLngLat;
/* departMode */
@property (copy, nonatomic) NSString *departMode;
/* departTime */
@property (copy, nonatomic) NSString *departTime;
/* distance */
@property (copy, nonatomic) NSString *distance;
/* driverId */
@property (copy, nonatomic) NSString *driverId;
/* driverName */
@property (copy, nonatomic) NSString *driverName;
/* driverTel */
@property (copy, nonatomic) NSString *driverTel;
/* id */
@property (copy, nonatomic) NSString *ID;
/* instructorId */
@property (copy, nonatomic) NSString *instructorId;
/* instructorName */
@property (copy, nonatomic) NSString *instructorName;
/* instructorTel */
@property (copy, nonatomic) NSString *instructorTel;
/* occupiedSeats */
@property (copy, nonatomic) NSString *occupiedSeats;
/* roll */
@property (copy, nonatomic) NSString *roll;
/* schedule */
@property (copy, nonatomic) NSString *schedule;
/* seats */
@property (copy, nonatomic) NSString *seats;
/* shiftingTimes */
@property (copy, nonatomic) NSString *shiftingTimes;
/* signArriveId */
@property (copy, nonatomic) NSString *signArriveId;
/* status 0 是待发车  1是运行中  2是已完成 */
@property (copy, nonatomic) NSString *status;
/* tripLineFile */
@property (copy, nonatomic) NSString *tripLineFile;

@end

NS_ASSUME_NONNULL_END
