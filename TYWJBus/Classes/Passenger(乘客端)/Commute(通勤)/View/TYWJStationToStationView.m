//
//  TYWJStationToStationView.m
//  TYWJBus
//
//  Created by Harllan He on 2018/5/29.
//  Copyright © 2018 Harllan He. All rights reserved.
//

#import "TYWJStationToStationView.h"
#import "ZLPOPAnimation.h"


static CGFloat const kSeparatorLineX = 40.f;

@interface TYWJStationToStationView()
/* getupLabel */
//@property (strong, nonatomic) UITextField *getupTF;
///* getdownLabel */
//@property (strong, nonatomic) UITextField *getdownTF;
/* getupButton */
@property (strong, nonatomic) UIButton *getupButton;
/* getdownButton */
@property (strong, nonatomic) UIButton *getdownButton;

@end

@implementation TYWJStationToStationView
#pragma mark - 懒加载
- (UIButton *)getupButton {
    if (!_getupButton) {
        _getupButton = [[UIButton alloc] init];
        [_getupButton addTarget:self action:@selector(getupClicked) forControlEvents:UIControlEventTouchUpInside];
        _getupButton.frame = CGRectMake(kSeparatorLineX, 0, self.zl_width - kSeparatorLineX, self.zl_height/2.f - 1.f);
    }
    return _getupButton;
}

- (UIButton *)getdownButton {
    if (!_getdownButton) {
        _getdownButton = [[UIButton alloc] init];
        [_getdownButton addTarget:self action:@selector(getdownClicked) forControlEvents:UIControlEventTouchUpInside];
//        _getdownButton.frame = CGRectMake(kSeparatorLineX, self.zl_centerY + 1.f, self.zl_width - kSeparatorLineX, self.zl_height/2.f - 1.f);
        _getdownButton.frame = CGRectMake(kSeparatorLineX, self.zl_height/2.f + 1.f, self.zl_width - kSeparatorLineX, self.zl_height/2.f - 1.f);
    }
    return _getdownButton;
}

- (UITextField *)getupTF {
    if (!_getupTF) {
        _getupTF = [[UITextField alloc] init];
        _getupTF.frame = self.getupButton.frame;
        _getupTF.font = [UIFont systemFontOfSize:16.f];
        _getupTF.textAlignment = NSTextAlignmentLeft;
        _getupTF.userInteractionEnabled = NO;
        _getupTF.textColor = [UIColor colorWithHexString:@"666666"];
        _getupTF.placeholder = @"我的出发地";
    }
    return _getupTF;
}

- (UITextField *)getdownTF {
    if (!_getdownTF) {
        _getdownTF = [[UITextField alloc] init];
        _getdownTF.frame = self.getdownButton.frame;
        _getdownTF.font = [UIFont systemFontOfSize:14.f];
        _getdownTF.textAlignment = NSTextAlignmentLeft;
        _getdownTF.userInteractionEnabled = NO;
        _getdownTF.textColor = [UIColor colorWithHexString:@"666666"];
        _getdownTF.placeholder = @"我的目的地";
    }
    return _getdownTF;
}
#pragma mark - 初始化操作
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    UIView *separatorLine = [[UIView alloc] init];
    separatorLine.backgroundColor = ZLGlobalTextColor;
//    separatorLine.frame = CGRectMake(kSeparatorLineX, 0, self.zl_width - kSeparatorLineX, 0.5f);
//    separatorLine.zl_centerY = self.zl_centerY;
    separatorLine.frame = CGRectMake(kSeparatorLineX, self.zl_height/2.f, self.zl_width - kSeparatorLineX, 0.5f);
    [self addSubview:separatorLine];
    
    [self addSubview:self.getupButton];
    [self addSubview:self.getdownButton];
    
    [self addSubview:self.getupTF];
    [self addSubview:self.getdownTF];
    
    CGFloat x = 20.f;
    CGFloat wh = 8.f;
    CGFloat alpha = 0.65;
    UIView *greenRoundView = [[UIView alloc] init];
    greenRoundView.frame = CGRectMake(x, 0, wh, wh);
    greenRoundView.zl_centerY = self.getupButton.zl_centerY;
    [greenRoundView setRoundView];
    greenRoundView.backgroundColor = [UIColor colorWithHexString:@"#23C371"];
    [self addSubview:greenRoundView];
    [self getGrayRoundViewWithY:40];
    [self getGrayRoundViewWithY:50];
    [self getGrayRoundViewWithY:60];
    UIView *redRoundView = [[UIView alloc] init];
    redRoundView.frame = CGRectMake(x, 0, wh, wh);
    redRoundView.zl_centerY = self.getdownButton.zl_centerY;
    [redRoundView setRoundView];
    redRoundView.backgroundColor = [UIColor colorWithHexString:@"#FF4040"];
    [self addSubview:redRoundView];
}
- (void)getGrayRoundViewWithY:(float)y{
    UIView *roundView = [[UIView alloc] init];
    roundView.frame = CGRectMake(22, y, 4, 4);
    [roundView setRoundView];
    roundView.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    [self addSubview:roundView];
}
#pragma mark - 按钮点击

/**
 上车地点 点击
 */
- (void)getupClicked {
    ZLFuncLog;
    if (self.getupBtnClicked) {
        self.getupBtnClicked();
    }
}

/**
 下车地点 点击
 */
- (void)getdownClicked {
    ZLFuncLog;
    if (self.getdownBtnClicked) {
        self.getdownBtnClicked();
    }
}

#pragma mark - 外部方法

- (void)switchTF {
    CGRect getupBtnF = self.getupTF.frame;
    CGRect getdownBtnF = self.getdownTF.frame;
    
    [ZLPOPAnimation animationWithView:self.getupTF fromF:getupBtnF toF:getdownBtnF];
    [ZLPOPAnimation animationWithView:self.getdownTF fromF:getdownBtnF toF:getupBtnF];
}
@end
