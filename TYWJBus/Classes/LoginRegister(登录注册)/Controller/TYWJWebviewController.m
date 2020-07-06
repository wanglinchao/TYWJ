//
//  TYWJWebviewController.m
//  TYWJBus
//
//  Created by tywj on 2020/7/6.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJWebviewController.h"
#import <WebKit/WebKit.h>
@interface TYWJWebviewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation TYWJWebviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration *webConfiguration = [WKWebViewConfiguration new];
    _webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:webConfiguration];
    NSString *urlStr = @"https://www.so.com";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];
    // Do any additional setup after loading the view from its nib.
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSLog(@"%@", webView.URL);
    NSLog(@"%@", navigationAction.request.URL);
    NSURL *url = navigationAction.request.URL;
    
    if ([url.absoluteString hasPrefix:@"http"]) {
        // The target frame, or nil if this is a new window navigation.
        if (!navigationAction.targetFrame) {
            [webView loadRequest:navigationAction.request];
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
//! Alert弹框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message ? : @"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

//! Confirm弹框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message ?: @"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];

    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

//! prompt弹框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text ? : @"");
    }];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
