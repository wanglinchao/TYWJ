//
//  TYWJBorderButton.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBorderButton.h"
#import "UIControl+ZLEventTimeInterval.h"

@implementation TYWJBorderButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupView];
}

- (void)setupView {
    //设置防止重复点击的间隔时间
    self.zl_eventTimeInterval = 1.0;
    self.layer.masksToBounds = YES;
    self.zl_isShowAnim = YES;
    [self setRoundView];
    
    [self setButtonStyle];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    [self setButtonStyle];
}

- (void)setButtonStyle {
    if (self.enabled) {
//        if (self.borderWidth > 0) {
//           self.layer.borderWidth = self.borderWidth;
//        }else {
//            self.layer.borderWidth = 0.5f;
//        }
        
//        if (self.borderColor) {
//            self.layer.borderColor = self.borderColor.CGColor;
//        }else {
//           self.layer.borderColor = ZLNavTextColor.CGColor;
//        }
        self.backgroundColor = ZLNavTextColor;
        
        [self setTitleColor:ZLGlobalBtnTextColor forState:UIControlStateNormal];
    }else {
        self.backgroundColor = ZLColorWithRGB(253, 230, 135);
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.layer.borderWidth = 0;
    }
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [self setButtonStyle];
}

- (void)setBorderWidth:(CGFloat )borderWidth {
    _borderWidth = borderWidth;
    
    [self setButtonStyle];
}

#pragma mark - 实现
@end
