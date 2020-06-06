//
//  TYWJMyOrderTableViewCell.m
//  TYWJBus
//
//  Created by tywj on 2020/6/1.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJMyOrderTableViewCell.h"
@interface TYWJMyOrderTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *order_serial_no;
@property (weak, nonatomic) IBOutlet UILabel *order_time;
@property (weak, nonatomic) IBOutlet UILabel *order_fee;
@property (weak, nonatomic) IBOutlet UILabel *order_status;

@end
@implementation TYWJMyOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellForTableView:(UITableView *)tableView
{
    static NSString *cellID = @"myOrderTableViewCellID";
    TYWJMyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}
-(void)confirgCellWithModel:(TYWJOrderList *)model{
    self.order_fee.text = [NSString stringWithFormat:@"订单金额：%d",model.order_fee];
    self.order_serial_no.text = [NSString stringWithFormat:@"订单编号：%@",model.order_serial_no];
    self.order_time.text = [NSString stringWithFormat:@"订单时间：%@",model.order_time];
    NSString *statusStr = @"";
    switch (model.order_status) {
        case 0:
            statusStr = @"0";
            break;
            case 1:
            statusStr = @"1";
                break;
            case 2:
            statusStr = @"2";
                break;
            case 3:
            statusStr = @"3";
                break;
            case 4:
            statusStr = @"4";
                 break;
        default:
            break;
    }
    self.order_status.text = statusStr;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
