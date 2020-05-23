//
//  TYWJVerticalDashView.m
//  TYWJBus
//
//  Created by MacBook on 2018/8/22.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJVerticalDashView.h"


@implementation TYWJVerticalDashView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    // Drawing code
    [super drawRect:rect];
    
    CGPoint startP = CGPointMake(rect.size.width/2.f, 0);
    CGPoint endP = CGPointMake(rect.size.width/2.f,rect.size.height);
    
    [TYWJCommonTool drawDashWithStartPoint:startP endPoint:endP dashColor:ZLNavTextColor];
}


@end
