//
//  TYWJDriverSignUpCheckRouteCell.m
//  TYWJBus
//
//  Created by MacBook on 2018/12/24.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJDriverSignUpCheckRouteCell.h"
#import "TYWJTripsModel.h"

NSString * const TYWJDriverSignUpCheckRouteCellID = @"TYWJDriverSignUpCheckRouteCellID";

@interface TYWJDriverSignUpCheckRouteCell()
@property (weak, nonatomic) IBOutlet UILabel *stationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *licenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mileagesLabel;
/* formatter */
@property (strong, nonatomic) NSDateFormatter *formatter;

@end

@implementation TYWJDriverSignUpCheckRouteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setBorderWithColor:ZLNavTextColor];
    [self setBorderWidth:0.5];
    [self setRoundViewWithCornerRaidus:8.f];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    self.formatter = formatter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTrips:(TYWJTripsModel *)trips {
    _trips = trips;
    
    if (trips) {
        
        NSString *depTime = trips.schedule;
        NSString *arrTime = @"无数据";
        if (trips.departTime) {
            depTime = [self.formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:trips.departTime.integerValue/1000]];
        }
        if (trips.arriveTime) {
            arrTime = [self.formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:trips.arriveTime.integerValue/1000]];
        }
        self.stationsLabel.text = [NSString stringWithFormat:@"%@(%@)——%@(%@)",trips.departStation.name,depTime,trips.arriveStation.name,arrTime];
        self.licenceLabel.text = trips.carNumber;
        NSString *m = nil;
        if (trips.distance) {
            m = trips.distance;
        }else {
            m = @"0";
        }
        self.mileagesLabel.text = [NSString stringWithFormat:@"班次实应跑:%@km  班次实跑:%.2fkm",trips.line.distance,m.integerValue/1000.f];
    }
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x = 10.f;
    frame.origin.y += 10.f;
    frame.size.width -= 20.f;
    frame.size.height -= 10.f;
    [super setFrame:frame];
}

@end
