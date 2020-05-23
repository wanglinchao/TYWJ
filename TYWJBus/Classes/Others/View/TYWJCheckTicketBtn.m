//
//  TYWJCheckTicketBtn.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/28.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJCheckTicketBtn.h"
#import <POP.h>

@interface TYWJCheckTicketBtn()<CAAnimationDelegate>

/* 动画图层 */
@property (strong, nonatomic) CAShapeLayer *shapeLayer;
/* 画勾layer */
@property (strong, nonatomic) CAShapeLayer *rightLayer;
/* animView */
@property (strong, nonatomic) UIView *animView;
/* 是否是在购票成功动画中 */
@property (assign, nonatomic) BOOL isSuccAnimating;

@end

@implementation TYWJCheckTicketBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CAShapeLayer *)rightLayer {
    if (!_rightLayer) {
        _rightLayer = [CAShapeLayer layer];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x, self.center.y) radius:self.frame.size.width/2.0 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        //对拐角和中点处理
        path.lineCapStyle  = kCGLineCapRound;
        path.lineJoinStyle = kCGLineCapRound;
        
        //对号第一部分直线的起始
        [path moveToPoint:CGPointMake(self.frame.size.width/5, self.frame.size.width/2)];
        CGPoint p1 = CGPointMake(self.frame.size.width/5.0*2, self.frame.size.width/4.0*3);
        [path addLineToPoint:p1];
        
        //对号第二部分起始
        CGPoint p2 = CGPointMake(self.zl_width/6.f*5.f, self.zl_width/4.f + 12.0);
        [path addLineToPoint:p2];
        
        _rightLayer.frame = self.animView.bounds;
        _rightLayer.strokeColor = ZLGrayColorWithRGB(51.f).CGColor;
        _rightLayer.lineWidth = 5.f;
        _rightLayer.lineCap = kCALineCapRound;
        _rightLayer.fillColor = [UIColor clearColor].CGColor;
        _rightLayer.strokeStart = 0;
        _rightLayer.strokeEnd = 0;
        _rightLayer.path = path.CGPath;
    }
    return _rightLayer;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.shapeLayer) {
        [self setImage:[UIImage imageNamed:@"fingerprint_orange_61x61_"] forState:UIControlStateNormal];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.zl_width/2.f];
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.frame = self.bounds;
        self.shapeLayer.path = path.CGPath;
        self.shapeLayer.strokeColor = ZLNavTextColor.CGColor;
        self.shapeLayer.lineWidth = 6.f;
        self.shapeLayer.lineCap = kCALineCapRound;
        self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
        self.shapeLayer.strokeStart = 0;
        self.shapeLayer.strokeEnd = 0;
        [self.layer addSublayer:self.shapeLayer];
        
        [self drawLine1Animation:self.shapeLayer];
    }
    
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.userInteractionEnabled) {
        [self.shapeLayer pop_removeAllAnimations];
    }
    
}


- (void)drawLine0Animation:(CAShapeLayer*)layer {
    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = 2.f;
    bas.delegate = self;
    bas.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    bas.fromValue = [NSNumber numberWithInteger:0];
    bas.toValue = [NSNumber numberWithInteger:1];
    bas.removedOnCompletion = NO;
    [layer addAnimation:bas forKey:@"stokeDraw"];
}


- (void)drawLine1Animation:(CAShapeLayer*)layer {
    
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    anim.fromValue = [NSNumber numberWithInteger:0];
    anim.toValue = [NSNumber numberWithInteger:1];
    anim.beginTime = CACurrentMediaTime();
    anim.duration = 2.f;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            self.userInteractionEnabled = NO;
            if (self.checkTicketSuc) {
                self.checkTicketSuc();
            }
        }else {
            POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
            anim.toValue = [NSNumber numberWithInteger:0];
            anim.beginTime = CACurrentMediaTime();
            anim.springSpeed = 6.f;
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                if (finished) {
                    [self setImage:[UIImage imageNamed:@"fingerprint_61x61_"] forState:UIControlStateNormal];
                    [self.shapeLayer pop_removeAllAnimations];
                    [self.shapeLayer removeFromSuperlayer];
                    self.shapeLayer = nil;
                }
            }];
            [layer pop_addAnimation:anim forKey:nil];
        }
    }];
    [layer pop_addAnimation:anim forKey:nil];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.shapeLayer) {
        if (self.checkTicketSuc) {
            self.checkTicketSuc();
        }
    }
}

- (void)removeAnimLayer {
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
    self.userInteractionEnabled = YES;
}

- (void)startSuccAnimation {
    ZLFuncLog;
    self.isSuccAnimating = YES;
    
    UIView *animView = [[UIView alloc] init];
    animView.zl_size = CGSizeMake(20.f, 20.f);
    animView.zl_centerX = self.zl_width/2.f;
    animView.zl_centerY = self.zl_height/2.f;
    animView.backgroundColor = ZLNavTextColor;
    [animView setRoundView];
    
    [self addSubview:animView];
    self.animView = animView;
    
    [self scaleAnimation];
}


- (void)stopSuccAnimation {
    ZLFuncLog;
    self.isSuccAnimating = NO;
    
    [self.animView pop_removeAllAnimations];
    [self.animView removeFromSuperview];
    
    [self.rightLayer pop_removeAllAnimations];
    [self.rightLayer removeFromSuperlayer];
}


- (void)animToDrawRightLayer {
    [self.layer addSublayer:self.rightLayer];
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    anim.name = @"drawRightAnimation";
    anim.fromValue = [NSNumber numberWithInteger:0];
    anim.toValue = [NSNumber numberWithInteger:1];
    anim.beginTime = CACurrentMediaTime();
    anim.duration = 2.f;
    anim.delegate = self;
    [self.rightLayer pop_addAnimation:anim forKey:nil];
}

- (void)scaleSmallAnimation {
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    
    scaleAnimation.name                = @"SpringAnimation";
    scaleAnimation.delegate            = self;
    scaleAnimation.springBounciness    = 0;
    scaleAnimation.springSpeed         = 1;
    scaleAnimation.toValue             = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    
    [self.animView pop_addAnimation:scaleAnimation forKey:nil];
}

- (void)scaleAnimation {
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    
    scaleAnimation.name               = @"scaleSmallAnimation";
    scaleAnimation.delegate           = self;
    
    scaleAnimation.duration           = 1.f;
    scaleAnimation.toValue            = [NSValue valueWithCGPoint:CGPointMake(3.6, 3.6)];
    
    [self.animView pop_addAnimation:scaleAnimation forKey:nil];
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    
    if (self.isSuccAnimating == NO) {
        return;
    }
    
    if ([anim.name isEqualToString:@"scaleSmallAnimation"]) {
        
        [self animToDrawRightLayer];
        
    } else if ([anim.name isEqualToString:@"SpringAnimation"]) {
        [self scaleAnimation];
    }else if ([anim.name isEqualToString:@"drawRightAnimation"]) {
        self.rightLayer.strokeEnd = 0;
        [self.rightLayer pop_removeAllAnimations];
        [self.rightLayer removeFromSuperlayer];
        
        [self scaleSmallAnimation];
    }
}

@end
