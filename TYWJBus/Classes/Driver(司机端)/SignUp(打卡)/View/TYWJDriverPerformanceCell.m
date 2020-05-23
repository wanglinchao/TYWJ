//
//  TYWJDriverPerformanceCell.m
//  TYWJBus
//
//  Created by MacBook on 2018/12/28.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJDriverPerformanceCell.h"
#import "TYWJBonus.h"

NSString * const TYWJDriverPerformanceCellID = @"TYWJDriverPerformanceCellID";

@interface TYWJDriverPerformanceCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stationLabel;
@property (weak, nonatomic) IBOutlet UILabel *bonusLabel;

/* formatter */
@property (strong, nonatomic) NSDateFormatter *formatter;

@end

@implementation TYWJDriverPerformanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    self.formatter = formatter;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInfo:(TYWJBonusInfo *)info {
    _info = info;
    
    self.timeLabel.text = [self.formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:info.createTime.integerValue/1000]];
    self.stationLabel.text = [NSString stringWithFormat:@"%@——%@",info.depart,info.arrive];
    self.bonusLabel.text = [NSString stringWithFormat:@"¥%@",info.amount];
    
}

@end
