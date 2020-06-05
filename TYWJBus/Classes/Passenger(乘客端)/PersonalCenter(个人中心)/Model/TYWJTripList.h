//
//  TYWJTripList.h
//  TYWJBus
//
//  Created by tywj on 2020/6/5.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJTripList : NSObject
@property (copy, nonatomic) NSString *goodsNo;
@property (copy, nonatomic) NSString *getonLoc;
@property (copy, nonatomic) NSString *orderSerialNo;
@property (assign, nonatomic) int updateTime;
@property (copy, nonatomic) NSString *getoffLoc;
@property (copy, nonatomic) NSString *lineCode;
@property (assign, nonatomic) int number;
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *vehicleNo;
@property (assign, nonatomic) int deleted;
@property (copy, nonatomic) NSString *lineDate;
@property (copy, nonatomic) NSString *orderDetailNo;
@property (assign, nonatomic) int createTime;
@property (copy, nonatomic) NSString *lineTime;
@property (assign, nonatomic) int id;
@property (assign, nonatomic) int status;
@property (copy, nonatomic) NSString *driverCode;
@property (copy, nonatomic) NSString *driverName;
@property (copy, nonatomic) NSString *providerCode;
@property (assign, nonatomic) int price;
@property (assign, nonatomic) int refundNumber;
@property (copy, nonatomic) NSString *vehicleCode;
@property (copy, nonatomic) NSString *providerName;
@end

NS_ASSUME_NONNULL_END
