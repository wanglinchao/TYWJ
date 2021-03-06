//
//  TYWJDetailStationCell.m
//  TYWJBus
//
//  Created by tywj on 2020/5/26.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJDetailStationCell.h"
NSString * const TYWJDetailStationCellID = @"TYWJDetailStationCellID";

@implementation TYWJDetailStationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)configCellWithData:(TYWJSubRouteListInfo *)data{
    _timeL.text = data.estimatedTime;
    _nameL.text = data.routeNum;
}
+ (instancetype)cellForTableView:(UITableView *)tableView
{
    static NSString *cellID = @"TYWJDetailStationCellID";
    TYWJDetailStationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    //    if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    //    }
    return cell;
}
- (IBAction)setStation:(UIButton *)sender {
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
