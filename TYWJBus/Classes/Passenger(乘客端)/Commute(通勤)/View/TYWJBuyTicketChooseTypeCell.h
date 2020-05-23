//
//  TYWJBuyTicketChooseTypeCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/12.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const TYWJBuyTicketChooseTypeCellID;


@interface TYWJBuyTicketChooseTypeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UIButton *chooseTimeAction;
@property (copy, nonatomic) void(^buttonSeleted)(NSInteger index);



@end
