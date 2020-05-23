//
//  TYWJTripsRecordController.m
//  TYWJBus
//
//  Created by MacBook on 2018/12/24.
//  Copyright © 2018 MacBook. All rights reserved.
//  行车记录

#import "TYWJTripsRecordController.h"
#import "TYWJJsonRequestUrls.h"
#import "ZLHTTPSessionManager.h"
#import "TYWJLoginTool.h"
#import "TYWJDriverSignUpCheckRouteCell.h"
#import "TYWJDriverMapController.h"
#import <MJExtension.h>
#import "TYWJTripsModel.h"
#import "TYWJDriverSignUpTitleView.h"


static CGFloat const kRowH = 100.f;

@interface TYWJTripsRecordController ()<UITableViewDelegate,UITableViewDataSource>

/* titleView */
@property (strong, nonatomic) TYWJDriverSignUpTitleView *titleView;
/* dataArr */
@property (strong, nonatomic) NSMutableArray *dataArr;
/* tableView */
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TYWJTripsRecordController
#pragma mark - lazy loading

- (TYWJDriverSignUpTitleView *)titleView {
    if (!_titleView) {
        _titleView = [TYWJDriverSignUpTitleView titleViewWithSize:CGSizeMake(200.f, 44.f)];
        [_titleView setTitle:@"班次查看"];
//        [_titleView setDateTitle:@"2018-12-25"];
        
        NSString *dateString = [[TYWJCommonTool sharedTool] getTomorrowDay: [NSDate date]];
        [_titleView setDateTitle:dateString];
        [self requestRouteDateWithDate:dateString];
        WeakSelf;
        _titleView.dateUpdated = ^(NSString * _Nonnull selectedDate) {
            //日期更新
            for (UIView *subView in weakSelf.view.subviews) {
                [subView removeFromSuperview];
            }
            [weakSelf requestRouteDateWithDate:selectedDate];
        };
    }
    return _titleView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.rowHeight = kRowH;
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.backgroundColor = ZLGlobalBgColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"TYWJDriverSignUpCheckRouteCell" bundle:nil] forCellReuseIdentifier:TYWJDriverSignUpCheckRouteCellID];
    }
    return _tableView;
}

#pragma mark - set up view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}


- (void)setupView {
    self.view.backgroundColor = ZLGlobalBgColor;
    self.navigationItem.titleView = self.titleView;
    
//    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:self.view];
}

#pragma mark - 数据请求

- (void)requestRouteDateWithDate:(NSString *)date {
    WeakSelf;
    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:self.view];
    ZLHTTPSessionManager *mgr = [ZLHTTPSessionManager manager];
    [mgr.requestSerializer setValue:[TYWJLoginTool sharedInstance].driverInfo.token forHTTPHeaderField:@"token"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"searchDate"] = date;
    params[@"requestFrom"] = @"iOS";
    [mgr GET:[TYWJJsonRequestUrls sharedRequest].userTrips parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        ZLLog(@"%@",responseObject);
        if ([responseObject[@"errCode"] integerValue] == 0) {
            weakSelf.dataArr = [TYWJTripsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (weakSelf.dataArr.count == 0) {
                [TYWJCommonTool loadNoDataViewWithImg:@"icon_no_ticket" tips:@"当日暂无数据" btnTitle:nil isHideBtn:YES showingVc:weakSelf];
            }else {
                [weakSelf.view addSubview:weakSelf.tableView];
                [weakSelf.tableView reloadData];
            }
            
        }else {
            [MBProgressHUD zl_showMessage:responseObject[@"msg"] toView:weakSelf.view];
            [TYWJCommonTool loadNoDataViewWithImg:@"icon_no_ticket" tips:@"当日无数据" btnTitle:nil isHideBtn:YES showingVc:weakSelf];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [TYWJCommonTool loadNoDataViewWithImg:@"icon_no_network" tips:@"网络怎么了?请稍后再试试吧" btnTitle:@"重新加载" isHideBtn:NO showingVc:weakSelf btnClicked:^(UIViewController *failedVc) {
            [weakSelf requestRouteDateWithDate:date];
        }];
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:weakSelf.view];
//        if (error) {
//
//        }
    }];
    
}


- (void)setDataArr:(NSMutableArray *)dataArr {
    if (dataArr.count) {
        //对数据进行出发时间的先后排序
        NSInteger count = dataArr.count;
        for (NSInteger i = 0; i < count; i++) {
            TYWJTripsModel *trip0 = dataArr[i];
            for (NSInteger j = i+1; j < count; j++) {
                TYWJTripsModel *trip1 = dataArr[j];
                if (trip0.departTime.integerValue >= trip1.departTime.integerValue) {
                    TYWJTripsModel *tmpTrip = trip0;
                    dataArr[i] = trip1;
                    dataArr[j] = tmpTrip;
                    trip0 = trip1;
                }
            }
        }
    }
    _dataArr = dataArr;
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJDriverSignUpCheckRouteCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJDriverSignUpCheckRouteCellID forIndexPath:indexPath];
    cell.trips = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZLFuncLog;
    TYWJDriverMapController *dmVc = [[TYWJDriverMapController alloc] init];
    TYWJTripsModel *trip = self.dataArr[indexPath.row];
    dmVc.trip = trip;
    dmVc.isCheckRoute = YES;
    [self.navigationController pushViewController:dmVc animated:YES];
}
@end
