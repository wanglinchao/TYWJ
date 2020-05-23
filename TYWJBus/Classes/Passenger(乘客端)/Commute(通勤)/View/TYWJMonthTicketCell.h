//
//  TYWJMonthTicketCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/14.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const TYWJMonthTicketCellID;

@interface TYWJMonthTicketCell : UITableViewCell

- (void)addTarget:(id)target action:(nonnull SEL)action;

/* ticketPrice */
@property (assign, nonatomic) CGFloat ticketPrice;
/* 月票天数 */
@property (assign, nonatomic) NSInteger days;

@end
