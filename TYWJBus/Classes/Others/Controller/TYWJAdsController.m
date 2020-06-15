//
//  TYWJAdsController.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/16.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJAdsController.h"
#import "ZLBorderButton.h"
#import "TYWJSingleLocation.h"
#import "ZLPopoverView.h"

#import <UMCommonLog/UMCommonLogHeaders.h>
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
#import <UMPush/UMessage.h>
#import <WXApi.h>


@interface TYWJAdsController ()

/* imgView */
@property (strong, nonatomic) UIImageView *imgView;
/* timer */
@property (strong, nonatomic) NSTimer *timer;
/* skipBtn */
@property (strong, nonatomic) ZLBorderButton *skipBtn;

@end

@implementation TYWJAdsController
#pragma mark - lazy loading
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.frame = self.view.bounds;
        _imgView.backgroundColor = [UIColor clearColor];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.userInteractionEnabled = true;
        UIGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapGettureTaped)];
        [_imgView addGestureRecognizer:gesture];
    }
    return _imgView;
}
- (void)imageTapGettureTaped{
    //跳转
    [self openWechatApplet];
}
- (void)openWechatApplet{
    NSString *path = [[NSUserDefaults standardUserDefaults] valueForKey:TYWJBanerJumpPath];
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = TYWJWechatAppletKey;  //拉起的小程序的username
    launchMiniProgramReq.path = path;    ////拉起小程序页面的可带参路径，不填默认拉起小程序首页，对于小游戏，可以只传入 query 部分，来实现传参效果，如：传入 "?foo=bar"。
    launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
    [WXApi sendReq:launchMiniProgramReq completion:^(BOOL success) {
        
    }];
}
#pragma mark - set up view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self setAdsImg];
    
    [self validateTimer];
}

- (void)setupView {
    self.view.backgroundColor = ZLGlobalBgColor;
    [self.view addSubview:self.imgView];
    [self addSkipBtn];
    
}

- (void)addSkipBtn {
    ZLBorderButton *skipBtn = [[ZLBorderButton alloc] init];
    skipBtn.zl_size = CGSizeMake(60.f, 30.f);
    skipBtn.zl_x = self.view.zl_width - 85.f;
    skipBtn.zl_y = kNavBarH - 64.f + 45.f;
    [skipBtn addTarget:self action:@selector(skipClicked) forControlEvents:UIControlEventTouchUpInside];
    [skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [skipBtn setRoundView];
    [self.view addSubview:skipBtn];
    self.skipBtn = skipBtn;
}

- (void)setAdsImg {
    NSData *imgData = [TYWJCommonTool getAdsImgData];
    if (imgData) {
        self.imgView.image = [UIImage imageWithData:imgData];
    }else {
        self.imgView.image = [UIImage imageNamed:@"1242*2208"];
    }
    
    [TYWJCommonTool requestAdsImgData];
}
- (void)config{
    //其他一系列设置
    [[TYWJCommonTool sharedTool] getDeviceId];
    [self setupAMapInfo];
    [self setupUMeng];
    [self setWXPay];
    //检测更新
    [self checkUpdate];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self config];
}


#pragma mark - 初始化设置，放在这里而不放在AppDelegate的didFinishLaunching里是为了减少APP启动时间
- (void)setupAMapInfo {
    [AMapServices sharedServices].apiKey = TYWJAMapKey;
}
#pragma mark - 友盟
- (void)setupUMeng {
    [UMConfigure initWithAppkey:TYWJUmengAppKey channel:nil];
    [UMConfigure setEncryptEnabled:YES];//打开加密传输
    [UMConfigure setLogEnabled:YES];//设置打开日志
    [UMCommonLogManager setUpUMCommonLogManager];
    [UMessage setBadgeClear:YES];
    [UMessage setAutoAlert:NO];
    [self configUShareSettings];
    [self configUSharePlatforms];
}

- (void)configUShareSettings
{
    /*
     * 打开图片水印
     */
    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:TYWJWechatAppKey appSecret:TYWJWechatSecretKey redirectURL:@"http://mobile.umeng.com/social"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    /* 支付宝的appKey */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:TYWJAliPayAppID appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
}

#pragma mark - 微信支付相关初始化设置

- (void)setWXPay {
    [WXApi registerApp:TYWJWechatAppKey universalLink:TYWJUniversalLinks];
}


#pragma mark - 检测版本更新

- (void)checkUpdate {
    [TYWJCommonTool checkUpdateIfUpdated:^(NSString *trackViewUrl){
        if (!trackViewUrl) return;
        
        [[ZLPopoverView sharedInstance] showTipsViewWithTips:@"有版本更新哦~~赶快去更新吧!" leftTitle:@"取消" rightTitle:@"好的" RegisterClicked:^{
            // 此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
            //https://itunes.apple.com/us/app/id1104867082?ls=1&mt=8
            //http://itunes.apple.com/app/id%@
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/app/id%@", kAppleStoreId]];
//            NSURL *url = [NSURL URLWithString:trackViewUrl];
            [[UIApplication sharedApplication] openURL:url];
        }];
    }];
}
#pragma mark - 定时器

- (void)validateTimer {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)invalidateTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)countDown {
    static int count = 3;
    count --;
    if (count == 0) {
        [self skipClicked];
    }
}
#pragma mark - 按钮点击

- (void)skipClicked {
    ZLFuncLog;
    [self invalidateTimer];
    [self animShowNextView];
}


- (void)animShowNextView {
    [self.view removeFromSuperview];
    /*
     fade                   //交叉淡化过渡(不支持过渡方向)
     push                   //新视图把旧视图推出去
     moveIn                 //新视图移到旧视图上面
     reveal                 //将旧视图移开,显示下面的新视图
     cube                   //立方体翻滚效果
     oglFlip                //上下左右翻转效果
     suckEffect             //收缩效果，向布被抽走(不支持过渡方向)
     rippleEffect           //水波效果(不支持过渡方向)
     pageCurl               //向上翻页效果
     pageUnCurl             //向下翻页效果
     cameraIrisHollowOpen   //相机镜头打开效果(不支持过渡方向)
     cameraIrisHollowClose  //相机镜头关上效果(不支持过渡方向)
     */
    CATransition *transition = [CATransition animation];
    transition.type = @"rippleEffect";
    transition.duration = 1.f;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:nil];
}

@end
