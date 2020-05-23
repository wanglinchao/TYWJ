//
//  TYWJDriverLicensesCell.m
//  TYWJBus
//
//  Created by MacBook on 2018/12/14.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJDriverLicensesCell.h"
#import "TYWJMileageLog.h"


NSString * const TYWJDriverLicensesCellID = @"TYWJDriverLicensesCellID";

@interface TYWJDriverLicensesCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *licenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *mileageLabel;
/* dateFormatter */
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation TYWJDriverLicensesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy.MM.dd HH:mm";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMileageLog:(TYWJMileageLog *)mileageLog {
    _mileageLog = mileageLog;
    
    self.timeLabel.text = [self.dateFormatter stringFromDate: [NSDate dateWithTimeIntervalSince1970:mileageLog.logTime.integerValue/1000]];
    self.licenseLabel.text = mileageLog.carNumber;
    self.mileageLabel.text = [NSString stringWithFormat:@"%@km",mileageLog.mileage];
}

@end
