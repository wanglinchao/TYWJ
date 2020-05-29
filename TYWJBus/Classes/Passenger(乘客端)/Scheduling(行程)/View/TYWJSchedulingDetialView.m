//
//  TYWJSchedulingDetialView.m
//  TYWJBus
//
//  Created by tywj on 2020/5/29.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJSchedulingDetialView.h"

@implementation TYWJSchedulingDetialView
- (void)drawRect:(CGRect)rect {
    TYWJSchedulingStationView *view = [[[NSBundle mainBundle] loadNibNamed:@"TYWJSchedulingStationView" owner:self options:nil] lastObject];
    [self.stationView addSubview: view ];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
