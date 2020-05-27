//
//  TYWJTabBarController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/22.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJTabBarController.h"
#import "TYWJNavigationController.h"
#import "TYWJCommuteController.h"
#import "TYWJSchedulingViewController.h"
#import "TYWJMeController.h"
@interface TYWJTabBarController ()

@end

@implementation TYWJTabBarController

//添加所有的子控制器
- (void)addChidViewControllers {
    TYWJCommuteController *commuteVc = [[TYWJCommuteController alloc] init];
    commuteVc.type = TYWJCommuteControllerTypeCommute;
    [self addChildViewController:commuteVc image:@"tabbar_home" selectedImage:@"tabbar_home_selected" title:@"首页"];
    
    TYWJSchedulingViewController *schedulingVc = [[TYWJSchedulingViewController alloc] init];
    [self addChildViewController:schedulingVc image:@"tabbar_trip" selectedImage:@"tabbar_trip_selected" title:@"行程"];
    

    
    TYWJMeController *meVc = [[TYWJMeController alloc] init];
        [self addChildViewController:meVc image:@"tabar_mine" selectedImage:@"tabar_mine_selected" title:@"我的"];
}

//单独添加一个子控制器方法
- (void)addChildViewController:(UIViewController *)childController image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title {
    if (!title) {
        ZLLog(@"error-----控制器tabbar title为空");
        return;
    }
    
    childController.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.title = title;
    TYWJNavigationController *nav = [[TYWJNavigationController alloc] initWithRootViewController:childController];
    [self addChildViewController:nav];
}

@end
