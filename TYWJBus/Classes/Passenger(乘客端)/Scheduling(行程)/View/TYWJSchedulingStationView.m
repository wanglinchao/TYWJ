//
//  TYWJSchedulingStationView.m
//  TYWJBus
//
//  Created by tywj on 2020/5/29.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJSchedulingStationView.h"
@interface TYWJSchedulingStationView ()
{
    CGRect tempframe;
}
@end
@implementation TYWJSchedulingStationView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self=[[[NSBundle mainBundle]loadNibNamed:[NSString stringWithFormat:@"%@",[self class]] owner:nil options:nil] objectAtIndex:0];
        tempframe = frame;
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.frame = tempframe;
}
-(void)drawRect:(CGRect)rect
{
    self.frame = tempframe;
    // Drawing code
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
