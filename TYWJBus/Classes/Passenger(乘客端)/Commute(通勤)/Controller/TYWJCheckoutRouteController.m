//
//  TYWJCheckoutRouteController.m
//  TYWJBus
//
//  Created by Harllan He on 2018/5/30.
//  Copyright © 2018 Harllan He. All rights reserved.
//

#import "TYWJCheckoutRouteController.h"
#import "TYWJCheckoutNoRoute.h"
#import "TYWJApplyRouteController.h"
#import "TYWJApplyLineViewController.h"

#import <AMapSearchKit/AMapSearchKit.h>

@interface TYWJCheckoutRouteController ()

@end

@implementation TYWJCheckoutRouteController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)dealloc {
    ZLFuncLog;
}

- (void)setupView {
    self.navigationItem.title = @"线路查询结果";
    
    WeakSelf;
    TYWJCheckoutNoRoute *noRouteView = [[[NSBundle mainBundle] loadNibNamed:@"TYWJCheckoutNoRoute" owner:nil options:nil] lastObject];
    noRouteView.frame = self.view.bounds;
    [noRouteView setGetupText:self.getupPoi.name];
    [noRouteView setGetdownText:self.getdownPoi.name];
    noRouteView.btnClicked = ^{
//        TYWJApplyRouteController *vc = [[TYWJApplyRouteController alloc] init];
//        vc.getupPoi = weakSelf.getupPoi;
//        vc.getdownPoi = weakSelf.getdownPoi;
//        [weakSelf.navigationController pushViewController:vc animated:YES];
        
        TYWJApplyLineViewController *applyVC = [[TYWJApplyLineViewController alloc] init];
        [self.navigationController pushViewController:applyVC animated:YES];
    };
    [self.view addSubview:noRouteView];
    
}

@end
