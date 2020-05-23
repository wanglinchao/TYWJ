//
//  TYWJDetailRouteView.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/1.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYWJDetailRouteView : UIView

/* stopsView */
@property (strong, nonatomic) UIView *stopsView;

+ (instancetype)detailRouteViewWithFrame:(CGRect)frame;
//这里其实该直接传入一个info模型
- (void)setMonthIconImg:(NSString *)iconImg s2sStr:(NSString *)s2sStr isShowTips:(BOOL)isShowTips type:(NSString *)type startTime:(NSString *)startTime;
@end
