//
//  TYWJBonus.h
//  TYWJBus
//
//  Created by MacBook on 2018/12/28.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJBonusInfo : NSObject

/* status */
@property (copy, nonatomic) NSString *status;
/* updateTime */
@property (copy, nonatomic) NSString *updateTime;
/* depart */
@property (copy, nonatomic) NSString *depart;
/* arrive */
@property (copy, nonatomic) NSString *arrive;
/* sent */
@property (copy, nonatomic) NSString *sent;
/* day */
@property (copy, nonatomic) NSString *day;
/* amount */
@property (copy, nonatomic) NSString *amount;
/* userId */
@property (copy, nonatomic) NSString *userId;
/* tripId */
@property (copy, nonatomic) NSString *tripId;
/* createTime */
@property (copy, nonatomic) NSString *createTime;
/* id */
@property (copy, nonatomic) NSString *ID;

@end

@interface TYWJBonus : NSObject

/* monthSum */
@property (copy, nonatomic) NSString *monthSum;
/* bonus */
@property (strong, nonatomic) NSArray *bonus;

@end

NS_ASSUME_NONNULL_END
