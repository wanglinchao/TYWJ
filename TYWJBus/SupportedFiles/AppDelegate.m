//
//  AppDelegate.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/22.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "AppDelegate.h"
#import "TYWJLoginTool.h"
#import "TYWJAdsController.h"
#import "TYWJCommonTool.h"
#import "ZLPopoverView.h"
#import "TYWJMyTicketController.h"
#import "ZLScrollTitleViewController.h"
#import "TYWJTabBarController.h"
#import "TYWJNavigationController.h"
#import "TYWJFirstLaunchController.h"
#import "ZLCAAnimation.h"
#import "TYWJLoginController.h"
#import <UserNotifications/UserNotifications.h>
#import <WechatOpenSDK/WXApiObject.h>
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import <UMCommonLog/UMCommonLogHeaders.h>
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
#import <UMPush/UMessage.h>
#import <AFNetworking/AFNetworking.h>



@interface AppDelegate ()<UNUserNotificationCenterDelegate,WXApiDelegate,UITabBarDelegate>

@end

@implementation AppDelegate

#pragma mark - application生命周期
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:ZLScreenBounds];
    [self.window makeKeyAndVisible];
    [self setupVC];
    [self addADSView];
    return YES;
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



//#pragma mark - 友盟推送
//
//- (void)setupUMengPushWithaLunchOptions:(NSDictionary *)launchOptions {
//    // Push功能配置
//    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
//    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert|UMessageAuthorizationOptionSound;
//    //如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
//    if (([[[UIDevice currentDevice] systemVersion]intValue]>=8)&&([[[UIDevice currentDevice] systemVersion]intValue]<10)) {
//        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
//        action1.identifier = @"action1_identifier";
//        action1.title=@"打开应用";
//        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
//
//        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
//        action2.identifier = @"action2_identifier";
//        action2.title=@"忽略";
//        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
//        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
//        action2.destructive = YES;
//        UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
//        actionCategory1.identifier = @"category1";//这组动作的唯一标示
//        [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
//        NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
//        entity.categories=categories;
//    }
//    //如果要在iOS10显示交互式的通知，必须注意实现以下代码
//    if (@available(iOS 10.0, *)) {
//        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
//        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
//
//        //UNNotificationCategoryOptionNone
//        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
//        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
//        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category1" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
//        NSSet *categories = [NSSet setWithObjects:category1_ios10, nil];
//        entity.categories = categories;
//        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
//    }
//
//    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        if (granted) {
//        }else{
//        }
//    }];
//}

//iOS10以下使用这两个方法接收通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion] intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

////iOS10新增：处理前台收到通知的代理方法
//-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [UMessage setAutoAlert:NO];
//        //应用处于前台时的远程推送接受
//        //必须加这句代码
//        [UMessage didReceiveRemoteNotification:userInfo];
//    }else{
//        //应用处于前台时的本地推送接受
//    }
//    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
//}

////iOS10新增：处理后台点击通知的代理方法
//-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        //应用处于后台时的远程推送接受
//        //必须加这句代码
//        [UMessage didReceiveRemoteNotification:userInfo];
//    }else{
//        //应用处于后台时的本地推送接受
//    }
//}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [UMessage registerDeviceToken:deviceToken];
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
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WeChatLoginCode" object:self userInfo:dictionary];
            }
    }
}

#pragma mark -3Dtouch功能
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler{
    //判断先前我们设置的唯一标识
    NSLog(@"选择了3Dtouch功能--%@",shortcutItem.type);
    
    if ([shortcutItem.type isEqualToString:@"myTicket"]) {
        TYWJMyTicketController *ticketVc = [[TYWJMyTicketController alloc] init];
        [TYWJCommonTool pushToVc:ticketVc];
    }else {
        ZLScrollTitleViewController *routeVc = [[TYWJCommonTool sharedTool] setMyRouteVc];
        [TYWJCommonTool pushToVc:routeVc];
    }
    
}


#pragma mark -- tabbarDelegate，主要用于检测当前用户是否登录并且，若未登录则弹出登录页面

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    UIViewController *selected = [tabBarController selectedViewController];
    if ([selected isEqual:viewController]) {
        return NO;
    }
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

    TYWJTabBarController *tabbarVc = [[TYWJTabBarController alloc] init];
    [[TYWJCommonTool sharedTool] setPassengerRootVcWithTabbarVc:tabbarVc];
    return;

}
- (void)addADSView {
    TYWJAdsController *adsVc = [[TYWJAdsController alloc] init];
    [adsVc config];
}


@end
