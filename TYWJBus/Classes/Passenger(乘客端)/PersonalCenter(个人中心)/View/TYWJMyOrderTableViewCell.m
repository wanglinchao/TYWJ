//
//  TYWJMyOrderTableViewCell.m
//  TYWJBus
//
//  Created by tywj on 2020/6/1.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJMyOrderTableViewCell.h"

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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
