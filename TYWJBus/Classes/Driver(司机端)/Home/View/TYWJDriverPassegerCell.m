//
//  TYWJTableViewControllerCell.m
//  TYWJBus
//
//  Created by tywj on 2020/6/11.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJDriverPassegerCell.h"
#import "TYWJPassengerInfo.h"
@interface TYWJDriverPassegerCell ()
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet UILabel *serialNoL;
@property (weak, nonatomic) IBOutlet UIImageView *ischeck;
@property (weak, nonatomic) IBOutlet UIImageView *isarrive;


@end
@implementation TYWJDriverPassegerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellForTableView:(UITableView *)tableView
{
    NSString *className = [NSString stringWithFormat:@"%@",[self class]];
    TYWJDriverPassegerCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@ID",className]];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil] firstObject];
    }
    return cell;
}
-(void)confirgCellWithParam:(id)Param{
    TYWJPassengerInfo *model = (TYWJPassengerInfo*)Param;
    self.phoneL.text = model.passenger_phone;
    self.serialNoL.text = model.order_serial_no;
    if (model.arrive_flag > 0) {
        [self.isarrive setImage:[UIImage imageNamed:@"司机端已验票矩形"]];
    } else {
        [self.isarrive setImage:[UIImage imageNamed:@"司机端未验票矩形"]];
    }
    if (model.inspect_flag > 1) {
        [self.ischeck setImage:[UIImage imageNamed:@"司机端已验票矩形"]];
    } else {
        [self.ischeck setImage:[UIImage imageNamed:@"司机端未验票矩形"]];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
