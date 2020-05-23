//
//  TYWJCombineTextButton.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJCombineTextButton.h"


@interface TYWJCombineTextButton()

/* tipsLabel */
@property (weak, nonatomic) UILabel *tipsLabel;
/* 协议button */
@property (weak, nonatomic) UIButton *protocolBtn;
/* 两个文字的总长度 */
@property (assign, nonatomic) CGFloat totalWidth;
/* tips文字的长度 */
@property (assign, nonatomic) CGFloat tipsWidth;
/* btn长度 */
@property (assign, nonatomic) CGFloat btnWidth;

@end

@implementation TYWJCombineTextButton
#pragma mark - 懒加载
- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        UILabel *tipsLabel = [[UILabel alloc] init];
        tipsLabel.textColor = ZLGrayColorWithRGB(119.f);
        tipsLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:tipsLabel];
        _tipsLabel = tipsLabel;
    }
    return _tipsLabel;
}

- (UIButton *)protocolBtn {
    if (!_protocolBtn) {
        UIButton *protocolBtn = [[UIButton alloc] init];
        [protocolBtn setTitleColor:ZLColorWithRGB(53, 158, 255) forState:UIControlStateNormal];
        protocolBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [protocolBtn addTarget:self action:@selector(protocolClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:protocolBtn];
        _protocolBtn = protocolBtn;
    }
    return _protocolBtn;
}
#pragma mark - 初始化方法
- (instancetype)init
{
    self = [super init];
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
    self.backgroundColor = [UIColor clearColor];
}
#pragma mark - 布局

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tipsLabel.zl_width = self.tipsWidth;
    self.tipsLabel.zl_height = 20.f;
    self.tipsLabel.zl_centerY = self.zl_height/2.f;
    self.tipsLabel.zl_x = (self.zl_width - self.totalWidth)/2.f;
    
    self.protocolBtn.zl_width = self.btnWidth;
    self.protocolBtn.zl_height = 20.f;
    self.protocolBtn.zl_centerY = self.tipsLabel.zl_centerY;
    self.protocolBtn.zl_x = CGRectGetMaxX(self.tipsLabel.frame);
    
}
#pragma mark - 外部设置

- (void)setTips:(NSString *)tips protocol:(NSString *)protocol {
    if (tips) {
        self.tipsLabel.text = tips;
        self.tipsWidth = [tips sizeWithMaxSize:CGSizeMake(MAXFLOAT, 0) font:14.f].width;
    }
    if (protocol) {
        [self.protocolBtn setTitle:protocol forState:UIControlStateNormal];
        self.btnWidth = [protocol sizeWithMaxSize:CGSizeMake(MAXFLOAT, 0) font:14.f].width;
    }
    self.totalWidth = self.btnWidth + self.tipsWidth;
    
    [self setUnderline];
}

- (void)setHasUnderLine:(BOOL)hasUnderLine {
    _hasUnderLine = hasUnderLine;
    
    [self setUnderline];
}

- (void)setUnderline {
    if (self.hasUnderLine) {
        NSMutableAttributedString *attrString = [[self.protocolBtn titleForState:UIControlStateNormal] underLineWithTextColor:ZLGrayColorWithRGB(130)];
        
        [self.protocolBtn setAttributedTitle:attrString forState:UIControlStateNormal];
    }
}
#pragma mark - 按钮点击

- (void)protocolClicked {
    ZLFuncLog;
    if (self.btnClicked) {
        self.btnClicked();
    }
}

@end
