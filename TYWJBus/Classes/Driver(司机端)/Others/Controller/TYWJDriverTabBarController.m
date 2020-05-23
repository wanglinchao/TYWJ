//
//  TYWJDriverTabBarController.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/30.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJDriverTabBarController.h"
#import "TYWJDriverHomeController.h"
#import "TYWJDriverMeController.h"
#import "TYWJNavigationController.h"


@interface TYWJDriverTabBarController ()<UIViewControllerTransitioningDelegate>

@end

@implementation TYWJDriverTabBarController

//添加所有的子控制器
- (void)addChidViewControllers {
    TYWJDriverHomeController *homeVc = [[TYWJDriverHomeController alloc] init];
    [self addChildViewController:homeVc image:@"icon_home_bus_nor" selectedImage:@"icon_home_bus_sel" title:@"通勤"];
    
    
//    TYWJDriverMessageController *msgVc = [[TYWJDriverMessageController alloc] init];
//    [self addChildViewController:msgVc image:@"icon_home_travel_nor" selectedImage:@"icon_home_travel_sel" title:@"打卡"];
    
    
    TYWJDriverMeController *meVc = [[TYWJDriverMeController alloc] init];
    [self addChildViewController:meVc image:@"icon_nav_my_nor" selectedImage:@"icon_nav_my_sel" title:@"我的"];
    
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
