//
//  TYWJFirstLaunchController.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/5.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJFirstLaunchController.h"
#import "ZLPageControl.h"
#import "TYWJTabBarController.h"
#import "AppDelegate.h"
#import "TYWJLoginController.h"
#import "TYWJNavigationController.h"
@interface TYWJFirstLaunchController ()<UIScrollViewDelegate>

/* pageControl */
@property (strong, nonatomic) ZLPageControl *pageControl;
/* 跳过按钮 */
@property (strong, nonatomic) UIButton *jumpBtn;
@end

@implementation TYWJFirstLaunchController
#pragma mark - lazy loading

- (ZLPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[ZLPageControl alloc] init];
        _pageControl.zl_centerX = self.view.zl_centerX;
        _pageControl.zl_y = self.view.zl_height - 30.f - kTabBarH;
        _pageControl.pageIndicatorTintColor = ZLColorWithRGB(254, 235, 196);
        _pageControl.currentPageIndicatorTintColor = ZLColorWithRGB(253, 191, 70);
        _pageControl.numberOfPages = 3;
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

- (UIButton *)jumpBtn {
    if (!_jumpBtn) {
        _jumpBtn = [[UIButton alloc] init];
        _jumpBtn.backgroundColor = ZLGrayColorWithRGB(218);
        [_jumpBtn setRoundView];
        [_jumpBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [_jumpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_jumpBtn addTarget:self action:@selector(jumpClicked) forControlEvents:UIControlEventTouchUpInside];
        _jumpBtn.zl_size = CGSizeMake(60.f, 30.f);
        _jumpBtn.zl_x = self.view.zl_width - 85.f;
        _jumpBtn.zl_y = kNavBarH - 64.f + 45.f;
        _jumpBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_jumpBtn setRoundView];
    }
    return _jumpBtn;
}

#pragma mark - set up view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    self.view.backgroundColor = ZLGlobalBgColor;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = ZLGlobalBgColor;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(ZLScreenWidth*3, 0);
    [self.view addSubview:scrollView];
    
    [self.view addSubview:self.pageControl];
    [self addImgViewWithScrollView:scrollView];
    [self.view addSubview:self.jumpBtn];
}

- (void)addImgViewWithScrollView:(UIScrollView *)scrollView {
    NSArray *imgs = @[@"onboarding_1",@"onboarding_2",@"onboarding_3"];
    NSInteger count = imgs.count;
    for (NSInteger i = 0;i < count;i++) {
        NSString *img = imgs[i];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imgView.zl_x = i*ZLScreenWidth;
        imgView.image = [UIImage imageNamed:img];
        if (2 == i) {
            imgView.userInteractionEnabled = YES;
            UIButton *btn = [[UIButton alloc] init];
            btn.zl_size = CGSizeMake(100.f, 40.f);
            btn.zl_centerX = imgView.zl_width/2.f;
            btn.zl_y = ZLScreenHeight - 100.f - kTabBarH;
            btn.layer.borderColor = ZLColorWithRGB(253, 191, 70).CGColor;
            btn.layer.borderWidth = 2.5f;
            btn.layer.masksToBounds = YES;
            [btn setTitleColor:ZLColorWithRGB(253, 191, 70) forState:UIControlStateNormal];
            [btn setTitle:@"立即体验" forState:UIControlStateNormal];
            [btn setRoundView];
            [btn addTarget:self action:@selector(jumpClicked) forControlEvents:UIControlEventTouchUpInside];
            [imgView addSubview:btn];
        }
        [scrollView addSubview:imgView];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/scrollView.zl_width;
    self.pageControl.currentPage = index;
}


#pragma mark - 按钮点击

- (void)jumpClicked {
        //存储版本号
        NSString *currentVersion = [TYWJCommonTool sharedTool].currentVersion;
        [ZLUserDefaults setObject:currentVersion forKey:TYWJAppVersion];
        if (LOGINSTATUS ) {
            [[TYWJCommonTool sharedTool] setRootVcWithTabbarVc];
        }else {
            TYWJLoginController *loginVC = [[TYWJLoginController alloc] init];
            TYWJNavigationController *nav = [[TYWJNavigationController alloc] initWithRootViewController:loginVC];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        }

}


@end
