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
@property (weak, nonatomic) IBOutlet UILabel *line_name;

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
    self.line_name.text = model.line_name;
    NSString *str = [NSString stringWithFormat:@"订单金额：¥%@",GetPriceString(model.order_fee)];
    NSRange range = NSMakeRange(6, str.length - 6);
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#363636"] range:range];
    [attriStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:range];
    self.order_fee.attributedText = attriStr;
    self.order_serial_no.text = [NSString stringWithFormat:@"订单编号：%@",model.order_serial_no];
    self.order_time.text = [NSString stringWithFormat:@"订单时间：%@",model.order_time];
    self.order_status.text = [TYWJCommonTool getOrderStatusWithStatus:model.order_status];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
