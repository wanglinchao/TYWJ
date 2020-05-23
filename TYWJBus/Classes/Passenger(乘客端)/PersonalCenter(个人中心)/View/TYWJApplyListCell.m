//
//  TYWJApplyListCell.m
//  TYWJBus
//
//  Created by tywj on 2020/3/11.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJApplyListCell.h"
#import "TYWJApplyList.h"
#import "TYWJRouteList.h"

@interface TYWJApplyListCell ()
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *startStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *endStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *upTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *downTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *backTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *backLabel;
@property (weak, nonatomic) IBOutlet UILabel *backInfoLabel;

@end

@implementation TYWJApplyListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
}

+ (instancetype)cellForTableView:(UITableView *)tableView
{
    static NSString *cellID = @"applyListCell";
    TYWJApplyListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = 10;
    frame.size.width -= 2 * 10;
    frame.size.height -= 10;
    frame.origin.y += 10;
    
    [super setFrame:frame];
}

- (void)setApplyListInfo:(TYWJApplyListInfo *)applyListInfo
{
    _applyListInfo = applyListInfo;
    self.beginTimeLabel.text = applyListInfo.update_time;
    self.startStationLabel.text = applyListInfo.jtzz;
    self.endStationLabel.text = applyListInfo.gsdz;
    self.stateLabel.text = applyListInfo.status;
    self.numLabel.text = [NSString stringWithFormat:@"编号%@",applyListInfo.routeNum];
//    self.numLabel.text = applyListInfo.
    if ([applyListInfo.kind isEqualToString:@"往返线路"]) {
        self.backLabel.hidden = NO;
        self.backInfoLabel.hidden = NO;
        self.backTimeLabel.hidden = NO;
        self.upTimeLabel.hidden = YES;
        self.downTimeLabel.hidden = NO;
        self.downTimeLabel.text = [NSString stringWithFormat:@"（%@上班）",applyListInfo.sbsj];
        self.backTimeLabel.text = [NSString stringWithFormat:@"（%@下班）",applyListInfo.xbsj];
    }else {
        self.backLabel.hidden = YES;
        self.backInfoLabel.hidden = YES;
        self.backTimeLabel.hidden = YES;
        if ([applyListInfo.kind isEqualToString:@"上班线路"]) {
            self.downTimeLabel.hidden = NO;
            self.upTimeLabel.hidden = YES;
            self.downTimeLabel.text = [NSString stringWithFormat:@"（%@上班）",applyListInfo.sbsj];
        }else {
            self.upTimeLabel.hidden = NO;
            self.downTimeLabel.hidden = YES;
            self.upTimeLabel.text = [NSString stringWithFormat:@"（%@下班）",applyListInfo.xbsj];
        }
    }
}

@end
