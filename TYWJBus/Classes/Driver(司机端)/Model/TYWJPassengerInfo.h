//
//  TYWJPassengerInfo.h
//  TYWJBus
//
//  Created by tywj on 2020/6/12.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJPassengerInfo : NSObject
@property (assign, nonatomic) int inspect_flag;
@property (copy, nonatomic) NSString *passenger_phone;
@property (assign, nonatomic) int arrive_flag;
@property (copy, nonatomic) NSString *order_serial_no;
@end

NS_ASSUME_NONNULL_END
