//
//  TYWJDriveHomeDetailViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/6/11.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJDriveHomeDetailViewController.h"
#import "TYWJDriverHomeTableViewController.h"
#import "YJPageControlView.h"
#import "TYWJDriverPassengerListController.h"
#import "TYWJDriveDetailRouteController.h"
#import "TYWJRouteList.h"
@interface TYWJDriveHomeDetailViewController ()

@end

@implementation TYWJDriveHomeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"班次详情";
    //    // Do any additional setup after loading the view from its nib.
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadData{
    WeakSelf;
    NSDictionary *param = @{
        @"line_code":self.model.line_code,
        @"line_date":self.model.line_date,
        @"line_time":self.model.line_time,
        @"driver_code":[ZLUserDefaults objectForKey:TYWJLoginUidString],
    };
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.191:9005/ticket/inspect/driver/search" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        NSMutableArray *viewControllers = [NSMutableArray array];
        NSArray *titles = @[@"乘客信息", @"行驶路线"];
        CGRect frame =CGRectMake(0, kNavBarH, ZLScreenWidth, ZLScreenHeight -kNavBarH);
        for (int i = 0 ; i<titles.count; i++) {
            if (i == 0 ) {
                TYWJDriverPassengerListController *vc = [[TYWJDriverPassengerListController alloc] init];
                vc.dataDic = dataDic;
                [viewControllers addObject:vc];
            } else{
                TYWJDriveDetailRouteController *detailRouteVc = [[TYWJDriveDetailRouteController alloc] init];
                detailRouteVc.isDetailRoute = YES;
                TYWJRouteListInfo *info = [[TYWJRouteListInfo alloc] init];
                info.line_info_id = self.model.line_code;
                detailRouteVc.routeListInfo = info;
                [viewControllers addObject:detailRouteVc];
            }
        }
        YJPageControlView *PageControlView = [[YJPageControlView alloc] initWithFrame:frame Titles:titles viewControllers:viewControllers Selectindex:0];
        PageControlView.tintColor = [UIColor greenColor];
        [PageControlView showInViewController:self];
    } WithFailurBlock:^(NSError *error) {
        [weakSelf showRequestFailedViewWithImg:@"icon_no_network" tips:TYWJWarningBadNetwork btnTitle:nil btnClicked:^{
            [self loadData];
        }];
    }];
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
