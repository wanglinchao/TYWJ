//
//  TYWJMonthTicket.h
//  TYWJBus
//
//  Created by MacBook on 2019/2/14.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJMonthTicket : NSObject

/* ch */
@property (copy, nonatomic) NSString *ch;
/* cho */
@property (copy, nonatomic) NSString *chp;
/* gmqsz */
@property (copy, nonatomic) NSString *gmqsz;
/* gmzdz */
@property (copy, nonatomic) NSString *gmzdz;
/* num */
@property (copy, nonatomic) NSString *num;
/* orderId */
@property (copy, nonatomic) NSString *orderId;
/* scsj */
@property (copy, nonatomic) NSString *scsj;
/* xcsj */
@property (copy, nonatomic) NSString *xcsj;
/* xlmc */
@property (copy, nonatomic) NSString *xlmc;
/* 月份 */
@property (copy, nonatomic) NSString *yf;
/* yhm */
@property (copy, nonatomic) NSString *yhm;

@end

NS_ASSUME_NONNULL_END
