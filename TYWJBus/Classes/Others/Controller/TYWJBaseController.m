//
//  TYWJBaseController.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/19.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBaseController.h"
#import "TYWJNoDataView.h"

@interface TYWJBaseController ()

@end

@implementation TYWJBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self base_setupView];
}

- (void)base_setupView {
    self.view.backgroundColor = ZLGlobalBgColor;
    if ([TYWJCommonTool sharedTool].currentSysVersion.floatValue < 11) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.view.zl_height -= kNavBarH;
    }
}
- (void)showNoDataViewWithDic:(NSDictionary *)dic{
    TYWJNoDataView *noDataView= [[TYWJNoDataView alloc] initWithFrame:self.view.bounds];
    if (dic.allKeys.count > 0) {
        [noDataView confirgCellWithParam:dic];
    } else {
        [noDataView confirgCellWithParam:@{@"image":@"行程_空状态",@"title":@"暂无数据"}];
    }
    [self.view addSubview:noDataView];
}
- (void)showRequestFailedViewWithImg:(NSString *)img tips:(NSString *)tips btnTitle:(NSString *)btnTitle btnClicked:(void(^)(void))btnClicked{
    [TYWJCommonTool loadNoDataViewWithImg:img tips:tips btnTitle:btnTitle isHideBtn:NO showingVc:self btnClicked:^(UIViewController *failedVc) {
        btnClicked();
        [failedVc removeFromParentViewController];
    }];
}
@end
