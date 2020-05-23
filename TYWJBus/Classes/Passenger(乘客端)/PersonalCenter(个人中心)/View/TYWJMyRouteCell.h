//
//  TYWJMyRouteCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/28.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJTicketListInfo,TYWJTicketListMonthInfo,TYWJPeriodDetailTicket;

UIKIT_EXTERN NSString * const TYWJMyRouteCellID;


@interface TYWJMyRouteCell : UITableViewCell

/* ticket */
@property (strong, nonatomic) TYWJTicketListInfo *ticket;
/* TYWJPeriodDetailTicket */
@property (strong, nonatomic) TYWJPeriodDetailTicket *periodTicket;

@end
