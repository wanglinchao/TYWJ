//
//  TYWJDriverMapTipsView.m
//  TYWJBus
//
//  Created by MacBook on 2018/12/12.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJDriverMapTipsView.h"
#import "TYWJTripsModel.h"


@interface TYWJDriverMapTipsView()

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopStationLabel;


@end

@implementation TYWJDriverMapTipsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (void)setTrip:(TYWJTripsModel *)trip {
    _trip = trip;
    
    self.distanceLabel.text = trip.line.distance;
    self.timeLabel.text = trip.line.elapsedTime;
    self.startTimeLabel.text = trip.schedule;
    self.startStationLabel.text = trip.departStation.name;
    self.stopStationLabel.text = trip.arriveStation.name;
}

@end
