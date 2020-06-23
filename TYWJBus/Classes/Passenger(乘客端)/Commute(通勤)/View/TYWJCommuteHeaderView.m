//
//  TYWJCommuteHeaderView.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/29.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJCommuteHeaderView.h"
#import "TYWJStationToStationView.h"
#import "SDCycleScrollView.h"

#import "UIControl+ZLEventTimeInterval.h"
#import "TYWJBanerModel.h"

CGFloat const TYWJCommuteHeaderViewH = 150.f;

@interface TYWJCommuteHeaderView()

/* s2sView */
@property (strong, nonatomic) TYWJStationToStationView *s2sView;

@end


@implementation TYWJCommuteHeaderView
#pragma mark - setup view
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
    
}


- (void)setupView {
    WeakSelf;
//    _quickEntryView = [TYWJQuickEntryView quickEntryView];
//    _quickEntryView.frame = CGRectMake(0, 10, self.zl_width, 76);
//    [self addSubview:_quickEntryView];
//
//    _quickEntryView.busBtnClicked = ^{
//        if (weakSelf.busBtnClicked) {
//            weakSelf.busBtnClicked();
//        }
//    };
//    _quickEntryView.tourBtnClicked = ^{
//        if (weakSelf.tourBtnClicked) {
//            weakSelf.tourBtnClicked();
//        }
//    };
//    [self addSubview:self.cycleScrollView];
//    [self addSubview:self.quickEntryView];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.frame = CGRectMake(0, 0, self.zl_width, self.zl_height);
    [contentView setRoundViewWithCornerRaidus:6.f];
    [self addSubview:contentView];
    //阴影显示
    if (self.isShowShadow) {
        CALayer *contentViewBgLayer = [CALayer layer];
        contentViewBgLayer.frame = contentView.frame;
        contentViewBgLayer.shadowColor = ZLGrayColorWithRGB(225).CGColor;
        contentViewBgLayer.shadowOpacity = 1;
        contentViewBgLayer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:contentViewBgLayer.frame cornerRadius:6.f].CGPath;
        contentViewBgLayer.shadowOffset = CGSizeMake(-14.f, -8.f);
        [self.layer insertSublayer:contentViewBgLayer below:contentView.layer];
    }
    
    TYWJStationToStationView *s2sView = [[TYWJStationToStationView alloc] initWithFrame:CGRectMake(0, 0, self.zl_width - 125.f, contentView.zl_height)];
    [contentView addSubview:s2sView];
    
    s2sView.getupBtnClicked = ^{
        if (weakSelf.getupBtnClicked) {
            weakSelf.getupBtnClicked();
        }
    };
    
    s2sView.getdownBtnClicked = ^{
        if (weakSelf.getdownBtnClicked) {
            weakSelf.getdownBtnClicked();
        }
    };
    if (self.getupPlaceholder) {
        s2sView.getupTF.placeholder = self.getupPlaceholder;
    }
    if (self.getdownPlaceholder) {
        s2sView.getdownTF.placeholder = self.getdownPlaceholder;
    }
    self.s2sView = s2sView;
    
    UIButton *switchBtn = [[UIButton alloc] init];
    switchBtn.zl_size = CGSizeMake(40.f, 40);
    switchBtn.zl_x = s2sView.zl_width + 10.f;
    switchBtn.zl_centerY = s2sView.zl_centerY;
    [switchBtn setImage:[UIImage imageNamed:@"icon_exchange2_25x25_"] forState:UIControlStateNormal];
    [switchBtn addTarget:self action:@selector(switchClicked) forControlEvents:UIControlEventTouchUpInside];
    switchBtn.zl_eventTimeInterval = 0.6;
    [contentView addSubview:switchBtn];
    
    UIButton *searchBtn = [[UIButton alloc] init];
    searchBtn.zl_size = CGSizeMake(40.f, 40);
    searchBtn.zl_x = s2sView.zl_width + 60.f;
    searchBtn.zl_centerY = s2sView.zl_centerY;
    [searchBtn setImage:[UIImage imageNamed:@"icon_search2_25x25_"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchClicked) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.zl_eventTimeInterval = 1.0;
    [contentView addSubview:searchBtn];
    
//    UIView *separator = [[UIView alloc] init];
//    separator.backgroundColor = ZLGlobalTextColor;
//    separator.zl_width = 0.5f;
//    separator.zl_height = 12.f;
//    separator.zl_x = CGRectGetMaxX(switchBtn.frame) + 12.f;
//    separator.zl_centerY = s2sView.zl_centerY;
//    [contentView addSubview:separator];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self setupView];
}
#pragma mark - 按钮点击
/**
 交换 点击
 */
- (void)switchClicked {
    if (self.s2sView.getupTF.text.length == 0 || self.s2sView.getdownTF.text.length == 0) {
        [MBProgressHUD zl_showAlert:@"请选择上下车地点" afterDelay:1.5f];
        return;
    }
    [self.s2sView switchTF];
    if (self.switchBtnClicked) {
        self.switchBtnClicked();
    }
}

/**
 搜索 点击
 */
- (void)searchClicked {
//    if (self.s2sView.getupTF.text.length == 0) {
//        [MBProgressHUD zl_showAlert:@"请选择上车地点" afterDelay:1.5f];
//        return;
//    }
    if (self.searchBtnClicked) {
        self.searchBtnClicked();
    }
}

- (void)setGetupText:(NSString *)text {
    if (self.s2sView.getupTF.zl_y < self.s2sView.getdownTF.zl_y) {
        self.s2sView.getupTF.text = text;
    }
    else {
        self.s2sView.getdownTF.text = text;
    }
}

- (void)setGetdownText:(NSString *)text {
    if (self.s2sView.getupTF.zl_y > self.s2sView.getdownTF.zl_y) {
        self.s2sView.getupTF.text = text;
    }
    else {
        self.s2sView.getdownTF.text = text;
    }
}

- (NSString *)getGetupText {
    return self.s2sView.getupTF.text;
}

- (NSString *)getGetdownText {
    return self.s2sView.getdownTF.text;
}

@end
