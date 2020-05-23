//
//  TYWJMyTicketTableCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/21.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJApplyRoute;

UIKIT_EXTERN NSString * const TYWJMyTicketTableCellID;

@interface TYWJMyTicketTableCell : UITableViewCell

/* model */
@property (strong, nonatomic) TYWJApplyRoute *model;

@end
