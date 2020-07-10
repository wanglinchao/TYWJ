//
//  TYWJNavigationController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/22.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJNavigationController.h"
#import "UIBarButtonItem+NaviItem.h"
#import "WRNavigationBar.h"



@interface TYWJNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation TYWJNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

+ (void)initialize {
    
    //设置navBar的背景颜色
//    [[UINavigationBar appearance] setBarTintColor:ZLNavBgColor];
    
    //设置title的显示的属性
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:17.0],
                                                           NSForegroundColorAttributeName : [UIColor darkGrayColor]
                                                           }];
//    [[UINavigationBar appearance] setTranslucent:NO];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} forState:UIControlStateHighlighted];
    
    // 设置是 广泛使用WRNavigationBar，还是局部使用WRNavigationBar，目前默认是广泛使用
    [WRNavigationBar wr_widely];
    //    [WRNavigationBar wr_setBlacklist:@[@"SpecialController",
    //                                       @"TZPhotoPickerController",
    //                                       @"TZGifPhotoPreviewController",
    //                                       @"TZAlbumPickerController",
    //                                       @"TZPhotoPreviewController",
    //                                       @"TZVideoPlayerController"]];
    
    // 设置导航栏默认的背景颜色
    [WRNavigationBar wr_setDefaultNavBarBarTintColor:ZLNavBgColor];
    // 设置导航栏所有按钮的默认颜色
    [WRNavigationBar wr_setDefaultNavBarTintColor:ZLNavTextColor];
    
    // 设置导航栏标题默认颜色
    //    [WRNavigationBar wr_setDefaultNavBarTitleColor:[UIColor darkGrayColor]];
    // 统一设置状态栏样式
    //    [WRNavigationBar wr_setDefaultStatusBarStyle:UIStatusBarStyleLightContent];
    // 如果需要设置导航栏底部分割线隐藏，可以在这里统一设置
    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:YES];
    
    
}


#pragma mark - set up view
- (void)setupView {
    //设置向左滑动pop功能
    self.interactivePopGestureRecognizer.delegate = self;
    
    self.view.backgroundColor = ZLNavBgColor;
}
#pragma mark - 重写push方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    
    
    if (self.childViewControllers.count > 0) {
        /**
         *  重新设置返回按钮
         */
        
        viewController.hidesBottomBarWhenPushed = YES;
        //设置返回按钮
        UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftbutton setImage:[UIImage imageNamed:@"icon_nav_back"] forState:UIControlStateNormal];
        [leftbutton setTitleColor:ZLNavTextColor forState:UIControlStateNormal];
        leftbutton.zl_size = CGSizeMake(40, 40);
        leftbutton.titleLabel.font = [UIFont systemFontOfSize:15];
        leftbutton.imageEdgeInsets = UIEdgeInsetsMake(0,0, 0, 20);
        [leftbutton addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    }
    [super pushViewController:viewController animated:animated];
    
    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.65f];
//    [super pushViewController:viewController animated:NO];
//    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:NO];
//    [UIView commitAnimations];
}

//- (UIViewController *)popViewControllerAnimated:(BOOL)animated
//{
//    if (self.childViewControllers.count > 1) {
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.65f];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:NO];
//        [UIView commitAnimations];
//
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDelay:0.35];
//        UIViewController *viewController = [super popViewControllerAnimated:NO];
//        [UIView commitAnimations];
//
//        return viewController;
//    }else {
//        UIViewController *vc = [super popViewControllerAnimated:animated];
//        return vc;
//    }
//}
#pragma mark - 返回按钮点击事件
- (void)backClicked {
    if (self.isBlockPop) {
        if (self.blockPop) {
            self.blockPop();
        }
        return;
    }
    [self popViewControllerAnimated:YES];
}
#pragma mark - 恢复侧滑功能,和侧滑出侧滑界面

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.isBlockPop) {
        return NO;
    }
    
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count < 2) {
            return NO;
        }
    }
    return YES;
}

@end
