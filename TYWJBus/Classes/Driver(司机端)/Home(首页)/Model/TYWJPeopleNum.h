//
//  TYWJPeopleNum.h
//  TYWJBus
//
//  Created by Harley He on 2018/8/2.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYWJPeopleNumInfo : NSObject

/* 日期 */
@property (copy, nonatomic) NSString *date;
/* 线路编号 */
@property (copy, nonatomic) NSString *routeNum;
/* 站编号 */
@property (copy, nonatomic) NSString *stationNum;
/* 站名 */
@property (copy, nonatomic) NSString *station;
/* 车上人数 */
@property (copy, nonatomic) NSString *busPassengers;
/* 应上车人数 */
@property (copy, nonatomic) NSString *getupPassengers;
/* 应下车人数 */
@property (copy, nonatomic) NSString *getdownPassengers;

@end

@interface TYWJPeopleNum : NSObject

/* rs */
@property (copy, nonatomic) NSString *rs;
/* text */
@property (copy, nonatomic) NSString *text;
/* TYWJPeopleNum */
@property (strong, nonatomic) TYWJPeopleNumInfo *numInfo;

@end
