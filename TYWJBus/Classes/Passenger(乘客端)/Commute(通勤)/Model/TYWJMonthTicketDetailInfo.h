//
//  TYWJMonthTicketDetailInfo.h
//  TYWJBus
//
//  Created by MacBook on 2019/2/12.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJMonthTicketDetailInfo : NSObject

/* 月票价格 */
@property (copy, nonatomic) NSString *ypjg;
/* 是否售卖月票 */
@property (assign, nonatomic) BOOL sfyp;
/* 是否月票开放购买时间 */
@property (assign, nonatomic) BOOL ypOpenTime;
/* 月票天数 */
@property (assign, nonatomic) NSInteger ypDays;

@end

NS_ASSUME_NONNULL_END
