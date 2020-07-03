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








@property (copy, nonatomic) NSString *city_code;
@property (copy, nonatomic) NSString *city_name;
@property (copy, nonatomic) NSString *getoff_loc;
@property (copy, nonatomic) NSString *getoff_time;
@property (copy, nonatomic) NSString *geton_loc;
@property (copy, nonatomic) NSString *geton_time;
@property (copy, nonatomic) NSString *goods_no;
@property (copy, nonatomic) NSString *line_date;
@property (copy, nonatomic) NSString *line_name;
@property (copy, nonatomic) NSString *line_time;
@property (copy, nonatomic) NSString *line_code;
@property (copy, nonatomic) NSString *ticket_code;

@property (assign, nonatomic) int number;
@property (assign, nonatomic) int refund_number;
@property (assign, nonatomic) int status;
@property (copy, nonatomic) NSString *vehicle_no;
@property (assign, nonatomic) BOOL isFristDay;

@end

NS_ASSUME_NONNULL_END
