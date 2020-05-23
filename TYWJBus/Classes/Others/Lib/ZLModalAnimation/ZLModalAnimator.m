//
//  ZLModalAnimator.m
//  TYWJBus
//
//  Created by MacBook on 2018/12/30.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "ZLModalAnimator.h"

static NSTimeInterval const ZLModalAnimationTimeInterval = 0.5f;

@interface ZLModalAnimator()<UIViewControllerAnimatedTransitioning,CAAnimationDelegate>
{
    CAShapeLayer *_shapLayer;
    UIView *_toView;
    UIImageView *_imgView;
}
@end


@implementation ZLModalAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return ZLModalAnimationTimeInterval;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerVeiw = transitionContext.containerView;
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVc.view;
//    UIView *testView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    [containerVeiw addSubview:toView];
    
//    UIGraphicsBeginImageContext(toView.zl_size);
//    [toView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:toView.bounds];
//    imgView.image = img;
//    UIGraphicsEndImageContext();
    
//    [containerVeiw addSubview:imgView];
//    toView.hidden = YES;
    _toView = toView;
//    _imgView = imgView;
    
    UIViewController *desVc = nil;
    UIView *circleView = nil;
    Class TYWJLoginController = NSClassFromString(@"TYWJLoginController");
    Class ZLLoginAnimButton = NSClassFromString(@"ZLLoginAnimButton");
    for (UIViewController *vc in fromVc.childViewControllers) {
        if ([vc isKindOfClass: [TYWJLoginController class]]) {
            desVc = vc;
            break;
        }
    }
    for (UIView *view in desVc.view.subviews) {
        if ([view isKindOfClass: [ZLLoginAnimButton class]]) {
            circleView = view;
            break;
        }
    }
    if (circleView) {
        UIView *tmpView = [[UIView alloc] init];
        tmpView.zl_size = CGSizeMake(circleView.zl_height, circleView.zl_height);
        tmpView.center = circleView.center;
        
        _shapLayer = [CAShapeLayer layer];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:tmpView.frame cornerRadius:tmpView.frame.size.height/2.f];
        _shapLayer.path = path.CGPath;
        toView.layer.mask = _shapLayer;
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
        anim.fromValue = (__bridge id)path.CGPath;
        anim.toValue = (__bridge id)[UIBezierPath bezierPathWithRoundedRect:toView.frame cornerRadius:tmpView.frame.size.height/2.f].CGPath;
        anim.fillMode = kCAFillModeForwards;
        anim.removedOnCompletion = NO;
        anim.duration = ZLModalAnimationTimeInterval;//[self transitionDuration:transitionContext];
        //不能添加这种线性动画效果，否则会出现h不想要的问题
//        anim.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [anim setValue:transitionContext forKeyPath:@"transitionContext"];

        anim.delegate = self;
        
        [_shapLayer addAnimation:anim forKey:nil];
    }
}

#pragma mark - ainmDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
//    UITabBarController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [transitionContext completeTransition:YES];
//    [_imgView removeFromSuperview];
    _toView.layer.mask = nil;
    [_shapLayer removeAllAnimations];
}

@end
