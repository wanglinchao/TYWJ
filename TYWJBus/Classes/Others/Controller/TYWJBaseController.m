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
        self.edgesForExtendedLayout = UIRectEdgeTop;
        self.view.zl_height -= kNavBarH;
    }
}
- (void)showUIRectEdgeNone{
    if ([TYWJCommonTool sharedTool].currentSysVersion.floatValue < 11) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}
- (void)showNoDataViewWithDic:(NSDictionary *)dic{
    TYWJNoDataView *noDataView= [[TYWJNoDataView alloc] initWithFrame:CGRectMake(0, (self.view.zl_height - kNavBarH - kTabBarH - 412)/2, ZLScreenWidth, 212)];
    if (dic.allKeys.count > 0) {
        [noDataView confirgCellWithParam:dic];
    } else {
        [noDataView confirgCellWithParam:@{@"image":@"行程_空状态",@"title":@"这里空空如也"}];
    }
//    noDataView.center = self.view.center;
    [self.view addSubview:noDataView];
}
- (void)showRequestFailedViewWithImg:(NSString *)img tips:(NSString *)tips btnTitle:(NSString *)btnTitle btnClicked:(void(^)(void))btnClicked{
    [TYWJCommonTool loadNoDataViewWithImg:img tips:tips btnTitle:btnTitle isHideBtn:NO showingVc:self btnClicked:^(UIViewController *failedVc) {
        btnClicked();
        [failedVc.view removeFromSuperview];
        [failedVc removeFromParentViewController];
    }];
}
@end
