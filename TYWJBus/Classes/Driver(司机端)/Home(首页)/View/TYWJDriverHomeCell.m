//
//  TYWJDriverHomeCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/30.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJDriverHomeCell.h"
#import "TYWJDriverRouteList.h"
#import "TYWJBorderButton.h"

NSString * const TYWJDriverHomeCellID = @"TYWJDriverHomeCellID";

@interface TYWJDriverHomeCell()

@property (weak, nonatomic) IBOutlet UILabel *stationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet TYWJBorderButton *launchBtn;
@property (weak, nonatomic) IBOutlet UILabel *routeNameLabel;


@end

@implementation TYWJDriverHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    [self setRoundViewWithCornerRaidus:6.f];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setBorderWithColor:ZLNavTextColor];
    [self setBorderWidth:0.3f];
}

- (void)setListInfo:(TYWJDriverRouteListInfo *)listInfo {
    _listInfo = [listInfo copy];
    
    self.stationLabel.text = [NSString stringWithFormat:@"%@——%@",listInfo.startStation,listInfo.endStation];
    self.timeLabel.text = [NSString stringWithFormat:@"%@(始发)-%@(到达)",listInfo.startTime,listInfo.endTime];
    self.routeNameLabel.text = listInfo.routeName;
    if ([listInfo.carStatus isEqualToString:@"已发车"]) {
        [self.launchBtn setTitle:@"已发车" forState:UIControlStateNormal];
        self.launchBtn.enabled = YES;
    }else {
        [self.launchBtn setTitle:@"出发" forState:UIControlStateNormal];
        self.launchBtn.enabled = YES;
    }
    
    NSDictionary *att = @{NSFontAttributeName : [UIFont systemFontOfSize:12.f],
                          NSForegroundColorAttributeName : [UIColor grayColor]
                          };
    NSString *string = [NSString stringWithFormat:@"应上车人数:%d人",listInfo.passengerNum.intValue - listInfo.lastSeats.intValue];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string attributes:att];
    [attString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f],NSForegroundColorAttributeName : [[UIColor redColor] colorWithAlphaComponent:0.6f]} range:NSMakeRange(6, string.length - 7)];
    self.tipsLabel.attributedText = attString;
    
}


- (void)setFrame:(CGRect)frame {
    frame.origin.x = 10.f;
    frame.origin.y += 10.f;
    frame.size.width -= 20.f;
    frame.size.height -= 10.f;
    [super setFrame:frame];
}
- (IBAction)launchClicked:(id)sender {
    ZLFuncLog;
    //TYWJRequestDriverLuanchCar
    if (self.launchBtnClicked) {
        self.launchBtnClicked();
    }
}

@end
