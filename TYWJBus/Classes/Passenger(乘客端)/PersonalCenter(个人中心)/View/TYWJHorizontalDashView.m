//
//  TYWJHorizontalDashView.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/15.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJHorizontalDashView.h"


@implementation TYWJHorizontalDashView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    CGPoint startP = CGPointMake(0, rect.size.height/2.f);
    CGPoint endP = CGPointMake(rect.size.width, rect.size.height/2.f);
    
    [TYWJCommonTool drawDashWithStartPoint:startP endPoint:endP dashColor:ZLNavTextColor drawP:5 skipP:3];
}


@end
