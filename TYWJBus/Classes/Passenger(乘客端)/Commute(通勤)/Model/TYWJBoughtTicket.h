//
//  TYWJBoughtTicket.h
//  TYWJBus
//
//  Created by MacBook on 2018/11/27.
//  Copyright © 2018 MacBook. All rights reserved.
//  已买票

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJBoughtTicketInfo : NSObject

/* 手机号 */
@property (copy, nonatomic) NSString *phoneNum;
/* 线路 */
@property (copy, nonatomic) NSString *routeNum;
/* 已买日期  2018.12.07 */
@property (copy, nonatomic) NSString *boughtDate;
/* 是否已买 */
@property (copy, nonatomic, getter=isBought) NSString *bought;

@end

@interface TYWJBoughtTicket : NSObject

/* 手机号 */
@property (copy, nonatomic) NSString *yhm;
/* 已买信息 */
@property (copy, nonatomic) NSString *text;
/* info */
@property (strong, nonatomic) TYWJBoughtTicketInfo *info;

@end

NS_ASSUME_NONNULL_END
