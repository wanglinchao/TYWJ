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
@property (weak, nonatomic) IBOutlet UILabel *checkInfoL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *lineName;
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
    self.lineName.text = model.line_name;
    self.moneyL.text = [NSString stringWithFormat:@"+￥%@",model.money];
    self.checkInfoL.text = [NSString stringWithFormat:@"验票数：%@人",model.inspect_num];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
