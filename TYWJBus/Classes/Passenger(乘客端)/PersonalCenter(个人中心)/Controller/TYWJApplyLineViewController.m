//
//  TYWJApplyLineViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/3/10.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJApplyLineViewController.h"
#import "TYWJChooseStationController.h"
#import "TYWJMyApplyController.h"
#import "TYWJApplyLineCell.h"
#import "ZLPopoverView.h"


#import <UIImage+GIF.h>
@interface TYWJApplyLineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) TYWJApplyLineCell *applyLineCell;
@end

@implementation TYWJApplyLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNav];
    [self initTableView];
}

- (void)initNav
{
    self.navigationItem.title = @"线路申请";
    
    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [button setTitle:@"我的申请" forState:UIControlStateNormal];
    //    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    button.zl_size = CGSizeMake(80, 30);
    //    button.titleLabel.font = [UIFont systemFontOfSize:15];
    //    [button addTarget:self action:@selector(myApplyClicked) forControlEvents:UIControlEventTouchUpInside];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)myApplyClicked
{
    TYWJMyApplyController *vc = [[TYWJMyApplyController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)initTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth, ZLScreenHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYWJApplyLineCell *cell = [TYWJApplyLineCell cellForTableView:tableView];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    self.applyLineCell = cell;
    cell.upBtnClicked = ^ {
        WeakSelf;
        TYWJChooseStationController *vc = [[TYWJChooseStationController alloc] init];
        vc.isGetupStation = YES;
        vc.isDefaultSearch = YES;
        vc.stationPoi = ^(AMapPOI *poi) {
            weakSelf.applyLineCell.startField.text = poi.name;
            weakSelf.applyLineCell.upLat = poi.location.latitude;
            weakSelf.applyLineCell.upLong = poi.location.longitude;
        };
        [self.navigationController pushViewController:vc animated:YES];
    };
    cell.downBtnClicked = ^{
        WeakSelf;
        TYWJChooseStationController *vc = [[TYWJChooseStationController alloc] init];
        vc.isGetupStation = NO;
        vc.isDefaultSearch = YES;
        vc.stationPoi = ^(AMapPOI *poi) {
            weakSelf.applyLineCell.endField.text = poi.name;
            weakSelf.applyLineCell.downLat = poi.location.latitude;
            weakSelf.applyLineCell.downLong = poi.location.longitude;
        };
        [self.navigationController pushViewController:vc animated:YES];
    };
    cell.upTimeBtnClicked = ^{
        WeakSelf;
        NSInteger selectedTime = 9;
        [[ZLPopoverView sharedInstance] showPopSelecteTimeViewWithSelectedTime:selectedTime ConfirmClicked:^(NSString *time) {
            weakSelf.applyLineCell.startTimeField.text = time;
        }];
    };
    cell.downTimeBtnClicked = ^{
        WeakSelf;
        NSInteger selectedTime = 18;
        [[ZLPopoverView sharedInstance] showPopSelecteTimeViewWithSelectedTime:selectedTime ConfirmClicked:^(NSString *time) {
            weakSelf.applyLineCell.endTimeField.text = time;
        }];
    };
    cell.applyBtnClicked = ^(NSString * _Nonnull upStaion, NSString * _Nonnull downStaion, NSString * _Nonnull num, NSString * _Nonnull kind, NSString * _Nonnull upTime, NSString * _Nonnull downTime, NSString * _Nonnull phone) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD hideAllHUDsForView:CURRENTVIEW animated:YES];
        });
        [MBProgressHUD zl_showSuccess:@"线路申请成功"];
        return;
        WeakSelf;
        NSString *bodyStr = [NSString stringWithFormat:
                             @"<%@ xmlns=\"%@\">\
                             <yhm>%@</yhm>\
                             <jtzz>%@</jtzz>\
                             <gsdz>%@</gsdz>\
                             <sbsj>%@</sbsj>\
                             <xbsj>%@</xbsj>\
                             <cs>%@</cs>\
                             <qjingdu>%@</qjingdu>\
                             <qweidu>%@</qweidu>\
                             <zjingdu>%@</zjingdu>\
                             <zweidu>%@</zweidu>\
                             <kind>%@</kind>\
                             <renshu>%@</renshu>\ </%@>",TYWJRequestApplyForNewRoute,TYWJRequestService,phone,upStaion,downStaion,upTime,downTime,[TYWJCommonTool sharedTool].selectedCity.city_code,@(weakSelf.applyLineCell.upLong),@(weakSelf.applyLineCell.upLat),@(weakSelf.applyLineCell.downLong),@(weakSelf.applyLineCell.downLat),kind,num,TYWJRequestApplyForNewRoute];
        //        ZLLog(@"-------%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",phone,upStaion,downStaion,upTime,downTime,[TYWJCommonTool sharedTool].selectedCity.cityID,@(weakSelf.applyLineCell.upLong),@(weakSelf.applyLineCell.upLat),@(weakSelf.applyLineCell.downLong),@(weakSelf.applyLineCell.downLat),kind)
        //        [TYWJSoapTool SOAPDataWithSoapBody:bodyStr success:^(id responseObject) {
        //            if ([responseObject[0][@"NS1:xianlushenqinginsertResponse"] isEqualToString:@"ok"]) {
        ////                UINavigationController *nav = self.navigationController;
        ////                [nav popToRootViewControllerAnimated:NO];
        //                
        ////                TYWJRouteAppliedSuccessfullyController *vc = [[TYWJRouteAppliedSuccessfullyController alloc] init];
        ////                vc.dataList = self.dataList;
        ////                [nav pushViewController:vc animated:YES];
        //                TYWJApplyListViewController *vc = [[TYWJApplyListViewController alloc] init];
        //                [self.navigationController pushViewController:vc animated:YES];
        //
        //                [MBProgressHUD zl_showSuccess:@"提交成功"];
        //                
        //                
        //            }else {
        //                [MBProgressHUD zl_showError:TYWJWarningBadNetwork];
        //            }
        //        } failure:^(NSError *error) {
        //            
        //        }];
    };
    cell.shareBtnClicked = ^{
    };
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 700;
}
@end
