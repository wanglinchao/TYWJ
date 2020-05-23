//
//  TYWJMonthTicketCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/14.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJMonthTicketCell.h"


NSString * const TYWJMonthTicketCellID = @"TYWJMonthTicketCellID";


@interface TYWJMonthTicketCell()

@property (weak, nonatomic) IBOutlet UIView *bodyView;
@property (weak, nonatomic) IBOutlet UIButton *usageBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *duetimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;


@end

@implementation TYWJMonthTicketCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupView];
}

- (void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.bodyView setRoundViewWithCornerRaidus:6.f];
    [self.bodyView setBorderWithColor:ZLGrayColorWithRGB(222.f)];
    self.bodyView.backgroundColor = ZLGlobalBgColor;
}

- (void)addTarget:(id)target action:(SEL)action {
    [self.usageBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


- (void)setDays:(NSInteger)days {
    _days = days;
    
    NSString *month = [TYWJCommonTool sharedTool].nextMonth;
    NSString *year = [TYWJCommonTool sharedTool].nextYear;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.02f/张",self.ticketPrice];
    
    self.daysLabel.text = [NSString stringWithFormat:@"共:%ld天",days];
    self.monthLabel.text = [NSString stringWithFormat:@"%@月份",month];
    self.feeLabel.text = [NSString stringWithFormat:@"¥%.02f",self.ticketPrice*days];
    self.duetimeLabel.text = [NSString stringWithFormat:@"%@-%@-01至%@-%@-%d有效",year,month,year,month,[TYWJCommonTool sharedTool].nextMonthDays];
}
@end
