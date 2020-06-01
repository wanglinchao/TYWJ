//
//  TYWJSchedulingDetialViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/5/29.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJSchedulingDetialViewController.h"
#import "TYWJSchedulingDetialView.h"
#import "TYWJBottomBtnView.h"
#import "TYWJSchedulingDetailStateView.h"
#import "TYWJDetailRouteController.h"
@interface TYWJSchedulingDetialViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) TYWJSchedulingDetialView *contentView;

@end

@implementation TYWJSchedulingDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [self loadData];
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadData {
    
}
- (void)setupView {
    self.contentView = [[[NSBundle mainBundle] loadNibNamed:@"TYWJSchedulingDetialView" owner:self options:nil] lastObject];
    NSInteger stateValue = 0;
    WeakSelf;
    self.contentView.buttonSeleted = ^(NSInteger index) {
        TYWJDetailRouteController *detailRouteVc = [[TYWJDetailRouteController alloc] init];
        detailRouteVc.stateValue = stateValue;
        detailRouteVc.isDetailRoute = NO;
        [weakSelf.navigationController pushViewController:detailRouteVc animated:YES];
    };
    self.scrollView.contentSize = CGSizeMake(ZLScreenWidth, self.contentView.frame.size.height + 10);
    self.contentView.stateValue = stateValue;
    self.contentView.zl_width = ZLScreenWidth;
    [self.scrollView addSubview:self.contentView];
}

@end
