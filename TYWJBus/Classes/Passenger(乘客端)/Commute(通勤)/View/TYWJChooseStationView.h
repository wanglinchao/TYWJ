//
//  TYWJChooseStationView.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/12.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYWJChooseStationView : UIView

/* 是否显示分割线,默认显示 */
@property (assign, nonatomic) BOOL isShowSeparator;
/* tf */
@property (strong, nonatomic, readonly) UITextField *tf;

+ (instancetype)chooseStationWithFrame:(CGRect)frame;
//设置圆圈的颜色
- (void)setCircleColor:(UIColor *)color;
- (void)setPlaceholder:(NSString *)placeholder;
//设置站名
- (void)setStation:(NSString *)station;
//设置按钮点击事件
- (void)addTarget:(id)target action:(nonnull SEL)action;

@end
