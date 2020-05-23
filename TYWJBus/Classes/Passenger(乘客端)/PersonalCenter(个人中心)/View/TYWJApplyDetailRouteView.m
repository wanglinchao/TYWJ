//
//  TYWJApplyDetailRouteView.m
//  TYWJBus
//
//  Created by tywj on 2020/3/13.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJApplyDetailRouteView.h"

#pragma mark - 常量
static CGFloat const kHeaderViewH = 60.f;
static CGFloat const kAlpha = 0.75f;

#pragma mark - class - TYWJDetailRouteView
@interface TYWJApplyDetailRouteView()

/* headerView */
@property (strong, nonatomic) UIView *headerView;
/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* monthIcon */
@property (strong, nonatomic) UIImageView *monthIcon;
/* s2sLabel */
@property (strong, nonatomic) UILabel *s2sLabel;
/* tipsView */
@property (strong, nonatomic) UIView *tipsView;
/* dateLabel */
@property (strong, nonatomic) UILabel *dateLabel;
/* licenseLabel */
@property (strong, nonatomic) UILabel *licenseLabel;
/* tipsLabel */
@property (weak, nonatomic) UILabel *tipsLabel;

@property (strong, nonatomic) UIButton *changebtn;
@property (assign, nonatomic) BOOL hasChanged;

@end

@implementation TYWJApplyDetailRouteView
#pragma mark - 懒加载
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.zl_width, kHeaderViewH)];
        _headerView.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectView.frame = _headerView.bounds;
        effectView.alpha = 0.95f;
        
        [_headerView addSubview:effectView];
        [_headerView addSubview:self.monthIcon];
        [_headerView addSubview:self.s2sLabel];
        [_headerView addSubview:self.tipsView];
        [_headerView addSubview:self.changebtn];
    }
    return _headerView;
}

- (UIButton *)changebtn
{
    if (!_changebtn) {
        _changebtn = [[UIButton alloc] initWithFrame:CGRectMake(self.zl_width - 10 - 120, CGRectGetMaxY(self.monthIcon.frame) + 6.f, 120, 20)];
        _changebtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _changebtn.backgroundColor = [UIColor orangeColor];
        [_changebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _changebtn .layer.cornerRadius = 5;
        _changebtn.clipsToBounds = YES;
        [_changebtn addTarget:self action:@selector(changebtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changebtn;
}

- (void)changebtnClicked
{
    self.hasChanged = !self.hasChanged;
    
    if (self.cBtnClicked) {
        self.cBtnClicked(self.hasChanged);
    }
    if (self.hasChanged) {
        [self.changebtn setTitle:@"切换为上班线路" forState:UIControlStateNormal];
    }else {
        [self.changebtn setTitle:@"切换为下班线路" forState:UIControlStateNormal];
    }
}

- (UIImageView *)monthIcon {
    if (!_monthIcon) {
        _monthIcon = [[UIImageView alloc] init];
        _monthIcon.frame = CGRectMake(6.f, 15.f, 16.f, 16.f);
    }
    return _monthIcon;
}

- (UILabel *)s2sLabel {
    if (!_s2sLabel) {
        CGFloat x = CGRectGetMaxX(self.monthIcon.frame) + 6.f;
        _s2sLabel = [[UILabel alloc] init];
        _s2sLabel.frame = CGRectMake(x, self.monthIcon.zl_y, self.zl_width - x, 16.f);
        _s2sLabel.font = [UIFont systemFontOfSize:14.f];
        _s2sLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _s2sLabel;
}


- (UIView *)stopsView {
    if (!_stopsView) {
        _stopsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.zl_height, self.zl_width, self.zl_height - kHeaderViewH)];
        _stopsView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:kAlpha];
    }
    return _stopsView;
}

- (UIView *)tipsView {
    if (!_tipsView) {
        _tipsView = [[UIView alloc] init];
        _tipsView.frame = CGRectMake(self.monthIcon.zl_x, CGRectGetMaxY(self.monthIcon.frame) + 6.f, self.zl_width - 2*self.monthIcon.zl_x - 120, 16.f);
        _tipsView.backgroundColor = [UIColor clearColor];
        
        UIImageView *iconImgView = [[UIImageView alloc] init];
        iconImgView.frame = CGRectMake(0, 0, 16.f, 16.f);
        iconImgView.contentMode = UIViewContentModeCenter;
        iconImgView.image = [UIImage imageNamed:@"icon_remind_orange_10x10_"];
        [_tipsView addSubview:iconImgView];
        
        CGFloat x = CGRectGetMaxX(iconImgView.frame) + 6.f;
        UILabel *tipsLabel = [[UILabel alloc] init];
        tipsLabel.frame = CGRectMake(x, 0, _tipsView.zl_width - x, 16.f);
        tipsLabel.textColor = ZLNavTextColor;//ZLGrayColorWithRGB(150.f);
        tipsLabel.font = [UIFont systemFontOfSize:11.f];
        tipsLabel.textAlignment = NSTextAlignmentLeft;
        self.tipsLabel = tipsLabel;
        
        [_tipsView addSubview:tipsLabel];
    }
    return _tipsView;
}

#pragma mark - 工厂方法
+ (instancetype)detailRouteViewWithFrame:(CGRect)frame {
    return [[TYWJApplyDetailRouteView alloc] initWithFrame:frame];
}

#pragma mark - 初始化设置
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
    [self setRoundViewWithCornerRaidus:6.f];
    [self setBorderWithColor:ZLGlobalTextColor];
    
    [self addSubview:self.headerView];
    [self addSubview:self.stopsView];
}

#pragma mark - 外部设置方法

- (void)setMonthIconImg:(NSString *)iconImg s2sStr:(NSString *)s2sStr isShowTips:(BOOL)isShowTips type:(NSString *)type startTime:(NSString *)startTime  kind:(nonnull NSString *)kind status:(nonnull NSString *)status {
    self.monthIcon.image = [UIImage imageNamed:iconImg];
    self.s2sLabel.text = s2sStr;
    self.tipsView.hidden = !isShowTips;
    
    self.tipsLabel.textColor = [UIColor lightGrayColor];
    self.tipsLabel.text = @"轻松购买，方便出行";
    if ([type isEqualToString:@"CommuteLine"]) {
        NSString *timeStr = [startTime componentsSeparatedByString:@"."].firstObject;
        if (timeStr.integerValue < 12) {
            self.tipsLabel.text = @"周一及节后首日提前十分钟发车";
            self.tipsLabel.textColor = [[UIColor redColor] colorWithAlphaComponent:0.75f];
        }
        
    }
    
    if ([kind isEqualToString:@"往返线路"]) {
        if ([status isEqualToString:@"已匹配"]) {
            self.changebtn.hidden = NO;
            if (self.hasChanged) {
                [self.changebtn setTitle:@"切换为上班线路" forState:UIControlStateNormal];
            }else {
                [self.changebtn setTitle:@"切换为下班线路" forState:UIControlStateNormal];
            }
        }else {
            self.changebtn.hidden = YES;
        }
        
    }else {
        self.changebtn.hidden = YES;
    }
    

}

@end
