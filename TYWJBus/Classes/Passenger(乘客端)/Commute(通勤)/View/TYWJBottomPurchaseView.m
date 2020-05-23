//
//  TYWJBottomPurchaseView.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/12.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBottomPurchaseView.h"
#import "TYWJBorderButton.h"
#import "TYWJChangeNumsView.h"
#import "UIControl+ZLEventTimeInterval.h"


@interface TYWJBottomPurchaseView()

/* priceLabel */
@property (strong, nonatomic) UILabel *priceLabel;
/* tipsLabel */
@property (strong, nonatomic) UILabel *tipsLabel;
@property (strong, nonatomic) TYWJBorderButton *purchaceBtn;
/*  */
@property (weak, nonatomic) TYWJChangeNumsView *changeNumsView;

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
    
    TYWJBorderButton *purchaceBtn = [[TYWJBorderButton alloc] initWithFrame:CGRectMake(self.zl_width - 90.f, 0, 70.f, 25.f)];
    purchaceBtn.zl_centerY = self.zl_height/2.f;
    [purchaceBtn setTitle:@"购买" forState:UIControlStateNormal];
    [purchaceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    purchaceBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    purchaceBtn.zl_eventTimeInterval = 1.5f;
    [self addSubview:purchaceBtn];
    self.purchaceBtn = purchaceBtn;
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.f, self.zl_height/2.f - 25.f, self.zl_width - 20.f - 90.f , 30.f)];
    priceLabel.textColor = ZLColorWithRGB(255, 54, 39);
    priceLabel.font = [UIFont systemFontOfSize:18.f];
    priceLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:priceLabel];
    _priceLabel = priceLabel;
    
    _tipsLabel = [[UILabel alloc] init];
    _tipsLabel.textColor = ZLGrayColorWithRGB(200);
    _tipsLabel.font = [UIFont systemFontOfSize:12.f];
    _tipsLabel.frame = priceLabel.frame;
    _tipsLabel.zl_y = self.zl_height/2.f;
    _tipsLabel.zl_height = 20.f;
    [self addSubview:_tipsLabel];
    
    
    UIView *sepatatorLine = [[UIView alloc] init];
    sepatatorLine.backgroundColor = ZLNavTextColor;
    sepatatorLine.frame = CGRectMake(0, 0, self.zl_width, 0.5f);
    [self addSubview:sepatatorLine];
}


- (void)addTarget:(id)target action:(SEL)action {
    [self.purchaceBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setPrice:(NSString *)price {
    if (!price) return;
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",price];
}

- (void)setTipsWithNum:(NSInteger)num {
    
    self.tipsLabel.text = [NSString stringWithFormat:@"已选择%ld张",(long)num];
}

- (void)setShowTips:(BOOL)showTips {
    if (!showTips) {
        self.tipsLabel.hidden = YES;
        self.priceLabel.zl_centerY = self.zl_height/2.f;
    }else {
        self.tipsLabel.hidden = NO;
        self.priceLabel.zl_y = self.zl_height/2.f - 25.f;
        
        TYWJChangeNumsView *changeNumsView = [[[NSBundle mainBundle] loadNibNamed:@"TYWJChangeNumsView" owner:nil options:nil] lastObject];
        changeNumsView.zl_size = CGSizeMake(100.f, 25.f);
        changeNumsView.center = CGPointMake(self.zl_width/2.f, self.zl_height/2.f);
        [self addSubview:changeNumsView];
        self.changeNumsView = changeNumsView;
    }
}

- (void)setTFText:(NSString *)text {
    ZLFuncLog;
    [self.changeNumsView setTFText:text];
}

- (void)setChangeNumsViewHidden:(BOOL)hidden {
    self.changeNumsView.hidden = hidden;
}

@end
