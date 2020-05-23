//
//  TYWJCalendarList.h
//  TYWJBus
//
//  Created by MacBook on 2018/11/28.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJCalendarList : NSObject

/* 是否已买 */
@property (assign, nonatomic) BOOL buy;
/* 日期 */
@property (copy, nonatomic) NSString *riqi;
/* 是否售罄 */
@property (assign, nonatomic) BOOL sellOut;
/* 是否能购买 */
@property (assign, nonatomic) BOOL status;
/* 剩余票数 */
@property (assign, nonatomic) NSInteger ticketNum;

@end

NS_ASSUME_NONNULL_END
