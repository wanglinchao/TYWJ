
//
//  ZLPOPAnimation.m
//  极地TV2.0
//
//  Created by Harley He on 31/10/2017.
//  Copyright © 2017 . All rights reserved.
//

#import "ZLPOPAnimation.h"
#import <POP.h>

static CGFloat const ZLPOPAnimationSpringSpeed = 30.0;
static CGFloat const ZLPOPAnimationSpringBounces = 10.0;

@implementation ZLPOPAnimation

#pragma mark - frame动画
/****************** frame动画 ********/
+ (void)hide:(void (^)(void))completionBlock view:(UIView *)view fromF:(CGRect)fromF toF:(CGRect)toF {
    POPSpringAnimation *anim = [self animationWithView:nil fromF:toF toF:fromF];
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished){
        if (completionBlock) {
            completionBlock();
        }
    }];
    [view pop_addAnimation:anim forKey:nil];
}
/**
 动画隐藏-不带springBounces
 */
+ (void)hideWithNoBounces:(void(^)(void))completionBlock view:(UIView *)view fromF:(CGRect)fromF toF:(CGRect)toF {
    POPSpringAnimation *anim = [self animationWithView:nil fromF:toF toF:fromF springSpeed:0 springBounciness:0];
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished){
        if (completionBlock) {
            completionBlock();
        }
    }];
    [view pop_addAnimation:anim forKey:nil];
}
/**
 动画显示
 */
+ (POPSpringAnimation *)animationWithView:(UIView *)view fromF:(CGRect)fromF toF:(CGRect)toF
{
    POPSpringAnimation *anim = [self animationWithView:view fromF:fromF toF:toF springSpeed:0 springBounciness:-1];
    return anim;
}

/**
 动画显示-设置速度等
 */
+ (POPSpringAnimation *)animationWithView:(UIView *)view fromF:(CGRect)fromF toF:(CGRect)toF springSpeed:(CGFloat)springSpeed springBounciness:(CGFloat)springBounciness
{
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim.fromValue = [NSValue valueWithCGRect:fromF];
    anim.toValue = [NSValue valueWithCGRect:toF];
    anim.beginTime = CACurrentMediaTime();
    anim.springSpeed = springSpeed ? springSpeed : ZLPOPAnimationSpringSpeed;
    anim.springBounciness = springBounciness >= 0 ? springBounciness : ZLPOPAnimationSpringBounces;
    if (view) {
        [view pop_addAnimation:anim forKey:nil];
    }
    return anim;
}

+ (void)animationForeverWithView:(UIView *)view fromF:(CGRect)fromF toF:(CGRect)toF springSpeed:(CGFloat)springSpeed springBounciness:(CGFloat)springBounciness completionBlock:(void(^)(void))completionBlock {
    POPSpringAnimation *anim = [self animationWithView:nil fromF:fromF toF:toF springSpeed:springSpeed springBounciness:springBounciness];
    anim.repeatForever = YES;
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished){
        if (completionBlock) {
            completionBlock();
        }
    }];
    [view pop_addAnimation:anim forKey:nil];
}

+ (void)animationWithView:(UIView *)view fromF:(CGRect)fromF toF:(CGRect)toF springSpeed:(CGFloat)springSpeed springBounciness:(CGFloat)springBounciness completionBlock:(void(^)(void))completionBlock {
    POPSpringAnimation *anim = [self animationWithView:nil fromF:fromF toF:toF springSpeed:springSpeed springBounciness:springBounciness];
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished){
        if (completionBlock) {
            completionBlock();
        }
    }];
    [view pop_addAnimation:anim forKey:nil];
}
/**
 动画显示-带block
 */
+ (void)animationWithView:(UIView *)view fromF:(CGRect)fromF toF:(CGRect)toF completionBlock:(void(^)(void))completionBlock
{
    POPSpringAnimation *anim = [self animationWithView:nil fromF:fromF toF:toF];
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished){
        if (completionBlock) {
            completionBlock();
        }
    }];
    [view pop_addAnimation:anim forKey:nil];
}

