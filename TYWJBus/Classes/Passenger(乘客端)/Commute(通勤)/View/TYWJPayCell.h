//
//  TYWJPayCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/14.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJRouteListInfo,TYWJPeriodTicketInfo;

UIKIT_EXTERN NSString * const TYWJPayCellID;

@interface TYWJPayCell : UITableViewCell

/* couponClicked */
@property (copy, nonatomic) void(^couponClicked)(void);
/* 乘车日期 */
@property (copy, nonatomic) NSArray *ticketDates;
/* totalFee */
@property (copy, nonatomic) NSString *totalFee;
/* 是否是单次票 */
@property (assign, nonatomic, getter=isSingleTicket) BOOL singleTicket;
/* 乘车信息 */
@property (copy, nonatomic) TYWJRouteListInfo *info;
/* TYWJPeriodTicketInfo */
@property (strong, nonatomic) TYWJPeriodTicketInfo *periodTicket;
/* startStation */
@property (copy, nonatomic) NSString *startStation;
/* desStation */
@property (copy, nonatomic) NSString *desStation;
@property (weak, nonatomic, readonly) IBOutlet UIButton *alipayBtn;
/* ticketNums */
@property (assign, nonatomic) int ticketNums;

@end
