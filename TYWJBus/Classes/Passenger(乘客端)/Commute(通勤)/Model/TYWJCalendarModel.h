//
//  TYWJCalendarModel.h
//  TYWJBus
//
//  Created by tywj on 2020/6/6.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJCalendarModel : NSObject
@property (copy, nonatomic) NSString *store_no;
@property (copy, nonatomic) NSString *line_date;
@property (assign, nonatomic) NSString *all_line_time;
@property (assign, nonatomic) NSString *prime_price;
@property (copy, nonatomic) NSString *sell_price;
@property (assign, nonatomic) NSString *sell_time;
@property (copy, nonatomic) NSString *store_num;
@end

NS_ASSUME_NONNULL_END
