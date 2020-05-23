//
//  TYWJLastSeats.h
//  TYWJBus
//
//  Created by MacBook on 2018/11/20.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJLastSeatsInfo : NSObject

/* 乘车时间 */
@property (copy, nonatomic) NSString *ccsj;
/* 线路 */
@property (copy, nonatomic) NSString *routeNum;
/* 满载人数 */
@property (copy, nonatomic) NSString *allSeats;
/* 余座 */
@property (copy, nonatomic) NSString *lastSeats;

@end

@interface TYWJLastSeats : NSObject

/* 乘车时间 */
@property (copy, nonatomic) NSString *yupiao;
/* text */
@property (copy, nonatomic) NSString *text;
/* seatsInfo */
@property (strong, nonatomic) TYWJLastSeatsInfo *seatsInfo;

@end

NS_ASSUME_NONNULL_END
