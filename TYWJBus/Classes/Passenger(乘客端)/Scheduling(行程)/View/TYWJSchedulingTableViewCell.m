//
//  TYWJSchedulingTableViewCell.m
//  TYWJBus
//
//  Created by tywj on 2020/5/28.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJSchedulingTableViewCell.h"
#import "TYWJTripList.h"
NSString * const TYWJSchedulingTableViewCellID = @"TYWJSchedulingTableViewCellID";
@interface TYWJSchedulingTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *pointView;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headHeight;
@property (weak, nonatomic) IBOutlet UILabel *stationL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UILabel *numL;
@property (weak, nonatomic) IBOutlet UILabel *getoff_locL;
@property (weak, nonatomic) IBOutlet UILabel *getoff_timeL;
@property (weak, nonatomic) IBOutlet UILabel *geton_locL;
@property (weak, nonatomic) IBOutlet UILabel *geton_timeL;

@end

@implementation TYWJSchedulingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showHeaderView:(BOOL)show{
    if (show) {
        self.pointView.hidden = NO;
        self.dateL.hidden = NO;
        self.headHeight.constant = 50;
    } else {
        self.pointView.hidden = YES;
        self.dateL.hidden = YES;
        self.headHeight.constant = 0;
    }
}
-(void)confirgCellWithModel:(id)model{
    TYWJTripList *info = model;
    self.stationL.text = info.line_name;
    self.statusL.text = [TYWJCommonTool getTicketStatusWithStatus:info.status];
    self.numL.text = [NSString stringWithFormat:@"%@ %d人",info.city_code,info.number];
    self.geton_locL.text = info.geton_loc;
    
    
    NSString *str1 = [NSString stringWithFormat:@"%@(预计)",info.geton_time];
    NSMutableAttributedString *abc1 = [[NSMutableAttributedString alloc] initWithString:str1];
    [abc1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(str1.length - 4, 4)];
    self.geton_timeL.attributedText = abc1;
    self.getoff_locL.text = info.getoff_loc;
        NSString *str2 = [NSString stringWithFormat:@"(预计)%@",info.getoff_time];
    NSMutableAttributedString *abc2 = [[NSMutableAttributedString alloc] initWithString:str2];
    [abc2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 4)];
    self.getoff_timeL.attributedText = abc2;
    if (info.isFristDay) {
        self.dateL.text = info.line_date;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
