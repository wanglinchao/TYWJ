//
//  TYWJChooseStationView.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/12.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJChooseStationView.h"

@interface TYWJChooseStationView()

/* circleView */
@property (strong, nonatomic) UIView *circleView;
/* separator */
@property (strong, nonatomic) UIView *separator;
/* coverBtn */
@property (strong, nonatomic) UIButton *coverBtn;
@end

@implementation TYWJChooseStationView

+ (instancetype)chooseStationWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
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
    UIView *circleView = [[UIView alloc] init];
    circleView.frame = CGRectMake(20.f, 0, 8.f, 8.f);
    circleView.zl_centerY = self.zl_height/2.f;
    [circleView setRoundView];
    circleView.backgroundColor = [UIColor redColor];
    [self addSubview:circleView];
    self.circleView = circleView;
    
    CGFloat tfX = CGRectGetMaxX(circleView.frame) + 6.f;
    _tf = [[UITextField alloc] init];
    _tf.frame = CGRectMake(tfX, 0, self.zl_width - 30.f - tfX, self.zl_height);
    _tf.textAlignment = NSTextAlignmentLeft;
    _tf.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:_tf];
    
    UIImageView *arrowImgView = [[UIImageView alloc] init];
    arrowImgView.contentMode = UIViewContentModeCenter;
    arrowImgView.image = [UIImage imageNamed:@"icon_right_22x22_"];
    arrowImgView.frame = CGRectMake(self.zl_width - 30.f, 0, 22.f, 22.f);
    arrowImgView.zl_centerY = self.zl_height/2.f;
    [self addSubview:arrowImgView];
    
    UIButton *coverBtn = [[UIButton alloc] init];
    coverBtn.frame = self.bounds;
    coverBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:coverBtn];
    self.coverBtn = coverBtn;
    
    UIView *separator = [[UIView alloc] init];
    separator.frame = CGRectMake(_tf.zl_x, self.zl_height - 0.5, self.zl_width - _tf.zl_x, 0.5);
    separator.backgroundColor = ZLGlobalTextColor;
    [self addSubview:separator];
    self.separator = separator;
    
}

- (void)setCircleColor:(UIColor *)color {
    if (color) {
        self.circleView.backgroundColor = color;
    }
    
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (placeholder) {
        self.tf.placeholder = placeholder;
    }
}

- (void)setStation:(NSString *)station {
    if (station) {
        self.tf.text = station;
    }
}

- (void)addTarget:(id)target action:(SEL)action {
    [self.coverBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setIsShowSeparator:(BOOL)isShowSeparator {
    _isShowSeparator = isShowSeparator;
    self.separator.hidden = !isShowSeparator;
}
@end
