//
//  TYWJSchedulingStationView.m
//  TYWJBus
//
//  Created by tywj on 2020/5/29.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJSchedulingStationView.h"

@implementation TYWJSchedulingStationView
-(void)hiddenView{
    self.numL.hidden = YES;
    self.numLheight.constant = 0 ;
}
- (void)confirgViewWithModel:(TYWJTripList *)model{
    self.numL.text = [NSString stringWithFormat:@"乘车人数   %d人",model.number];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
