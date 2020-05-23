//
//  TYWJComplaintFooter.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/21.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TYWJTextVeiw;

@interface TYWJComplaintFooter : UIView

@property (weak, nonatomic, readonly) IBOutlet TYWJTextVeiw *tv;
@property (weak, nonatomic, readonly) IBOutlet UIView *contentView;
/* 是否是退票界面 */
@property (assign, nonatomic) BOOL isRefundTicket;

/* 退票点击 */
@property (copy, nonatomic) void(^quitTicketClicked)(NSString *reason);
/* 投诉点击 */
@property (copy, nonatomic) void(^complaintClicked)(NSString *reason);


@end
