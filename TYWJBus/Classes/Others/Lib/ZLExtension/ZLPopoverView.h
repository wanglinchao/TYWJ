//
//  ZLPopoverView.h
//  YunDuoYouBao
//
//  Created by Harley He on 18/11/2017.
//  Copyright © 2017 GY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YDYBWeBussinessModel,YDYBWeBussinessSpecificationsModel;

@interface ZLPopoverView : NSObject

/**
 单例
 */
+ (instancetype)sharedInstance;
- (void)hide;

/**
 显示sideView
 */
- (void)showSideView;

/**
 显示tipsView

 @param tips tips
 @param leftTitle 左边title
 @param rightTitle 右边title
 @param registerClicked 注册点击
 */
- (void)showTipsViewWithTips:(NSString*)tips leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle RegisterClicked:(void(^)(void))registerClicked;

- (void)showSingleBtnViewWithTips:(NSString *)tips confirmClicked:(void(^)(void))confirmClicked;
/**
 显示单按钮（确定） 的tips view

 @param tips tips
 */
- (void)showSingleBtnViewWithTips:(NSString *)tips;

/**
 显示改变头像view
 */
- (void)showChangeAvatarView;

/**
 传入要显示的数据数组，如果传入的数组是模型数组的话，pName务必要传入模型中要显示的属性的名称，如果传入pName是nil的话，dataArray务必传入的是NSString的数组
 
 @param dataArray 要显示的信息的数据数组
 @param pName 如果传入的是模型数组的话，这个便是此模型要显示的文字的属性名称
 */
- (void)showPopSelectViewWithDataArray:(NSArray *)dataArray andProertyName:(NSString *)pName confirmClicked:(void(^)(id model))confirmClicked;
- (void)showPopSelecteTimeViewWithSelectedTime:(NSInteger)selectedTime ConfirmClicked:(void(^)(NSString *time))confirmClicked;
- (void)showPopDatePickerWithSelectedDate:(NSInteger)selectedDate ConfirmClicked:(void(^)(NSString *dateStr))confirmClicked;

- (void)showCheckAvatarViewWithPicture:(id)pic sender:(UIButton *)sender;

#pragma mark - 显示popBubbleView
/**
 显示popBubbleView

 @param view 显示在哪个view下面或者上面
 @param showingView 要显示的view
 @param showingViewH 要显示view的高度
 */
- (void)showPopBubbleViewWithView:(UIView *)view showingView:(UIView *)showingView showingViewH:(CGFloat)showingViewH;
- (void)showPopBubbleViewWithView:(UIView *)view showingView:(UIView *)showingView;

- (void)showSelectMapViewWithLocation:(CGPoint)location;

- (void)showITNotiView;

- (void)showChooseCarLicenseViewWithCarLicenses:(NSArray *)carLicenses cellSelected:(void(^)(NSString *cl))cellSelected;

@end
