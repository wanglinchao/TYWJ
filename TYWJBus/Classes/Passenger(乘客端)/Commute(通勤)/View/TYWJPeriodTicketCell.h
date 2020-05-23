//
//  TYWJPeriodTicketCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/7/2.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJPeriodTicketInfo;

UIKIT_EXTERN NSString * const TYWJPeriodTicketCellID;

@interface TYWJPeriodTicketCell : UITableViewCell

/* ticket */
@property (strong, nonatomic) TYWJPeriodTicketInfo *ticket;

@end
