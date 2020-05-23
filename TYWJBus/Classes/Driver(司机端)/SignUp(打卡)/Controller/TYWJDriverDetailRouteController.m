//
//  TYWJDriverDetailRouteController.m
//  TYWJBus
//
//  Created by MacBook on 2018/12/13.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJDriverDetailRouteController.h"

@interface TYWJDriverDetailRouteController ()<UIWebViewDelegate>

/* webView */
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation TYWJDriverDetailRouteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"行程详情";
    self.view.backgroundColor = ZLGlobalBgColor;
    // Do any additional setup after loading the view.
     //https://www.meibanlu.com/manager-web/itinerary.html?id=2760767
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_webView];
    
    NSString *requestUrl = [NSString stringWithFormat:@"https://www.meibanlu.com/manager-web/itinerary.html?id=%@",self.ID];
    [_webView loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
    
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [MBProgressHUD zl_hideHUDForView:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:self.view];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [MBProgressHUD zl_hideHUDForView:self.view];
}

@end
