//
//  ZLCAAnimation.m
//  TYWJBus
//
//  Created by Harley He on 2018/8/10.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "ZLCAAnimation.h"

@implementation ZLCAAnimation

#pragma mark - scale
+ (void)zl_animationScaleMagnifyWithView:(UIView *)view timeInterval:(CGFloat)timeInterval {
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    scaleAnimation.duration = timeInterval;
    scaleAnimation.cumulative = NO;
    scaleAnimation.repeatCount = 1;
    [scaleAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [view.layer addAnimation: scaleAnimation forKey:@"myScale"];
}

+ (void)zl_animationScaleShrinkWithView:(UIView *)view timeInterval:(CGFloat)timeInterval {
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)];
    scaleAnimation.duration = timeInterval;
    scaleAnimation.cumulative = NO;
    scaleAnimation.repeatCount = 1;
    [scaleAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [view.layer addAnimation: scaleAnimation forKey:@"myScale"];
    
}


+ (void)zl_transitionWithView:(UIView *)view type:(ZLTransitionType)type timeInterval:(CGFloat)timeInterval {
    /*
     fade                   //交叉淡化过渡(不支持过渡方向)
     push                   //新视图把旧视图推出去
     moveIn                 //新视图移到旧视图上面
     reveal                 //将旧视图移开,显示下面的新视图
     cube                   //立方体翻滚效果
     oglFlip                //上下左右翻转效果
     suckEffect             //收缩效果，向布被抽走(不支持过渡方向)
     rippleEffect           //水波效果(不支持过渡方向)
     pageCurl               //向上翻页效果
     pageUnCurl             //向下翻页效果
     cameraIrisHollowOpen   //相机镜头打开效果(不支持过渡方向)
     cameraIrisHollowClose  //相机镜头关上效果(不支持过渡方向)
     
     
     kCATransitionFromRight
     kCATransitionFromLeft
     kCATransitionFromTop
     kCATransitionFromBottom
     */
    if (timeInterval == 0) {
        timeInterval = 0.75f;
    }
    CATransition *transition = [CATransition animation];
    switch (type) {
        case ZLTransitionTypeFade:
            transition.type = @"fade";
            break;
        case ZLTransitionTypePush:
            transition.type = @"push";
            break;
        case ZLTransitionTypeMoveIn:
            transition.type = @"moveIn";
            break;
        case ZLTransitionTypeReveal:
            transition.type = @"reveal";
            break;
        case ZLTransitionTypeCube:
            transition.type = @"cube";
            transition.subtype = kCATransitionFromRight;
            break;
        case ZLTransitionTypeOglFlip:
            transition.type = @"oglFlip";
            break;
        case ZLTransitionTypeSuckEffect:
            transition.type = @"suckEffect";
            break;
        case ZLTransitionTypeRippleEffect:
            transition.type = @"rippleEffect";
            break;
        case ZLTransitionTypePageCurl:
            transition.type = @"pageCurl";
            break;
        case ZLTransitionTypePageUncurl:
            transition.type = @"pageUnCurl";
            break;
    }
    
    transition.duration = timeInterval;
    [view.layer addAnimation:transition forKey:nil];
}

@end
