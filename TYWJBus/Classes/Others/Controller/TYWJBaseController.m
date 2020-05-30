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
    TYWJNoDataView *noDataView= [[[NSBundle mainBundle] loadNibNamed:@"TYWJNoDataView" owner:self options:nil] lastObject];
    noDataView.dataDic = dic;
    [self.view addSubview:noDataView];
}
@end
