//
//  TYWJOrderDetail.h
//  TYWJBus
//
//  Created by tywj on 2020/6/5.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJOrderDetail : NSObject
@property (copy, nonatomic) NSArray *date_collections;
@property (assign, nonatomic) int discount_fee;
@property (copy, nonatomic) NSString *get_off_loc;
@property (copy, nonatomic) NSString *get_on_loc;
@property (copy, nonatomic) NSString *line_code;
@property (assign, nonatomic) int order_fee;
@property (copy, nonatomic) NSString *order_serial_no;
@property (assign, nonatomic) int order_status;
@property (copy, nonatomic) NSString *order_time;
@property (copy, nonatomic) NSString *pay_time;
@property (copy, nonatomic) NSString *refund_fee;
@property (assign, nonatomic) int number;
@end

NS_ASSUME_NONNULL_END
