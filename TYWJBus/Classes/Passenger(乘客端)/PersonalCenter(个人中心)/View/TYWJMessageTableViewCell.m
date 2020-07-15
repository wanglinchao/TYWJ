//
//  TYWJMessageTableViewCell.m
//  TYWJBus
//
//  Created by tywj on 2020/5/30.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJMessageTableViewCell.h"
#import "TYWJMessageModel.h"
NSString * const TYWJMessageTableViewCellID = @"TYWJMessageTableViewCellID";
@interface TYWJMessageTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UIView *readView;

@end
@implementation TYWJMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellForTableView:(UITableView *)tableView
{
    NSString *className = [NSString stringWithFormat:@"%@",[self class]];
    TYWJMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@ID",className]];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil] firstObject];
    }
    return cell;
}
- (void)confirgCellWithParam:(id)Param{
    TYWJMessageModel *model = Param;
    self.contentL.text = model.content;
    self.timeL.text = [TYWJCommonTool getdateStringWithInt:model.createDate];
    self.titleL.text = model.title;
    if (model.read) {
        self.readView.hidden = YES;
    } else {
        self.readView.hidden = NO;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
