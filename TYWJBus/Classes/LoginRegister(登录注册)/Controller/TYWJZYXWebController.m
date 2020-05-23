//
//  TYWJZYXWebController.m
//  TYWJBus
//
//  Created by MacBook on 2018/8/13.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJZYXWebController.h"
#import "ZLMD5Encrypt.h"
#import "TYWJLoginTool.h"
#import "TYWJWebView.h"
#import "WebViewJavascriptBridge.h"
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>



@interface TYWJZYXWebController ()

/* webView */
@property (strong, nonatomic) WKWebView *webView;
@property(nonatomic, copy)NSString *htmlBody;
/* homeUrl */
@property (copy, nonatomic) NSString *homeUrl;

/* 是否是第一次加载 */
@property (assign, nonatomic) BOOL isFirstLaunch;
/* backBtn */
@property (weak, nonatomic) UIButton *backBtn;

@property(strong, nonatomic) WebViewJavascriptBridge* bridge;

@property (weak, nonatomic) UIButton *shareBtn;

@property (assign, nonatomic) BOOL shareBtnHidden;

/* imgUrl */
@property (copy, nonatomic) NSString *imgUrlStr;
/* title */
@property (copy, nonatomic) NSString *titleStr;
/* link */
@property (copy, nonatomic) NSString *linkStr;

@end

@implementation TYWJZYXWebController
#pragma mark - 懒加载

- (WKWebView *)webView {
    if (!_webView) {
//        _webView = [[WKWebView alloc] init];
//        _webView.frame = self.view.bounds;
////        _webView.delegate = self;
//        _webView.backgroundColor = [UIColor whiteColor];
//        _webView.scalesPageToFit = YES;
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = [WKUserContentController new];
        
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
//        preferences.minimumFontSize = 30.0;
        configuration.preferences = preferences;
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _webView.zl_y += kNavBarH;
            _webView.zl_height -= kNavBarH;
        }
    }
    return _webView;
}

#pragma mark - set up view

- (void)dealloc {
    ZLFuncLog;
    
//    _webView.delegate = nil;
    [_webView loadHTMLString:@"" baseURL:nil];
    _webView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    
}

- (void)setupView {
    self.isFirstLaunch = YES;
    self.view.backgroundColor = ZLGlobalBgColor;
    if (self.navTitle) {
        self.navigationItem.title = self.navTitle;
    }else {
        self.navigationItem.title = @"周边游";
    }
    
    [self.view addSubview:self.webView];
    
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30.f, 20.f)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [backBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    backBtn.hidden = YES;
    self.backBtn = backBtn;
    UIBarButtonItem *oBtn = self.navigationItem.leftBarButtonItem;
    self.navigationItem.leftBarButtonItems = @[oBtn,[[UIBarButtonItem alloc] initWithCustomView:backBtn]];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30.f, 20.f)];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [shareBtn setTitleColor:ZLColorWithRGB(250, 205, 0) forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.hidden = YES;
    self.shareBtn = shareBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    
    [self loadReq];
    
}

- (void)shareBtnClicked
{
    [self.bridge callHandler:@"functionInJs" data:nil responseCallback:^(id responseData) {
//        ZLLog(@"ObjC received response: %@", responseData);
        self.imgUrlStr = responseData[@"imgUrl"];
        self.titleStr = responseData[@"title"];
        self.linkStr = responseData[@"link"];
    }];
    
    [self showShareUI];
}

- (void)loadRequestData {
    //http://www.cd917.com/app/main.html#/tab/orderList
    NSString *url = [NSString stringWithFormat:@"%@%@",TYWJCd917Service,@"/login/AgentUserLoginAndRedirect"];
    NSString *rUrl = [NSString stringWithFormat:@"%@%@",TYWJCd917Service,@"/app/main.html#/tab/home/"];
    NSString *urlStr = [TYWJCommonTool urlEncodeWithUrl:rUrl];
    //@"http://beta.cd917.com/app/main.html#/tab/home";
    
    //推荐码,为空则默认设置为10000
    NSString *rCode = self.recommendationCode ? self.recommendationCode : @"10000";
    //电话号码
    NSString *phoneNum = [TYWJLoginTool sharedInstance].phoneNum;
    //917apiKey
    NSString *apiKey = TYWJCd917ApiKey;
    //917apiSecret
    NSString *apiSecret = TYEJCd917AppSecret;
    NSString *beforeSign = [NSString stringWithFormat:@"%@apiKey%@RecommendCode%@returnUrl%@Tel%@%@",apiSecret,apiKey,rCode,urlStr,phoneNum,apiSecret];
    //md5前的签名
    beforeSign = [beforeSign uppercaseString];
    
    //md5后的签名
    NSString *afterSign = [ZLMD5Encrypt MD5ForLower32Bate:beforeSign];
    ZLLog(@"sign -- %@",afterSign);
    
    //请求url
    url = [NSString stringWithFormat:@"%@?apiKey=%@&RecommendCode=%@&ReturnUrl=%@&Tel=%@&sign=%@",url,apiKey,rCode,urlStr,phoneNum,afterSign];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
}


- (void)loadReq {
//    NSString *urlString = @"http://www.pddaoyou.com/od/";
    if (self.url) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }else {
        NSString *urlString = @"https://dzyydh.cd917.com/od/";
        NSString *appId = @"f8ad763b241c75ip";
        NSString *appSecret = @"5c1046C90d4d5a515Aip33d5a9B67204";
        NSString *phoneNum = [TYWJLoginTool sharedInstance].phoneNum;
        NSString *sign = [ZLMD5Encrypt MD5ForLower32Bate: [NSString stringWithFormat:@"%@%@%@",appId,phoneNum,appSecret]];
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"%@-%@-%@",appId,phoneNum,sign]];
        self.homeUrl = urlString;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    }
    
    
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];
    
}

#pragma mark - WKNavigationDelegate
 // 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:self.view];
}
    // 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    ZLFuncLog;
//    [self.progressView setProgress:0.0f animated:NO];
}
    // 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    ZLFuncLog;
}
    // 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [MBProgressHUD zl_hideHUDForView:self.view];
    self.backBtn.hidden = !webView.canGoBack;
    self.shareBtn.hidden = self.shareBtnHidden;
}

// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURL * url = navigationAction.request.URL;
    NSString *pathStr = [url.path substringToIndex:4];
    if ([pathStr isEqualToString:@"/act"]) {
        self.shareBtnHidden = NO;
    }else {
        self.shareBtnHidden = YES;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [MBProgressHUD zl_hideHUDForView:self.view];
}



#pragma mark - 按钮点击

- (void)backClicked {
    ZLFuncLog;
    [self.webView goBack];
}

- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.titleStr descr:nil thumImage:self.imgUrlStr];
    //设置网页地址
    shareObject.webpageUrl = self.linkStr;

    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            ZLLog(@"************Share fail with error %@*********",error);
        }else{
            ZLLog(@"response data is %@",data);
        }
    }];
}

- (void)showShareUI {
    //显示分享面板
    WeakSelf;
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        switch (platformType) {
            case UMSocialPlatformType_WechatTimeLine:
            case UMSocialPlatformType_WechatSession:
//            case UMSocialPlatformType_WechatFavorite:
//            case UMSocialPlatformType_AlipaySession:
            {
                [weakSelf shareImageAndTextToPlatformType:platformType];
            }
                break;
                
            default:
                break;
        }
    }];
}

@end
