//
//  TYWJTriangleView.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/21.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJTriangleView.h"

@implementation TYWJTriangleView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    [self drawTriangle];
}

- (void)drawTriangle {
    
    CGFloat x = self.zl_width/2.f;
    CGFloat y = self.zl_height;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(x, y)];
    [bezierPath addLineToPoint:CGPointMake(x - 8.f, 0)];
    [bezierPath addLineToPoint:CGPointMake(x + 8.f, 0)];
    
    [[UIColor whiteColor] set];
    [bezierPath fill];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
@end
