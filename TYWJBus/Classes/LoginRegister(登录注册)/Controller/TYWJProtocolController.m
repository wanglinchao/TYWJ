//
//  TYWJCarProtocolController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJProtocolController.h"
#import "TYWJWebView.h"

@interface TYWJProtocolController ()

/* webView */
@property (strong, nonatomic) TYWJWebView *webView;

@end

@implementation TYWJProtocolController

#pragma mark - 懒加载

- (TYWJWebView *)webView {
    if (!_webView) {
        _webView = [[TYWJWebView alloc] init];
        _webView.frame = CGRectMake(0, kNavBarH, ZLScreenWidth, ZLScreenHeight - kNavBarH);
        //        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        //        _webView.scrollView.contentInset = UIEdgeInsetsMake(-64.f, 0, 0, 0);
        if (@available(iOS 11.0, *)) {
            _webView.frame = self.view.bounds;
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
}
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
            self.navigationItem.title = @"隐私政策";
            requestUrl = TYWJPrivacyUrl;
        }
            break;
        case TYWJCarProtocolControllerTypeTicketingInformation:
        {
            self.navigationItem.title = @"购买须知";
            requestUrl = TYWJTicketingInformation;
        }
            break;
            
        default:
            break;
    }
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, kNavBarH - 44, 44.f, 44.f)];
    leftBtn.tag = 200;
    [leftBtn setTitle:@"查看绩效" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [leftBtn setImage:[UIImage imageNamed:@"导航栏_图标_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor blackColor];
    label.frame = CGRectMake(0, kNavBarH - 44 , ZLScreenWidth, 44);
    label.textAlignment = NSTextAlignmentCenter;
    label.alpha = 0.5f;
    label.text = self.title;
    [self.view addSubview:label];
    [self.view addSubview:self.webView];
    
    
    
    [self.webView loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
    
}



@end
