//
//  TYWJCarProtocolController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJCarProtocolController.h"
#import "TYWJWebView.h"

@interface TYWJCarProtocolController ()

/* webView */
@property (strong, nonatomic) TYWJWebView *webView;

@end

@implementation TYWJCarProtocolController

#pragma mark - 懒加载

- (TYWJWebView *)webView {
    if (!_webView) {
        _webView = [[TYWJWebView alloc] init];
        _webView.frame = self.view.bounds;
//        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
//        _webView.scrollView.contentInset = UIEdgeInsetsMake(-64.f, 0, 0, 0);
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

- (void)addTestView {
    UIView *view = [[UIView alloc] init];
    view.frame = self.view.bounds;
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor cyanColor];
    btn.frame = CGRectMake(0, 0, 100, 35);
    btn.center = view.center;
    [view addSubview:btn];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(60, 0, 60, 25);
    label.textAlignment = NSTextAlignmentCenter;
    label.alpha = 0.5f;
    label.center = CGPointMake(btn.zl_width/2.f, btn.zl_height/2.f);
    label.backgroundColor = btn.backgroundColor;
    label.text = @"TEST";
    [btn addSubview:label];
    
    btn.layer.shouldRasterize = NO;
    btn.alpha = 0.5f;
    
//    NSArray *windows = [UIApplication sharedApplication].windows;
//    for (UIWindow *window in windows) {
//        UIViewController *vc = window.rootViewController;
//        if ([vc isKindOfClass: [QYStartADViewController class]]) {
//            window.hidden = YES;
//            break;
//        }
//    }
//    
//    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
}




@end
