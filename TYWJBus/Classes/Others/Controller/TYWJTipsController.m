//
//  TYWJTipsController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/25.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJTipsController.h"
#import "TYWJTipsView.h"
#import "ZLCAAnimation.h"


static CGFloat const kTimeInterval = 0.3f;


@interface TYWJTipsController()

/* tipsView */
@property (strong, nonatomic) TYWJTipsView *tipsView;
/* effectView */
@property (weak, nonatomic) UIVisualEffectView *effectView;

@end

@implementation TYWJTipsController
#pragma mark - 懒加载
- (TYWJTipsView *)tipsView {
    if (!_tipsView) {
        _tipsView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TYWJTipsView class]) owner:nil options:nil] lastObject];
        _tipsView.zl_size = CGSizeMake(ZLScreenWidth - 88, 180.f);
        _tipsView.tipsLabel.text = @"tywj";
        _tipsView.center = self.view.center;
        
    }
    return _tipsView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor clearColor];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:effect];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.alpha = TYWJEffectViewAlpha;
    effectView.frame = self.view.bounds;
    [self.view addSubview:effectView];
    self.effectView = effectView;
    
    [self.view addSubview:self.tipsView];
    [self scaleAnimation];
    
    WeakSelf;
    self.tipsView.registerClicked = ^{
        [weakSelf animHideViewWithIsRegister:YES];
        
    };
    self.tipsView.changePhoneNumClicked = ^{
        [weakSelf animHideViewWithIsRegister:NO];
    };
}

- (void)scaleAnimation {
    [ZLCAAnimation zl_animationScaleMagnifyWithView:self.tipsView timeInterval:kTimeInterval];
    
}

#pragma mark - touch view

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self animHideViewWithIsRegister:NO];
}

- (void)animHideViewWithIsRegister:(BOOL)isRegister {
    WeakSelf;
    [ZLCAAnimation zl_animationScaleShrinkWithView:self.tipsView timeInterval:kTimeInterval];
    [UIView animateWithDuration:kTimeInterval animations:^{
        weakSelf.effectView.alpha = 0;
        weakSelf.tipsView.alpha = 0;
        
    } completion:^(BOOL finished) {
        if (weakSelf.viewClicked) {
            weakSelf.viewClicked(isRegister);
        }
    }];
}

#pragma mark - 外部方法

- (void)setTips:(NSString *)tips leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle {
    if (tips) {
        CGFloat textH = [tips sizeWithMaxSize:CGSizeMake(self.tipsView.tipsLabel.zl_width, MAXFLOAT) font:18.f].height;
        CGFloat h = self.tipsView.tipsLabel.zl_height;
        if (textH > h) {
            self.tipsView.zl_height += textH - h;
            self.tipsView.zl_centerY = self.view.zl_centerY;
        }
        self.tipsView.tipsLabel.text = tips;
    }
    if (leftTitle) {
        [self.tipsView.changePhoneBtn setTitle:leftTitle forState:UIControlStateNormal];
    }
    if (rightTitle) {
        [self.tipsView.registerBtn setTitle:rightTitle forState:UIControlStateNormal];
    }
}

- (void)setSingleBtnWithTips:(NSString *)tips {
     if (tips) {
         self.tipsView.sureBtn.hidden = NO;
         CGFloat textH = [tips sizeWithMaxSize:CGSizeMake(self.tipsView.tipsLabel.zl_width, MAXFLOAT) font:18.f].height;
         CGFloat h = self.tipsView.tipsLabel.zl_height;
         if (textH > h) {
             self.tipsView.zl_height += textH - h;
             self.tipsView.zl_centerY = self.view.zl_centerY;
         }
         self.tipsView.tipsLabel.text = tips;
     }
}
@end
