//
//  TYWJMyTicketsCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/15.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJTicketListInfo,TYWJMonthTicket;

UIKIT_EXTERN NSString * const TYWJMyTicketsCellID;

@interface TYWJMyTicketsCell : UICollectionViewCell

/* TYWJTicketListInfo */
@property (strong, nonatomic) TYWJTicketListInfo *ticket;
/* monthticket */
@property (strong, nonatomic) TYWJMonthTicket *monthTicket;

@end
