//
//  TYWJMyOrderViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/6/15.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJMyOrderViewController.h"
#import "YJPageControlView.h"
#import "TYWJMyOrderTableController.h"
@interface TYWJMyOrderViewController ()

@end

@implementation TYWJMyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    // Do any additional setup after loading the view.
    NSMutableArray *viewControllers = [NSMutableArray array];
    NSArray *titles = @[@"全部", @"待付款", @"已付款", @"已取消"];
    CGRect frame =CGRectMake(0, kNavBarH, ZLScreenWidth, ZLScreenHeight - kTabBarH -kNavBarH);
    for (int i = 0 ; i<titles.count; i++) {
        TYWJMyOrderTableController *vc = [[TYWJMyOrderTableController alloc] init];
        vc.type = i;
        [viewControllers addObject:vc];
    }
    YJPageControlView *PageControlView = [[YJPageControlView alloc] initWithFrame:frame Titles:titles viewControllers:viewControllers Selectindex:0];
    [PageControlView showInViewController:self];
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
