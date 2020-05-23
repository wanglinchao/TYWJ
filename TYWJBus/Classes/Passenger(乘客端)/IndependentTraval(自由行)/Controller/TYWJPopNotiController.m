//
//  TYWJPopNotiController.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJPopNotiController.h"
#import "TYWJITNotiContentView.h"
#import "ZLCAAnimation.h"

static CGFloat const kTimeInterval = 0.4f;

@interface TYWJPopNotiController()

/* contentView */
@property (strong, nonatomic) TYWJITNotiContentView *contentView;

@end

@implementation TYWJPopNotiController

- (TYWJITNotiContentView *)contentView {
    if (!_contentView) {
        _contentView = [[[NSBundle mainBundle] loadNibNamed:@"TYWJITNotiContentView" owner:nil options:nil] lastObject];
        _contentView.backgroundColor = [UIColor whiteColor];
        [_contentView addTarget:self action:@selector(sureClicked)];
    }
    return _contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

- (void)setupView {
    [self.view addSubview:self.contentView];
    
    [self.contentView setRoundViewWithCornerRaidus:8.f];
    self.contentView.zl_size = CGSizeMake(self.view.zl_width*0.85f, self.view.zl_height*0.85f);
    self.contentView.zl_centerX = self.view.zl_width/2.f;
    self.contentView.zl_centerY = self.view.zl_height/2.f;
    
    [ZLCAAnimation zl_animationScaleMagnifyWithView:self.contentView timeInterval:kTimeInterval];
    WeakSelf;
    [UIView animateWithDuration:kTimeInterval animations:^{
        [weakSelf setEffectViewAlpha:TYWJEffectViewAlpha];
    } completion:^(BOOL finished) {
        [weakSelf.contentView.bodyTV setContentOffset:CGPointMake(0, 0) animated:YES];
    }];
}

#pragma mark - 按钮点击
- (void)sureClicked {
    ZLFuncLog;
    [self hideView];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    ZLFuncLog;
    [self hideView];
}

- (void)hideView {
    WeakSelf;
    [ZLCAAnimation zl_animationScaleShrinkWithView:self.contentView timeInterval:kTimeInterval];
    [UIView animateWithDuration:kTimeInterval delay:0 usingSpringWithDamping:1.f initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.contentView.alpha = 0;
        [weakSelf setEffectViewAlpha:0];
    } completion:^(BOOL finished) {
        if (weakSelf.viewClicked) {
            weakSelf.viewClicked();
        }
    }];
}

@end
