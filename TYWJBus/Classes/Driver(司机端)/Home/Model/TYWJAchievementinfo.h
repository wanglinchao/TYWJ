//
//  TYWJAchievementinfo.h
//  TYWJBus
//
//  Created by tywj on 2020/6/12.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJAchievementinfo : NSObject
@property (assign, nonatomic) int amount;
@property (copy, nonatomic) NSString *body;
@property (copy, nonatomic) NSString *create_date;
@property (assign, nonatomic) int create_time;
@property (copy, nonatomic) NSString *flow_no;
@property (assign, nonatomic) int inspect_num;
@property (copy, nonatomic) NSString *order_id;
@property (copy, nonatomic) NSString *order_type;
@property (assign, nonatomic) BOOL positive;
@property (copy, nonatomic) NSString *subject;
@property (copy, nonatomic) NSString *trade_type;
@property (copy, nonatomic) NSString *user_id;
@end

NS_ASSUME_NONNULL_END
