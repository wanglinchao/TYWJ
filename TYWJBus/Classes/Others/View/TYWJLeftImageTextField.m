//
//  TYWJLeftImageTextField.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJLeftImageTextField.h"

static CGFloat const kIconX = 15.f;
static CGFloat const kTFMargin = 15.f;

@interface TYWJLeftImageTextField()<UITextFieldDelegate>

/* iconImage */
@property (weak, nonatomic) UIImageView *iconImageView;
/* 分割线 */
@property (weak, nonatomic) UIView *separatorLine;

@end

@implementation TYWJLeftImageTextField

#pragma mark - 懒加载

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.contentMode = UIViewContentModeCenter;
        _iconImageView = iconImageView;
        [self addSubview:iconImageView];
    }
    return _iconImageView;
}

- (UITextField *)textField {
    if (!_textField) {
        UITextField *tf = [[UITextField alloc] init];
        tf.font = [UIFont systemFontOfSize:14.f];
        tf.textAlignment = NSTextAlignmentLeft;
        tf.delegate = self;
        //设置placeholder颜色  ios13开始，此代码已不能使用，ipad要崩溃
//        [tf setValue:ZLGlobalTextColor forKeyPath:TYWJPlacerholderColorKeyPath];
        [self addSubview:tf];
        _textField = tf;
    }
    return _textField;
}

- (UIView *)separatorLine {
    if (!_separatorLine) {
        UIView *separatorLine = [[UIView alloc] init];
        separatorLine.backgroundColor = ZLGlobalTextColor;
        separatorLine.zl_height = 1.f;
        [self addSubview:separatorLine];
        _separatorLine = separatorLine;
    }
    return _separatorLine;
}
#pragma mark - setupView
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.separatorLine.hidden = self.hasSeparatorLine;
    self.textField.tintColor = ZLNavTextColor;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

#pragma mark - 进行子view的布局
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconImageView.zl_size = self.iconImageView.image.size;
    self.iconImageView.zl_centerY = self.zl_height/2.f;
    self.iconImageView.zl_x = kIconX;
    
    self.textField.zl_size = CGSizeMake(self.zl_width - CGRectGetMaxX(self.iconImageView.frame) - kTFMargin, self.zl_height);
    self.textField.zl_x = CGRectGetMaxX(self.iconImageView.frame) + kTFMargin;
    self.textField.zl_y = 0;
    
    if (self.hasSeparatorLine) {
        self.separatorLine.zl_width = self.textField.zl_width - kTFMargin;
        self.separatorLine.zl_x = self.textField.zl_x;
        self.separatorLine.zl_y = self.zl_height - 1.f;
    }
    
}
#pragma mark - 外部方法

- (void)setIcon:(NSString *)icon placeholder:(NSString *)placeholder isPwd:(BOOL)isPwd {
    if (icon) {
        self.iconImageView.image = [UIImage imageNamed:icon];
    }
    if (placeholder) {
        self.textField.placeholder = placeholder;
//        self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:ZLGlobalTextColor}];
    }
    if (isPwd) {
        self.textField.secureTextEntry = YES;
    }
}

- (void)setHasSeparatorLine:(BOOL)hasSeparatorLine {
    _hasSeparatorLine = hasSeparatorLine;
    self.separatorLine.hidden = !hasSeparatorLine;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    self.textField.keyboardType = keyboardType;
}

- (BOOL)becomeFirstResponder {
    [super becomeFirstResponder];
    
    [self.textField becomeFirstResponder];
    return NO;
}

#pragma mark - TF delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.separatorLine.backgroundColor = ZLNavTextColor;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.separatorLine.backgroundColor = ZLGlobalTextColor;
}
@end
