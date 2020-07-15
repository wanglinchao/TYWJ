//
//  TYWJBottomPurchaseView.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/12.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBottomPurchaseView.h"
#import "TYWJBorderButton.h"
#import "UIControl+ZLEventTimeInterval.h"


@interface TYWJBottomPurchaseView()

/* priceLabel */
@property (strong, nonatomic) UILabel *priceLabel;

@property (strong, nonatomic) TYWJBorderButton *purchaceBtn;
/*  */

@end

@implementation TYWJBottomPurchaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = ZLGlobalBgColor;
    
    _purchaceBtn = [[TYWJBorderButton alloc] initWithFrame:CGRectMake(self.zl_width - 90.f, 0, 70.f, 25.f)];
    _purchaceBtn.zl_centerY = self.zl_height/2.f;
    [_purchaceBtn setTitle:@"购买" forState:UIControlStateNormal];
    [_purchaceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _purchaceBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    _purchaceBtn.zl_eventTimeInterval = 1.5f;
    _purchaceBtn.backgroundColor = kMainRedColor;
    [self addSubview:_purchaceBtn];
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.f, self.zl_height/2.f - 25.f, self.zl_width - 20.f - 90.f , 30.f)];
    priceLabel.zl_centerY = self.zl_height/2.f;
    
    priceLabel.textColor = ZLColorWithRGB(255, 54, 39);
    priceLabel.font = [UIFont systemFontOfSize:18.f];
    priceLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:priceLabel];
    _priceLabel = priceLabel;
    
    
    
    
    UIView *sepatatorLine = [[UIView alloc] init];
    sepatatorLine.backgroundColor = kMainLineColor;
    sepatatorLine.frame = CGRectMake(0, 0, self.zl_width, 0.5f);
    [self addSubview:sepatatorLine];
}


- (void)addTarget:(id)target action:(SEL)action {
    [self.purchaceBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setPrice:(NSString *)price {
    if (!price) return;
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥ %0.2f",price.floatValue/100];
}
- (void)setTitle:(NSString *)title {
    if (!title) return;
    
    [self.purchaceBtn setTitle:title forState:UIControlStateNormal];
}
- (void)setTipsWithNum:(NSInteger)num {
    
}


@end