#pragma mark - center动画
/****************** center动画 ********/
/**
 动画显示,需要动画结束时还进行一系列操作
 */
+ (void)animationWithView:(UIView *)view fromC:(CGPoint)fromC toC:(CGPoint)toC completionBlock:(void(^)(void))completionBlock {
    POPSpringAnimation *anim = [self animationWithView:nil fromC:fromC toC:toC];
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished){
        if (completionBlock) {
            completionBlock();
        }
    }];
    [view pop_addAnimation:anim forKey:nil];
}
+ (void)animationWithView:(UIView *)view fromC:(CGPoint)fromC toC:(CGPoint)toC springSpeed:(CGFloat)springSpeed springBounciness:(CGFloat)springBounciness completionBlock:(void(^)(void))completionBlock {
    POPSpringAnimation *anim = [self animationWithView:nil fromC:fromC toC:toC springSpeed:springSpeed springBounciness:springBounciness];
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished){
        if (completionBlock) {
            completionBlock();
        }
    }];
    [view pop_addAnimation:anim forKey:nil];
}
/**
 动画显示
 */
+ (POPSpringAnimation *)animationWithView:(UIView *)view fromC:(CGPoint)fromC toC:(CGPoint)toC {
    POPSpringAnimation *anim = [self animationWithView:view fromC:fromC toC:toC springSpeed:0 springBounciness:-1];
    return anim;
}
/**
 动画显示
 */
+ (POPSpringAnimation *)animationWithView:(UIView *)view fromC:(CGPoint)fromC toC:(CGPoint)toC springSpeed:(CGFloat)springSpeed springBounciness:(CGFloat)springBounciness {
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim.fromValue = [NSValue valueWithCGPoint:fromC];
    anim.toValue = [NSValue valueWithCGPoint:toC];
    anim.beginTime = CACurrentMediaTime();
    anim.springSpeed = springSpeed ? springSpeed : ZLPOPAnimationSpringSpeed;
    anim.springBounciness = springBounciness >= 0 ? springBounciness : ZLPOPAnimationSpringBounces;
    if (view) {
        [view pop_addAnimation:anim forKey:nil];
    }
    return anim;
}
/**
 动画隐藏
 */
+ (void)hide:(void(^)(void))completionBlock view:(UIView *)view fromC:(CGPoint)fromC toC:(CGPoint)toC {
    POPSpringAnimation *anim = [self animationWithView:nil fromC:toC toC:fromC];
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished){
        if (completionBlock) {
            completionBlock();
        }
    }];
    [view pop_addAnimation:anim forKey:nil];
}
+ (void)hideWithNoBounces:(void(^)(void))completionBlock view:(UIView *)view fromC:(CGPoint)fromC toC:(CGPoint)toC {
    POPSpringAnimation *anim = [self animationWithView:nil fromC:toC toC:fromC springSpeed:0 springBounciness:0];
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished){
        if (completionBlock) {
            completionBlock();
        }
    }];
    [view pop_addAnimation:anim forKey:nil];
}

#pragma mark - scale

//+ (void)animationWithScaleWithView:(UIView *)view toScale
#pragma mark - basicAnim

+ (POPBasicAnimation *)basicAnimationWithView:(UIView *)view fromF:(CGRect)fromF toF:(CGRect)toF duration:(CGFloat)duration completionBlock:(void(^)(void))completionBlock {
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim.fromValue = [NSValue valueWithCGRect:fromF];
    anim.toValue = [NSValue valueWithCGRect:toF];
    anim.beginTime = CACurrentMediaTime();
    anim.duration = duration;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        if (completionBlock) {
            completionBlock();
        }
    }];
    [view pop_addAnimation:anim forKey:nil];
    return anim;
}
@end
