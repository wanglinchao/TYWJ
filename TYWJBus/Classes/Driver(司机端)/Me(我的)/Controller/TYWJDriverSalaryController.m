//
//  TYWJDriverSalaryController.m
//  TYWJBus
//
//  Created by MacBook on 2018/8/29.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJDriverSalaryController.h"
#import "TYWJSoapTool.h"
#import "TYWJLoginTool.h"
#import "UICountingLabel.h"

@interface TYWJDriverSalaryController ()

/* label */
@property (strong, nonatomic) UICountingLabel *label;

@end

@implementation TYWJDriverSalaryController

- (UICountingLabel *)label {
    if (!_label) {
        _label = [[UICountingLabel alloc] init];
        _label.zl_size = CGSizeMake(self.view.zl_width, 100.f);
        _label.center = self.view.center;
        _label.font = [UIFont systemFontOfSize:46.f];
        _label.textColor = ZLColorWithRGB(255, 135, 36);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.format = @"¥%.1f";
    }
    return _label;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self setupView];
}

- (void)setupView {
    self.view.backgroundColor = ZLGlobalBgColor;
    self.navigationItem.title = @"今日通勤提成";
    
    [self.view addSubview:self.label];
}

#pragma mark - 加载数据
- (void)loadData {
    //TYWJRequestGetDriverRoute
    WeakSelf;
    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:weakSelf.view];
    self.label.text = @"加载中...";
    NSString *bodyStr = [NSString stringWithFormat:
                         @"<%@ xmlns=\"%@\">\
                         <yhm>%@</yhm>\
                         </%@>",TYWJRequestDriverSalary,TYWJRequestService,[TYWJLoginTool sharedInstance].phoneNum,TYWJRequestDriverSalary];
    
    [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:bodyStr success:^(id responseObject) {
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        NSString *resData = responseObject[0][@"NS1:getsijiqianbaoResponse"];
        if (resData) {
            [weakSelf.label countFrom:0 to:resData.floatValue];
        }
    } failure:^(NSError *error) {;
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:weakSelf.view];
        [weakSelf loadNoDataViewWithImg:@"icon_no_ticket" tips:@"网络差,请稍后重试~~" btnTitle:nil isHideBtn:NO];
    }];
}

#pragma mark - 显示no data view
- (void)loadNoDataViewWithImg:(NSString *)img tips:(NSString *)tips btnTitle:(NSString *)btnTitle isHideBtn:(BOOL)isHideBtn {
    
    WeakSelf;
    [TYWJCommonTool loadNoDataViewWithImg:img tips:tips btnTitle:btnTitle isHideBtn:isHideBtn showingVc:self btnClicked:^(UIViewController *failedVc) {
        [failedVc.view removeFromSuperview];
        
        [weakSelf loadData];
        [failedVc removeFromParentViewController];
    }];
//    for (UIView *view in self.view.subviews) {
//        [view removeFromSuperview];
//    }
//    TYWJRequestFailedController *vc = [[TYWJRequestFailedController alloc] init];
//    vc.view.frame = self.view.bounds;
//    vc.view.zl_y = kNavBarH;
//    vc.view.zl_height -= kNavBarH;
//    [self.view addSubview:vc.view];
//    WeakSelf;
//    __weak typeof(vc) weakVc = vc;
//    [vc setImg:img tips:tips btnTitle:btnTitle isHideBtn:isHideBtn];
//    vc.reloadClicked = ^{
//        [weakVc.view removeFromSuperview];
//        [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:weakSelf.view];
//        [weakSelf loadData];
//        [weakVc removeFromParentViewController];
//    };
//    [self.view addSubview:vc.view];
//    [self addChildViewController:vc];
}

@end
