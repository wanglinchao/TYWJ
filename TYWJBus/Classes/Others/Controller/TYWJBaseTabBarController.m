//
//  TYWJTabBarController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/22.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBaseTabBarController.h"
#import "TYWJNavigationController.h"
#include <objc/runtime.h>


@interface TYWJBaseTabBarController ()

@end

@implementation TYWJBaseTabBarController
#pragma mark - 设置view

+ (void)initialize {
    //    [[UITabBar appearance] setBarTintColor: [UIColor whiteColor]];
    [[UITabBar appearance] setTintColor:ZLNavTextColor];
    //    [UITabBar appearance].translucent = NO;
}


//view初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    [self configureModalAnimation];
    [self setupView];
}

//修复iOS12.1的bug
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 12.1, *)) {
            OverrideImplementation(NSClassFromString(@"UITabBarButton"), @selector(setFrame:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP originIMP) {
                return ^(UIView *selfObject, CGRect firstArgv) {
                    
                    if ([selfObject isKindOfClass:originClass]) {
                        // 如果发现即将要设置一个 size 为空的 frame，则屏蔽掉本次设置
                        if (!CGRectIsEmpty(selfObject.frame) && CGRectIsEmpty(firstArgv)) {
                            return;
                        }
                    }
                    
                    // call super
                    void (*originSelectorIMP)(id, SEL, CGRect);
                    originSelectorIMP = (void (*)(id, SEL, CGRect))originIMP;
                    originSelectorIMP(selfObject, originCMD, firstArgv);
                };
            });
        }
    });
}

/**
 *  用 block 重写某个 class 的指定方法
 *  @param targetClass 要重写的 class
 *  @param targetSelector 要重写的 class 里的实例方法，注意如果该方法不存在于 targetClass 里，则什么都不做
 *  @param implementationBlock 该 block 必须返回一个 block，返回的 block 将被当成 targetSelector 的新实现，所以要在内部自己处理对 super 的调用，以及对当前调用方法的 self 的 class 的保护判断（因为如果 targetClass 的 targetSelector 是继承自父类的，targetClass 内部并没有重写这个方法，则我们这个函数最终重写的其实是父类的 targetSelector，所以会产生预期之外的 class 的影响，例如 targetClass 传进来  UIButton.class，则最终可能会影响到 UIView.class），implementationBlock 的参数里第一个为你要修改的 class，也即等同于 targetClass，第二个参数为你要修改的 selector，也即等同于 targetSelector，第三个参数是 targetSelector 原本的实现，由于 IMP 可以直接当成 C 函数调用，所以可利用它来实现“调用 super”的效果，但由于 targetSelector 的参数个数、参数类型、返回值类型，都会影响 IMP 的调用写法，所以这个调用只能由业务自己写。
 */
CG_INLINE BOOL
OverrideImplementation(Class targetClass, SEL targetSelector, id (^implementationBlock)(Class originClass, SEL originCMD, IMP originIMP)) {
    Method originMethod = class_getInstanceMethod(targetClass, targetSelector);
    if (!originMethod) {
        return NO;
    }
    IMP originIMP = method_getImplementation(originMethod);
    method_setImplementation(originMethod, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originIMP)));
    return YES;
}

//设置view
- (void)setupView {
    [self addChidViewControllers];
}
/**
 设置模态转场动画
 */
- (void)configureModalAnimation {
    self.transitioningDelegate = self;
    self.modalTransitionStyle = UIModalPresentationCustom;
}
//添加所有的子控制器
- (void)addChidViewControllers {

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
