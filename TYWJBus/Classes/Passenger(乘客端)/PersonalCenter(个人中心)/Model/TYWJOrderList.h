//
//  TYWJOrderList.h
//  TYWJBus
//
//  Created by tywj on 2020/6/4.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJOrderList : NSObject
@property (copy, nonatomic) NSString *line_code;
@property (assign, nonatomic) int order_fee;
@property (copy, nonatomic) NSString *order_serial_no;
@property (assign, nonatomic) int order_status;
@property (copy, nonatomic) NSString *order_time;
@property (copy, nonatomic) NSString *line_name;

@end

NS_ASSUME_NONNULL_END
