//
//  TYWJDriverAchievementCell.m
//  TYWJBus
//
//  Created by tywj on 2020/6/11.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJDriverAchievementCell.h"
#import "TYWJAchievementinfo.h"
@interface TYWJDriverAchievementCell ()
@property (weak, nonatomic) IBOutlet UILabel *create_date;
@property (weak, nonatomic) IBOutlet UILabel *order_id;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (weak, nonatomic) IBOutlet UILabel *body;

@end
@implementation TYWJDriverAchievementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellForTableView:(UITableView *)tableView
{
    NSString *className = [NSString stringWithFormat:@"%@",[self class]];
    TYWJDriverAchievementCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@ID",className]];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil] firstObject];
    }
    return cell;
}
-(void)confirgCellWithParam:(id)Param{
    TYWJAchievementinfo *model = (TYWJAchievementinfo*)Param;
    self.create_date.text = model.create_date;
    self.subject.text = model.subject;

    self.body.text = model.body;

    self.amount.text = [NSString stringWithFormat:@"%@¥%d",model.positive?@"+":@"-",model.amount];

    self.order_id.text = [NSString stringWithFormat:@"用户订单ID：%@",model.order_id];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
