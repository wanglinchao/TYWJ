//
//  TYWJBasePopController.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/16.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBasePopController.h"

@interface TYWJBasePopController ()

/* effectView */
@property (strong, nonatomic) UIVisualEffectView *effectView;

@end

@implementation TYWJBasePopController
#pragma mark - 懒加载
- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _effectView.alpha = 0;
        _effectView.frame = self.view.bounds;
    }
    return _effectView;
}
#pragma mark - set up view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self p_basepo_setupView];
}

- (void)p_basepo_setupView {
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.effectView];
}

- (void)setEffectViewAlpha:(CGFloat)alpha {
    self.effectView.alpha = alpha;
}

@end
