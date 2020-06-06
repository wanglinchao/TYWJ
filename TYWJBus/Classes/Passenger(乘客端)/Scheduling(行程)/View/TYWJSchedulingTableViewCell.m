//
//  TYWJSchedulingTableViewCell.m
//  TYWJBus
//
//  Created by tywj on 2020/5/28.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJSchedulingTableViewCell.h"
#import "TYWJTripList.h"
NSString * const TYWJSchedulingTableViewCellID = @"TYWJSchedulingTableViewCellID";
@interface TYWJSchedulingTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *pointView;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headHeight;
@property (weak, nonatomic) IBOutlet UILabel *stationL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UILabel *numL;

@end

@implementation TYWJSchedulingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showHeaderView:(BOOL)show{
    if (show) {
        self.pointView.hidden = NO;
        self.dateL.hidden = NO;
        self.headHeight.constant = 50;
    } else {
        self.pointView.hidden = YES;
        self.dateL.hidden = YES;
        self.headHeight.constant = 0;
    }
}
-(void)confirgCellWithModel:(id)model{
    TYWJTripList *info = model;
    self.stationL.text = [NSString stringWithFormat:@"%@-%@",info.getonLoc,info.getoffLoc];
    self.statusL.text = [NSString stringWithFormat:@"%d",info.status];
    self.numL.text = [NSString stringWithFormat:@"%d人",info.number];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
