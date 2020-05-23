//
//  UIButton+ZLEventTimeInterval.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/30.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "UIControl+ZLEventTimeInterval.h"
#import <objc/runtime.h>

static char * const ZLEventTimeIntervalKey = "ZLEventTimeIntervalKey";
static char * const ZLAcceptEventTimeKey = "ZLAcceptEventTimeKey";
static char * const ZLIsShowAnimKey = "ZLIsShowAnimKey";

//static CGFloat const ZLDefaultTimeInterval = 0.5;


@implementation UIControl (ZLEventTimeInterval)

- (NSTimeInterval)zl_eventTimeInterval {
    return [objc_getAssociatedObject(self, ZLEventTimeIntervalKey) doubleValue];
}

- (void)setZl_eventTimeInterval:(NSTimeInterval)zl_eventTimeInterval {
    objc_setAssociatedObject(self, ZLEventTimeIntervalKey, @(zl_eventTimeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)zl_acceptTime {
    return [objc_getAssociatedObject(self, ZLAcceptEventTimeKey) doubleValue];
}

- (void)setZl_acceptTime:(NSTimeInterval)zl_acceptTime {
    objc_setAssociatedObject(self, ZLAcceptEventTimeKey, @(zl_acceptTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setZl_isShowAnim:(BOOL)zl_isShowAnim {
    objc_setAssociatedObject(self, ZLIsShowAnimKey, @(zl_isShowAnim), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)zl_isShowAnim {
     return [objc_getAssociatedObject(self, ZLIsShowAnimKey) boolValue];
}
#pragma mark - 交换方法，实现点击阻止功能
+ (void)load {
    Method originalMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method newMethod = class_getInstanceMethod(self, @selector(zl_sendAction:to:forEvent:));
    method_exchangeImplementations(originalMethod, newMethod);
    
}

#pragma mark - 自定义点击方法
- (void)zl_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if ([self isKindOfClass: [UIButton class]]) {
        //有点儿不懂这段代码
        if ([NSDate date].timeIntervalSince1970 - self.zl_acceptTime < self.zl_eventTimeInterval) {
            return;
        }
        
        if (self.zl_eventTimeInterval > 0) {
            self.zl_acceptTime = [NSDate date].timeIntervalSince1970;
        }
    }
//    //点击动画效果是否显示
//    if (self.zl_isShowAnim) {
//        if ([self isKindOfClass:[UIButton class]]) {
//            NSSet *touches = [event allTouches];
//            UITouch *touch = [touches anyObject];
//            CGPoint touchP = [touch locationInView:self];
//
//            UIView *animView = [[UIView alloc] init];
//            animView.backgroundColor = ZLColorWithRGB(255, 246, 204);
//            animView.zl_size = CGSizeMake(20.f, self.zl_height + 20.f);
//            animView.zl_centerX = touchP.x;
//            animView.zl_centerY = self.zl_height/2.f;
//            [animView setRoundView];
//            [self insertSubview:animView atIndex:0];
//
//            CGFloat time = 0.55f;
//
//
//            [UIView animateWithDuration:time animations:^{
//                animView.zl_x = 0;
//                animView.zl_width = self.zl_width;
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.65f animations:^{
//                    animView.alpha = 0;
//                } completion:^(BOOL finished) {
//                    [animView removeFromSuperview];
//                }];
//            }];
//
//            [UIView animateWithDuration:0.15f animations:^{
//
//            } completion:^(BOOL finished) {
//                [self zl_sendAction:action to:target forEvent:event];
//            }];
//            return;
//        }
//    }
    
    [self zl_sendAction:action to:target forEvent:event];
}


@end
