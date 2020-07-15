//
//  ZLLoginAnimButton.m
//  TYWJBus
//
//  Created by MacBook on 2018/8/28.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "ZLLoginAnimButton.h"
#import "UIControl+ZLEventTimeInterval.h"

@interface ZLLoginAnimButton()
/* shapeLayer */
@property (strong, nonatomic) CAShapeLayer *shapeLayer;
/* oriF */
@property (assign, nonatomic) CGRect oriF;
/* oriCornerRadius */
@property (assign, nonatomic) CGFloat oriCornerRadius;
/* 是否是在登录中 */
@property (assign, nonatomic) BOOL isLogining;
/* animView */
@property (strong, nonatomic) UIView *animView;

@end

@implementation ZLLoginAnimButton

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.zl_isShowAnim = NO;
    
    self.animView = [[UIView alloc] init];
    self.animView.frame = self.bounds;
    self.animView.backgroundColor = self.backgroundColor;
    [self.animView setRoundViewWithCornerRaidus:self.layer.cornerRadius];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isLogining) return;
    
    self.isLogining = YES;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.animView];
    
    WeakSelf;
    self.oriF = self.animView.frame;
    self.oriCornerRadius = self.layer.cornerRadius;
    CGPoint c = CGPointMake(self.zl_width/2.f, self.zl_height/2.f);
    CGFloat wh = self.animView.zl_height;
    
    
    [UIView animateWithDuration:0.45f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.animView.frame = CGRectMake(0, 0, wh, wh);
        weakSelf.animView.center = c;
        [weakSelf.animView setRoundViewWithCornerRaidus:weakSelf.animView.zl_height/2.f];
        weakSelf.titleLabel.alpha = 0;
    } completion:^(BOOL finished) {
        
        //给圆加一条不封闭的白色曲线
        UIBezierPath* path = [[UIBezierPath alloc] init];
        [path addArcWithCenter:CGPointMake(wh/2.f, wh/2.f) radius:(wh/2.f - 5.f) startAngle:0 endAngle:M_PI_2 * 2.f clockwise:YES];
        weakSelf.shapeLayer = [[CAShapeLayer alloc] init];
        weakSelf.shapeLayer.lineWidth = 1.5;
        weakSelf.shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        weakSelf.shapeLayer.fillColor = weakSelf.backgroundColor.CGColor;
        weakSelf.shapeLayer.frame = CGRectMake(0, 0, wh, wh);
        weakSelf.shapeLayer.path = path.CGPath;
        [weakSelf.animView.layer addSublayer:weakSelf.shapeLayer];
        
        //让圆转圈，实现"加载中"的效果
        CABasicAnimation* baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        baseAnimation.duration = 0.4;
        baseAnimation.fromValue = @(0);
        baseAnimation.toValue = @(2 * M_PI);
        baseAnimation.repeatCount = MAXFLOAT;
        [weakSelf.shapeLayer addAnimation:baseAnimation forKey:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf sendActionsForControlEvents:UIControlEventTouchUpInside];
        });
    }];
    
    
}


- (void)loginFailed {
    [self.shapeLayer removeAllAnimations];
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
    
    
    WeakSelf;
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.animView.frame = weakSelf.oriF;
        [weakSelf.animView setRoundViewWithCornerRaidus:weakSelf.oriCornerRadius];
        weakSelf.titleLabel.alpha = 1.f;
    } completion:^(BOOL finished) {
        weakSelf.isLogining = NO;
        [weakSelf.animView removeFromSuperview];
        weakSelf.backgroundColor = weakSelf.animView.backgroundColor;
        //给按钮添加左右摆动的效果(路径动画)
        CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        CGPoint point = weakSelf.layer.position;
        keyFrame.values = @[[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)],
                            
                            [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                            
                            [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                            
                            [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                            
                            [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                            
                            [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                            
                            [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                            
                            [NSValue valueWithCGPoint:point]];
        keyFrame.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        keyFrame.duration = 0.5f;
        [weakSelf.layer addAnimation:keyFrame forKey:keyFrame.keyPath];
    }];
    
}

@end
