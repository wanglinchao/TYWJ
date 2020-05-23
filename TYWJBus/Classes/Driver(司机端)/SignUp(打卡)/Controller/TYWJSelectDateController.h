//
//  TYWJSelectDateController.h
//  TYWJBus
//
//  Created by MacBook on 2018/12/24.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJSelectDateController : UIViewController

/* 选择后 */
@property (copy, nonatomic) void(^dateSelected)(NSString *dateString);
/* currentDateString */
@property (copy, nonatomic) NSString *currentDateString;

@end

NS_ASSUME_NONNULL_END
