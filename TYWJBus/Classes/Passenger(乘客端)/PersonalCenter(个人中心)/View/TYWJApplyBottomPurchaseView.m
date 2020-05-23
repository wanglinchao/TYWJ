//
//  TYWJApplyBottomPurchaseView.m
//  TYWJBus
//
//  Created by tywj on 2020/3/13.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJApplyBottomPurchaseView.h"


@interface TYWJApplyBottomPurchaseView()
@property (strong, nonatomic) UIButton *purchaceBtn;
@property (strong, nonatomic) UIButton *interestBtn;
@end

@implementation TYWJApplyBottomPurchaseView

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
    
    UIButton *purchaceBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.zl_width/2 + 10, 0, (self.zl_width - 60)/2, 30.f)];
    purchaceBtn.zl_centerY = self.zl_height/2.f;
//    [purchaceBtn setTitle:@"购买" forState:UIControlStateNormal];
    purchaceBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [purchaceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [purchaceBtn setBackgroundColor:ZLColorWithRGB(68, 154, 208)];
    purchaceBtn.layer.cornerRadius = 10.0f;
    purchaceBtn.clipsToBounds = YES;
    [self addSubview:purchaceBtn];
    self.purchaceBtn = purchaceBtn;
    
    UIButton *interestBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, (self.zl_width - 60)/2, 30.f)];
    interestBtn.zl_centerY = self.zl_height/2.f;
    [interestBtn setTitle:@"不感兴趣" forState:UIControlStateNormal];
    [interestBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    interestBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    interestBtn.layer.cornerRadius = 10.0f;
    interestBtn.clipsToBounds = YES;
    interestBtn.layer.borderWidth = 1.0f;
    interestBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [self addSubview:interestBtn];
    self.interestBtn = interestBtn;
    
    
}


- (void)addPurchaceTarget:(id)target action:(SEL)action {
    [self.purchaceBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)addInterestTarget:(id)target action:(SEL)action {
    [self.interestBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setPrice:(NSString *)price {
    if (!price) return;
    [self.purchaceBtn setTitle:[NSString stringWithFormat:@"¥%@ 行程服务费",price] forState:UIControlStateNormal];
}

@end
