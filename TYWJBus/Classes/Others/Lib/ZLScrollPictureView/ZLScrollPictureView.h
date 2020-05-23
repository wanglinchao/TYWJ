//
//  ZLScrollPictureView.h
//  ZLScrollPictureView
//
//  Created by hezhonglin on 16/7/20.
//  Copyright © 2016年 hezhonglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZLScrollPictureViewDelegate <NSObject>

@optional
- (void)scrollPictureViewDidClicked:(UIButton *)button;

@end

@interface ZLScrollPictureView : UIView

@property(nonatomic, weak)id<ZLScrollPictureViewDelegate> delegate;

//一般的工厂方法
+ (instancetype)scrollPicWithPicsName:(NSArray *)picsName frame:(CGRect )frame;
//可以改变pagecontrol的indicatorclolor的工厂方法
+ (instancetype)scrollPicWithPicsName:(NSArray *)picsName frame:(CGRect )frame pageControlCurrentTintColor:(UIColor *)currentColor pageContorlTintColor:(UIColor *)tintColor;

//根据图片的url进行图片的设置的工厂方法
+ (instancetype)scrollPicWithPicNamesLink:(NSArray *)picNamesLink frame:(CGRect )frame;
//可以改变pagecontrol的indicatorclolor的工厂方法
+ (instancetype)scrollPicWithPicNamesLink:(NSArray *)picNamesLink frame:(CGRect )frame pageControlCurrentTintColor:(UIColor *)currentColor pageContorlTintColor:(UIColor *)tintColor;

/* picClickedBlock */
@property (copy, nonatomic) void(^picClickedBlock)(UIButton *btn);

@end
