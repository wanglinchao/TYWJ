//
//  TYWJSearchRouteResultCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/4.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJSearchRouteResultCell.h"
#import "TYWJSubRouteList.h"
#import "TYWJSearchReult.h"
#import "TYWJRouteList.h"


NSString * const TYWJSearchRouteResultCellID = @"TYWJSearchRouteResultCellID";

@interface TYWJSearchRouteResultCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *getupDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *endStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *getdownDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *desPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *getupTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *getdownTimeLabel;


@end

@implementation TYWJSearchRouteResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupView];
}

- (void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setBorderWithColor:[ZLNavTextColor colorWithAlphaComponent:0.5f]];
    [self setRoundViewWithCornerRaidus:8.f];
}

- (void)setResult:(TYWJSearchReult *)result {
    _result = result;
    
    self.titleLabel.text = result.routeInfo.routeName;
    //[NSString stringWithFormat:@"%@——%@",result.startStation.station,result.desStation.station];
    self.startPlaceLabel.text = [NSString stringWithFormat:@"%@(出发点)",result.beginPlace];
    self.desPlaceLabel.text = [NSString stringWithFormat:@"%@(目的地)",result.endPlace];
    self.getupDistanceLabel.text = [NSString stringWithFormat:@"距离%.0f米",result.getupDistance];
    self.getdownDistanceLabel.text = [NSString stringWithFormat:@"距离%.0f米",result.getdownDistance];
    self.beginStationLabel.text = result.beginStation.station;
    self.endStationLabel.text = result.endStation.station;
    self.getupTimeLabel.text = result.beginStation.time;
    self.getdownTimeLabel.text = result.endStation.time;
    
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 10.f;
    frame.origin.x = 10.f;
    frame.size.width -= 20.f;
    frame.size.height -= 10.f;
    [super setFrame:frame];
}

- (IBAction)purchaseClicked:(id)sender {
    ZLFuncLog;
    if (self.purchaseBtnClicked) {
        self.purchaseBtnClicked(self.result);
    }
}

@end
