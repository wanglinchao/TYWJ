//
//  TYWJApplyDetailRouteView.h
//  TYWJBus
//
//  Created by tywj on 2020/3/13.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJApplyDetailRouteView : UIView
/* stopsView */
@property (strong, nonatomic) UIView *stopsView;

+ (instancetype)detailRouteViewWithFrame:(CGRect)frame;
//这里其实该直接传入一个info模型
- (void)setMonthIconImg:(NSString *)iconImg s2sStr:(NSString *)s2sStr isShowTips:(BOOL)isShowTips type:(NSString *)type startTime:(NSString *)startTime kind:(NSString *)kind status:(NSString *)status;
@property (copy, nonatomic) void(^cBtnClicked)(BOOL hasChanged);
@end

NS_ASSUME_NONNULL_END
