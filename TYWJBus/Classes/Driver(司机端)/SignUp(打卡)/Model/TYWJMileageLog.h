//
//  TYWJMileageLog.h
//  TYWJBus
//
//  Created by MacBook on 2018/12/13.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJMileageLog : NSObject

/* carNumber */
@property (copy, nonatomic) NSString *carNumber;
/* createTime */
@property (copy, nonatomic) NSString *createTime;
/* driverId */
@property (copy, nonatomic) NSString *driverId;
/* driverName */
@property (copy, nonatomic) NSString *driverName;
/* ID */
@property (copy, nonatomic) NSString *ID;
/* logTime */
@property (copy, nonatomic) NSString *logTime;
/* mileage */
@property (copy, nonatomic) NSString *mileage;
/* status */
@property (copy, nonatomic) NSString *status;
/* updateTime */
@property (copy, nonatomic) NSString *updateTime;

@end

NS_ASSUME_NONNULL_END
