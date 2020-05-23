//
//  TYWJPeriodTicketCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/2.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJPeriodTicketCell.h"
#import "TYWJBorderButton.h"
#import "TYWJPeirodTicket.h"
#import "NSString+Size.h"



static CGFloat const TYWJPeriodTicketCellH = 100.f;
NSString * const TYWJPeriodTicketCellID = @"TYWJPeriodTicketCellID";

@interface TYWJPeriodTicketCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet TYWJBorderButton *ticketBtn;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;


@end

@implementation TYWJPeriodTicketCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupView];
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    [self setRoundViewWithCornerRaidus:6.f];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.ticketBtn.userInteractionEnabled = NO;
}

- (void)setTicket:(TYWJPeriodTicketInfo *)ticket {
    _ticket = ticket;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@%@",[TYWJCommonTool sharedTool].selectedCity.city,ticket.title];
    [self.ticketBtn setTitle:[NSString stringWithFormat:@"¥%@购买",ticket.price] forState:UIControlStateNormal];
}

#pragma mark - layoutSubviews
- (void)setFrame:(CGRect)frame {
    CGFloat x = 15.f;
    CGFloat y = 10.f;
    frame.size.width = ZLScreenWidth - 2*x;
    frame.size.height = TYWJPeriodTicketCellH - y;
    frame.origin.x = x;
    [super setFrame:frame];
}




@end
