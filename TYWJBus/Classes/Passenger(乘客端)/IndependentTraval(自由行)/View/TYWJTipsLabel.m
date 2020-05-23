//
//  TYWJTipsLabel.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/20.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJTipsLabel.h"

@interface TYWJTipsLabel()

/* bgLayer */
@property (weak, nonatomic) CAShapeLayer *bgLayer;
/* titleLabel */
@property (weak, nonatomic) UILabel *titleLabel;

@end

@implementation TYWJTipsLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)tipsLabelWithFrame:(CGRect)frame {
    TYWJTipsLabel *l = [[TYWJTipsLabel alloc] initWithFrame:frame];
    
    UIRectCorner corner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    CGSize radii = CGSizeMake(6.f, 6.f);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:l.bounds byRoundingCorners:corner cornerRadii:radii];
    
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    l.bgLayer = bgLayer;
    l.bgLayer.path = path.CGPath;
    [l.layer addSublayer:l.bgLayer];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:l.bounds];
    l.titleLabel = titleLabel;
    l.titleLabel.backgroundColor = [UIColor clearColor];
    l.titleLabel.font = [UIFont systemFontOfSize:12.f];
    l.titleLabel.textColor = [UIColor whiteColor];
    l.titleLabel.textAlignment = NSTextAlignmentCenter;
    [l addSubview:l.titleLabel];
    
    return l;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[UIColor clearColor]];
    
    self.bgLayer.fillColor = backgroundColor.CGColor;
    [self.bgLayer setNeedsDisplay];
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    self.titleLabel.text = text;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    
    self.titleLabel.textColor = textColor;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    
    self.titleLabel.font = font;
}

@end
