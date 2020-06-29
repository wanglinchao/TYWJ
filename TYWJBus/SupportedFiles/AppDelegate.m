//
//  AppDelegate.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/22.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "AppDelegate.h"
#import "AvoidCrash.h"
#import "TYWJAdsController.h"
#import "TYWJCommonTool.h"
#import "ZLPopoverView.h"
#import "TYWJTabBarController.h"
#import "TYWJNavigationController.h"
#import "TYWJFirstLaunchController.h"
#import "ZLCAAnimation.h"
#import <UserNotifications/UserNotifications.h>
#import <WechatOpenSDK/WXApiObject.h>
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import <UMCommonLog/UMCommonLogHeaders.h>
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
#import <UMPush/UMessage.h>
#import "TYWJSchedulingViewController.h"
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import "TYWJLoginController.h"
#import "TYWJChooseUserTypeView.h"
#import "AddUMMethod.h"
@interface AppDelegate ()<UNUserNotificationCenterDelegate,WXApiDelegate,UITabBarDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate

#pragma mark - application生命周期
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:ZLScreenBounds];
    [self.window makeKeyAndVisible];
//    [AvoidCrash makeAllEffective];
    [AddUMMethod activeAction];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
    [self addNoti];

    
    
    
    
    // Optional
    // 获取 IDFA
    // 如需使用 IDFA 功能请添加此代码并在初始化方法的 advertisingIdentifier 参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    [JPUSHService setupWithOption:launchOptions appKey:@"cb6312be24042f7fe2834b12"
                          channel:@"App Store"
                 apsForProduction:0
            advertisingIdentifier:advertisingId];
    
    
    //Required
     //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
     JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
     entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
     if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
       // 可以添加自定义 categories
       // NSSet<UNNotificationCategory *> *categories for iOS10 or later
       // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
     }
     [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [self setupVC];
    [self addADSView];
    return YES;
}
- (void)addNoti{

    
    

}
- (void)dealwithCrashMessage:(NSNotification *)note {
    //注意:所有的信息都在userInfo中
    //你可以在这里收集相应的崩溃信息进行相应的处理(比如传到自己服务器)
    NSLog(@"%@",note.userInfo);
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [ZLNotiCenter postNotificationName:TYWJAppDidEnterBgNoti object:nil];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [ZLNotiCenter postNotificationName:TYWJAppDidEnterFgNoti object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - others


#pragma mark - 支付宝支付

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            ZLLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            ZLLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            ZLLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }else if ([url.host isEqualToString:@"pay"]) {
        [WXApi handleOpenURL:url delegate:self];
    }else if ([url.host isEqualToString:@"platformId=wechat"]) {
        //分享
        
    } else if([[url absoluteString] hasPrefix:[NSString stringWithFormat:@"%@://oauth?code=",TYWJWechatAppKey]]){
        
        [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

#pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
  if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    //从通知界面直接进入应用
  }else{
    //从通知设置界面进入应用
  }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
  // Required
  NSDictionary * userInfo = notification.request.content.userInfo;
  if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [JPUSHService handleRemoteNotification:userInfo];
  }
  completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
  // Required
  NSDictionary * userInfo = response.notification.request.content.userInfo;
  if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [JPUSHService handleRemoteNotification:userInfo];
  }
  completionHandler();  // 系统要求执行这个方法
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

  // Required, iOS 7 Support
  [JPUSHService handleRemoteNotification:userInfo];
  completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

  // Required, For systems with less than or equal to iOS 6
  [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  //Optional
  NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}



// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}



//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的
- (void)onResp:(BaseResp *)resp
{
    //启动微信支付的response
    //    NSString *payResult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if ([resp isKindOfClass:[PayResp class]]){//支付回调
        NSDictionary *dicOfResult = @{ TYWJWechatPayResult:resp };
        [ZLNotiCenter postNotificationName:TYWJWechatPayResultNoti object:dicOfResult];
    }else if ([resp isKindOfClass:[WXLaunchMiniProgramResp class]])//小程序回调
    {
        //         NSString *string = resp.extMsg;
        // 对应JsApi navigateBackApplication中的extraData字段数据
        //TODO:这里需要处理小程序回调
        NSLog(@"%@",resp);
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
            NSDictionary *dictionary = @{@"code":code};
            [ZLNotiCenter postNotificationName:@"WeChatLoginCode" object:self userInfo:dictionary];
        }
    }
}

#pragma mark -3Dtouch功能
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler{
    //判断先前我们设置的唯一标识
    NSLog(@"选择了3Dtouch功能--%@",shortcutItem.type);
    
    if ([shortcutItem.type isEqualToString:@"myTicket"]) {
        
    }else {
        
    }
    
}


#pragma mark -- tabbarDelegate，主要用于检测当前用户是否登录并且，若未登录则弹出登录页面

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    if (!LOGINSTATUS) {
//        UIViewController *vc = viewController.childViewControllers.firstObject;
//        if ([vc isKindOfClass:[TYWJSchedulingViewController class]]) {
//            [TYWJGetCurrentController showLoginViewWithSuccessBlock:^{
//            }];
//            return NO;
//        }
//    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [ZLCAAnimation zl_transitionWithView:tabBarController.view type:ZLTransitionTypeFade timeInterval:0.25f];
}

/**
 根据登录状态显示哪个页面
 */
- (void)setupVC {
       
    if ([TYWJCommonTool checkIfFirstLaunch]) {
        TYWJFirstLaunchController *vc = [[TYWJFirstLaunchController alloc] init];
        self.window.rootViewController = vc;
        return;
    }
    if (LOGINSTATUS ) {
        [[TYWJCommonTool sharedTool] setRootVcWithTabbarVc];
    }else {
        TYWJLoginController *loginVC = [[TYWJLoginController alloc] init];
        TYWJNavigationController *nav = [[TYWJNavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = nav;
    }
}
- (void)addADSView {
    TYWJAdsController *adsVc = [[TYWJAdsController alloc] init];
    [adsVc config];
}


@end
