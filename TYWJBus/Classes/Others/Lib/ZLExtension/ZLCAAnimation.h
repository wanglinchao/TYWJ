//
//  ZLCAAnimation.h
//  TYWJBus
//
//  Created by Harley He on 2018/8/10.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <Foundation/Foundation.h>
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
 */
typedef enum : NSUInteger {
    ZLTransitionTypeFade = 100110, //交叉淡化过渡(不支持过渡方向)
    ZLTransitionTypePush, //新视图把旧视图推出去
    ZLTransitionTypeMoveIn, //新视图移到旧视图上面
    ZLTransitionTypeReveal, //将旧视图移开,显示下面的新视图
    ZLTransitionTypeCube, //立方体翻滚效果
    ZLTransitionTypeOglFlip, //上下左右翻转效果
    ZLTransitionTypeSuckEffect, //收缩效果，向布被抽走(不支持过渡方向)
    ZLTransitionTypeRippleEffect, //水波效果(不支持过渡方向)
    ZLTransitionTypePageCurl, //向上翻页效果
    ZLTransitionTypePageUncurl //向下翻页效果
} ZLTransitionType;

@interface ZLCAAnimation : NSObject

#pragma mark - scale
+ (void)zl_animationScaleMagnifyWithView:(UIView *)view timeInterval:(CGFloat)timeInterval;
+ (void)zl_animationScaleShrinkWithView:(UIView *)view timeInterval:(CGFloat)timeInterval;

+ (void)zl_transitionWithView:(UIView *)view type:(ZLTransitionType)type timeInterval:(CGFloat)timeInterval;
@end
