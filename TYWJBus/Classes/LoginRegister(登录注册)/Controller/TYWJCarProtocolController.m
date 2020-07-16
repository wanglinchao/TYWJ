//
//  TYWJCarProtocolController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJCarProtocolController.h"
#import "TYWJWebView.h"

@interface TYWJCarProtocolController ()<WKNavigationDelegate>
/* webView */
@property (strong, nonatomic) TYWJWebView *webView;
@end

@implementation TYWJCarProtocolController

#pragma mark - 懒加载

- (TYWJWebView *)webView {
    if (!_webView) {
        _webView = [[TYWJWebView alloc] init];
        _webView.frame = self.view.bounds;
        _webView.navigationDelegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _webView.zl_y += kNavBarH;
            _webView.zl_height -= kNavBarH;
        }
    }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self showUIRectEdgeNone];
}
- (void)setupView {
    NSString *requestUrl = nil;
    switch (self.type) {
        case TYWJCarProtocolControllerTypeCarProtocol:
        {
            self.navigationItem.title = @"用户使用协议";
            self.title = @"用户使用协议";
            requestUrl = TYWJCarProtocolUrl;
        }
            break;
        case TYWJCarProtocolControllerTypePrivacyPolicy:
        {
            self.navigationItem.title = @"服务协议";
            requestUrl = TYWJPrivacyUrl;
        }
            break;
        case TYWJCarProtocolControllerTypeTicketingInformation:
        {
            self.navigationItem.title = @"购买须知";
            requestUrl = TYWJTicketingInformation;
        }
            break;
        case TYWJCarProtocolControllerTypeRefundTicketingInformation:
        {
            self.navigationItem.title = @"退票规则";
            requestUrl = TYWJRefundTicketingInformation;
        }
            break;
        default:
            break;
    }
    [self.view addSubview:self.webView];
    [self.webView loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
    
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [MBProgressHUD showHUDAddedTo:CURRENTVIEW animated:YES];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [MBProgressHUD hideAllHUDsForView:CURRENTVIEW animated:YES];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error{
    [MBProgressHUD hideAllHUDsForView:CURRENTVIEW animated:YES];
}
@end
