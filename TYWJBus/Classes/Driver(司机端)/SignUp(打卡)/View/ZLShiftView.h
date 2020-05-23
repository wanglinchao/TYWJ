//
//  ZLShiftView.h
//  TYWJBus
//
//  Created by MacBook on 2018/12/12.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLShiftView : UIView

+ (instancetype)shiftViewWithFrame:(CGRect)frame;

- (void)setLeftTitle:(NSString *)lTitle rightTitle:(NSString *)rTitle;

/* 左按钮点击 */
@property (copy, nonatomic) void(^leftBClicked)(void);
/* 右按钮点击 */
@property (copy, nonatomic) void(^rightBClicked)(void);

@end

NS_ASSUME_NONNULL_END
