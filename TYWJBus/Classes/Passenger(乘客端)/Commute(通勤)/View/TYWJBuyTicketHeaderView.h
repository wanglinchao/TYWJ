//
//  TYWJBuyTicketHeaderView.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/8.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYWJBuyTicketHeaderView : UIView

@property (weak, nonatomic, readonly) IBOutlet UIButton *selectButton;
@property (weak, nonatomic, readonly) IBOutlet UILabel *ticketTypeLabel;
@property (weak, nonatomic, readonly) IBOutlet UILabel *tipsLabel;

@end
