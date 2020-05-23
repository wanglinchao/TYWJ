//
//  TYWJCouponController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/25.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJCouponController.h"
#import "TYWJRequestFailedController.h"


@interface TYWJCouponController()

@end

@implementation TYWJCouponController

- (void)dealloc {
    ZLFuncLog;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self showNoDataView];
}

- (void)setupView {
    self.navigationItem.title = @"优惠券";
}

- (void)showNoDataView {
    TYWJRequestFailedController *vc = [[TYWJRequestFailedController alloc] init];
    vc.view.frame = self.view.bounds;
    vc.view.zl_y = kNavBarH;
    vc.view.zl_height -= kNavBarH;
    [self.view addSubview:vc.view];
    [vc setImg:@"discount_empty_162x130_" tips:@"您还没有优惠券哦~~" btnTitle:@"" isHideBtn:YES];
    [self.view addSubview:vc.view];
}
@end
