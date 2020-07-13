//
//  TYWJTableViewControllerCell.m
//  TYWJBus
//
//  Created by tywj on 2020/6/11.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJDriverHomeCell.h"
#import "TYWJDriveHomeList.h"
@interface TYWJDriverHomeCell ()
@property (weak, nonatomic) IBOutlet UILabel *lineName;
@property (weak, nonatomic) IBOutlet UILabel *lineTime;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UILabel *missingCardL;
@property (weak, nonatomic) IBOutlet UILabel *checkInfoL;

@end
@implementation TYWJDriverHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellForTableView:(UITableView *)tableView
{
    NSString *className = [NSString stringWithFormat:@"%@",[self class]];
    TYWJDriverHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@ID",className]];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil] firstObject];
    }
    return cell;
}
-(void)confirgCellWithParam:(id)Param{
    TYWJDriveHomeList *model = (TYWJDriveHomeList*)Param;
    self.lineName.text = [NSString stringWithFormat:@"%@                                                                                             ",model.line_name];
    self.lineTime.text = model.line_time;
    NSString *statusStr = @"";
    switch (model.status) {
        case 1:
            statusStr = @"待发车";
            break;
        case 2:
            statusStr = @"进行中";
            break;
        case 3:
            statusStr = @"已完成";
            break;
        default:
            break;
    }
    self.statusL.text = statusStr;
    self.singnBtn.hidden = YES;
    self.missingCardL.hidden = YES;

    if (model.punch_flag == 0) {
        self.singnBtn.hidden = NO;
        if (model.start_punch == 0 && model.end_punch == 0 ) {
            [self.singnBtn setTitle:@"开始打卡" forState:UIControlStateNormal];
        } else if (model.start_punch == 1 && model.end_punch == 0 ) {
            [self.singnBtn setTitle:@"结束打卡" forState:UIControlStateNormal];
        } else{
            self.singnBtn.hidden = YES;
            self.missingCardL.hidden = NO;
            self.missingCardL.text = @"已完成";
        }
    }else{
        self.missingCardL.hidden = NO;

        NSString *punchStatusStr = @"";
        switch (model.punch_flag) {
            case 1:
                punchStatusStr = @"已完成";
                break;
            case 2:
                punchStatusStr = @"缺卡";
                break;
            default:
                break;
        }
        self.missingCardL.text = punchStatusStr;
    }
    self.checkInfoL.text = [NSString stringWithFormat:@"验票/乘客数：%d/%d",model.inspect_ticket_num,model.assign_seate_no];
}
- (IBAction)signAction:(UIButton *)sender {
    if (self.buttonSeleted)
       {
           self.buttonSeleted(sender.tag);
       }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
