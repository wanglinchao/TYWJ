//
//  TYWJDriverMessageController.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/30.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJDriverMessageController.h"
#import "TYWJTripsRecordController.h"
#import "TYWJJsonRequestUrls.h"
#import "ZLHTTPSessionManager.h"
#import "TYWJLoginTool.h"
#import "TYWJTripsModel.h"
#import "ZLShiftView.h"
#import "SURefreshHeader.h"
#import "TYWJDriverSignUpHomeCell.h"
#import "TYWJDriverMapController.h"
#import "TYWJSingleLocation.h"
#import "ZLPopoverView.h"
#import "TYWJBorderButton.h"
#import "TYWJDriverPerformanceController.h"
#import <WRNavigationBar.h>
#import <MJExtension.h>


static CGFloat const kShiftViewH = 40.f;
static CGFloat const kCellH = 120.f;

@interface TYWJDriverMessageController ()<UITableViewDelegate,UITableViewDataSource>

/* trips */
@property (strong, nonatomic) NSMutableArray *trips;
/* 有效的trips */
@property (strong, nonatomic) NSMutableArray *usefulTrips;
/* 失效trips */
@property (strong, nonatomic) NSMutableArray *unusefulTrips;
/* shiftView */
@property (strong, nonatomic) ZLShiftView *shiftView;
/* tipsLabel */
@property (strong, nonatomic) UILabel *tipsLabel;
/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* 是否选中的是o有效trips */
@property (assign, nonatomic) BOOL isUsefuleTrips;
/* 是否出发打卡成功 */
@property (assign, nonatomic) BOOL isLaunchSuccess;
/* firstTrip */
@property (strong, nonatomic) TYWJTripsModel *firstTrip;
/* 最新定位的位置 */
@property (strong, nonatomic) CLLocation *latestLocation;

@end

@implementation TYWJDriverMessageController

#pragma mark - 懒加载

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kShiftViewH + kNavBarH, ZLScreenWidth, kShiftViewH)];
        _tipsLabel.backgroundColor = ZLColorWithRGB(112, 116, 122);
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = [UIFont systemFontOfSize:16.f];
        _tipsLabel.text = @"不在打卡范围内";
    }
    return _tipsLabel;
}

- (ZLShiftView *)shiftView {
    if (!_shiftView) {
        _shiftView = [ZLShiftView shiftViewWithFrame:CGRectMake(0, kNavBarH, ZLScreenWidth, kShiftViewH)];
        [_shiftView setLeftTitle:@"待完成" rightTitle:@"已完成"];
        WeakSelf;
        _shiftView.leftBClicked = ^{
            weakSelf.isUsefuleTrips = YES;
            [weakSelf.tableView reloadData];
        };
        _shiftView.rightBClicked = ^{
            weakSelf.isUsefuleTrips = NO;
            [weakSelf.tableView reloadData];
        };
    }
    return _shiftView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat y = kNavBarH + kShiftViewH;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y,  ZLScreenWidth, self.view.zl_height - y) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = ZLGlobalBgColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = kCellH;
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJDriverSignUpHomeCell class]) bundle:nil] forCellReuseIdentifier:TYWJDriverSignUpHomeCellID];
        
        WeakSelf;
        [_tableView addRefreshHeaderWithHandle:^{
            ZLLog(@"刷新数据");
            [weakSelf requestTrips];
        }];
    }
    return _tableView;
}
#pragma mark - setupView
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startUpdatingLocation];
    // Do any additional setup after loading the view.
    if ([TYWJLoginTool sharedInstance].driverInfo) {
       [self setupView];
    }else {
        self.navigationItem.title = @"打卡";
        [TYWJCommonTool loadNoDataViewWithImg:@"icon_no_ticket" tips:@"您今天暂无班次" btnTitle:nil isHideBtn:YES showingVc:self];
    }
    
//#ifdef DEBUG
    
//#endif
    
}

- (void)setupView {
    [self wr_setNavBarShadowImageHidden:YES];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [dateFormatter stringFromDate: [NSDate date]];
    self.navigationItem.title = dateStr;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看绩效" style:UIBarButtonItemStylePlain target:self action:@selector(performanceClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"明日班次" style:UIBarButtonItemStylePlain target:self action:@selector(nextDueClicked)];
    
    
    [self setupSubviews];
    
    //请求数据
    self.usefulTrips = [NSMutableArray array];
    self.unusefulTrips = [NSMutableArray array];
    self.isUsefuleTrips = YES;
    [self requestTrips];
}

- (void)setupSubviews {
    [self.view addSubview:self.shiftView];
//    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.tableView];
}

- (void)startUpdatingLocation {
    //开启持续定位
    [[TYWJSingleLocation stantardLocation] startUpdatingLocation];
    WeakSelf;
    [TYWJSingleLocation stantardLocation].updatingLocationCallback = ^(CLLocation *location, AMapLocationReGeocode *reGeocode) {
        //持续定位回调
        weakSelf.latestLocation = location;
    };
}

- (void)setLatestLocation:(CLLocation *)latestLocation {
    _latestLocation = latestLocation;
    if (self.isLaunchSuccess) {
        [self requestUploadLocation];
    }
}

#pragma mark - 数据请求

- (void)requestUploadLocation {
    WeakSelf;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"position"] = NSStringFromCGPoint(CGPointMake(self.latestLocation.coordinate.latitude, self.latestLocation.coordinate.longitude));
    params[@"requestFrom"] = @"iOS";
    ZLHTTPSessionManager *mgr = [ZLHTTPSessionManager manager];
    [mgr.requestSerializer setValue:[TYWJLoginTool sharedInstance].driverInfo.token forHTTPHeaderField:@"token"];
    [mgr GET:[TYWJJsonRequestUrls sharedRequest].uploadDriverGps parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf.tableView.header endRefreshing];
        if ([responseObject[@"errCode"] integerValue] == 0) {
            ZLLog(@"上传位置成功");
        }else {
            [MBProgressHUD zl_showError:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZLLog(@"上传位置失败---网络差");
    }];
}

- (void)requestTrips {
    WeakSelf;
    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:self.view];
    ZLHTTPSessionManager *mgr = [ZLHTTPSessionManager manager];
    [mgr.requestSerializer setValue:[TYWJLoginTool sharedInstance].driverInfo.token forHTTPHeaderField:@"token"];
    [mgr GET:[TYWJJsonRequestUrls sharedRequest].trips parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf.tableView.header endRefreshing];
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        if ([responseObject[@"errCode"] integerValue] == 0) {
            weakSelf.trips = [TYWJTripsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"trips"]];
            if (!weakSelf.trips.count) {
                [MBProgressHUD zl_showAlert:@"您今天暂无班次" afterDelay:3.0f];
            }
        }else {
            [MBProgressHUD zl_showError:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableView.header endRefreshing];
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:weakSelf.view];
        [weakSelf loadNoDataViewWithImg:@"icon_no_network" tips:@"网络怎么了?请稍后再试试吧" btnTitle:@"重新加载" isHideBtn:NO];
    }];
}
- (void)loadNoDataViewWithImg:(NSString *)img tips:(NSString *)tips btnTitle:(NSString *)btnTitle isHideBtn:(BOOL)isHideBtn {
    WeakSelf;
    [TYWJCommonTool loadNoDataViewWithImg:img tips:tips btnTitle:btnTitle isHideBtn:isHideBtn showingVc:self btnClicked:^(UIViewController *failedVc) {
        [failedVc.view removeFromSuperview];
        [weakSelf requestTrips];
        [failedVc removeFromParentViewController];
    }];
}

- (void)requestClockInWithTrip:(TYWJTripsModel *)trip cell:(TYWJDriverSignUpHomeCell *)cell mode:(NSInteger )mode {
    ZLFuncLog;
    [MBProgressHUD zl_showMessage:@"正在打卡..." toView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tripId"] = trip.ID;
    params[@"status"] = @(mode);
    params[@"mode"] = trip.departMode;
    params[@"requestFrom"] = @"iOS";
    params[@"lngLat"] = [NSString stringWithFormat:@"%.6f,%.6f",self.latestLocation.coordinate.longitude,self.latestLocation.coordinate.latitude];
    if (mode == 2) {
        params[@"signArriveId"] = trip.arriveStation.ID;
    }
    ZLHTTPSessionManager *mgr = [ZLHTTPSessionManager signManager];
    [mgr.requestSerializer setValue:[TYWJLoginTool sharedInstance].driverInfo.token forHTTPHeaderField:@"token"];
    WeakSelf;
    [mgr POST:[TYWJJsonRequestUrls sharedRequest].driverClockIn parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        if ([responseObject[@"errCode"] integerValue] == 0) {
            [MBProgressHUD zl_showSuccess:@"打卡成功"];
            [weakSelf requestTrips];
            //如果是出发打成，就上传位置
            weakSelf.isLaunchSuccess = (mode == 1);
        }else {
            [MBProgressHUD zl_showError:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:weakSelf.view];
    }];
}


#pragma mark - 设置数据模型
- (void)setTrips:(NSMutableArray *)trips {
    //对数组进行按时间排序
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    NSInteger count = trips.count;
    for (NSInteger i = 0; i < count; i++) {
        TYWJTripsModel *trip0 = trips[i];
        for (NSInteger j = i+1;j < count; j++) {
            TYWJTripsModel *trip1 = trips[j];
            NSTimeInterval time0 = [[formatter dateFromString:trip0.schedule] timeIntervalSince1970];
            NSTimeInterval time1 = [[formatter dateFromString:trip1.schedule] timeIntervalSince1970];
            if (time0 > time1) {
                TYWJTripsModel *tmpTrip = trip0;
                trips[i] = trips[j];
                trips[j] = tmpTrip;
                trip0 = trips[i];
            }
        }
    }
    _trips = trips;
    
    [self.usefulTrips removeAllObjects];
    [self.unusefulTrips removeAllObjects];
    
    
    for (TYWJTripsModel *trip in trips) {
        if (trip.status.integerValue <= 1) {
            [self.usefulTrips addObject:trip];
        }else {
            [self.unusefulTrips addObject:trip];
        }
    }
    if (self.usefulTrips.count) {
        self.firstTrip = self.usefulTrips.firstObject;
    }
    [self setupSubviews];
    [self.tableView reloadData];
}

#pragma mark - 按钮点击

/**
 绩效点击
 */
- (void)performanceClicked {
    ZLFuncLog;
    TYWJDriverPerformanceController *pVc = [[TYWJDriverPerformanceController alloc] init];
    [self.navigationController pushViewController:pVc animated:YES];
}


/**
 明日班次点击
 */
- (void)nextDueClicked {
    ZLFuncLog;
    TYWJTripsRecordController *trVc = [[TYWJTripsRecordController alloc] init];
    [self.navigationController pushViewController:trVc animated:YES];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isUsefuleTrips) {
        return self.usefulTrips.count;
    }else {
        return self.unusefulTrips.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJDriverSignUpHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJDriverSignUpHomeCellID forIndexPath:indexPath];
    if (self.isUsefuleTrips) {
        TYWJTripsModel *trip = self.usefulTrips[indexPath.row];
        cell.trip = trip;
    }else {
        TYWJTripsModel *trip = self.unusefulTrips[indexPath.row];
        cell.trip = trip;
    }
    
    
    WeakSelf;
    __weak typeof(cell) weakCell = cell;
    
    cell.mSignInClicked = ^(TYWJTripsModel * _Nonnull trip) {
        if (trip.roll.boolValue) {
            //滚动打卡
            [weakSelf rollSignInWithCell:weakCell trip:trip];
            return;
        }
        //非滚动打卡
        [weakSelf normalSignInWithCell:weakCell trip:trip];
    };
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZLFuncLog;
    TYWJDriverMapController *dmVc = [[TYWJDriverMapController alloc] init];
    if (self.isUsefuleTrips) {
        TYWJTripsModel *trip = self.usefulTrips[indexPath.row];
        dmVc.trip = trip;
    }else {
        TYWJTripsModel *trip = self.unusefulTrips[indexPath.row];
        dmVc.trip = trip;
    }
    
    [self.navigationController pushViewController:dmVc animated:YES];
}

#pragma mark - 手动打卡相关

- (void)rollSignInWithCell:(TYWJDriverSignUpHomeCell *)cell trip:(TYWJTripsModel *)trip {
    if ([[cell.signInBtn titleForState:UIControlStateNormal] isEqualToString:@"到达打卡"]) {
        //到达打卡
        CLLocationCoordinate2D arriveCoord = CLLocationCoordinate2DMake(trip.arriveStation.latitude.doubleValue, trip.arriveStation.longitude.doubleValue);
        if (![[TYWJCommonTool sharedTool] checkPlaceIsAssignedPlaceWithCoord:arriveCoord coord2:self.latestLocation.coordinate meters:25]) {
            [[ZLPopoverView sharedInstance] showTipsViewWithTips:@"当前还未到打卡范围,是否继续打卡?" leftTitle:@"算了" rightTitle:@"打卡" RegisterClicked:^{
                [self requestClockInWithTrip:trip cell:cell mode:2];
            }];
            return;
        }
        [self requestClockInWithTrip:trip cell:cell mode:2];
        
        return;
    }
    //出发打卡
    if (!self.latestLocation) {
        [MBProgressHUD zl_showAlert:@"还未定位到当前位置" toView:self.view afterDelay:2.5f];
        return;
    }
    
    CLLocationCoordinate2D departureCoord = CLLocationCoordinate2DMake(trip.departStation.latitude.doubleValue, trip.departStation.longitude.doubleValue);
    if (![[TYWJCommonTool sharedTool] checkPlaceIsAssignedPlaceWithCoord:departureCoord coord2:self.latestLocation.coordinate meters:50]) {
        [[ZLPopoverView sharedInstance] showTipsViewWithTips:@"当前还未到打卡范围,是否继续打卡?" leftTitle:@"算了" rightTitle:@"打卡" RegisterClicked:^{
            [self requestClockInWithTrip:trip cell:cell mode:1];
        }];
        return;
    }
    
    [self requestClockInWithTrip:trip cell:cell mode:1];
}

/**
 正常打卡
 */
- (void)normalSignInWithCell:(TYWJDriverSignUpHomeCell *)cell trip:(TYWJTripsModel *)trip {
    if ([[cell.signInBtn titleForState:UIControlStateNormal] isEqualToString:@"到达打卡"]) {
        //到达打卡
        CLLocationCoordinate2D arriveCoord = CLLocationCoordinate2DMake(trip.arriveStation.latitude.doubleValue, trip.arriveStation.longitude.doubleValue);
        if (![[TYWJCommonTool sharedTool] checkPlaceIsAssignedPlaceWithCoord:arriveCoord coord2:self.latestLocation.coordinate meters:25]) {
            [[ZLPopoverView sharedInstance] showTipsViewWithTips:@"当前还未到打卡范围,是否继续打卡?" leftTitle:@"算了" rightTitle:@"打卡" RegisterClicked:^{
                [self requestClockInWithTrip:trip cell:cell mode:2];
            }];
            return;
        }
        [self requestClockInWithTrip:trip cell:cell mode:2];
        
        return;
    }
    //出发打卡
    if (!self.latestLocation) {
        [MBProgressHUD zl_showAlert:@"还未定位到当前位置" toView:self.view afterDelay:2.5f];
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    NSTimeInterval nowTime = [[formatter dateFromString:[formatter stringFromDate:[NSDate date]]] timeIntervalSince1970];
    NSTimeInterval tripTime = [[formatter dateFromString:trip.schedule] timeIntervalSince1970];
    if (tripTime - nowTime > 15*60) {
        //            [[ZLPopoverView sharedInstance] showTipsViewWithTips:@"离出发时间大于十分钟,是否继续打卡?" leftTitle:@"算了" rightTitle:@"打卡" RegisterClicked:^{
        //                [weakSelf requestClockInWithTrip:trip cell:weakCell mode:1];
        //            }];
        [MBProgressHUD zl_showAlert:@"还未到出发打卡时间!" afterDelay:2.f];
        return;
    }
    
    CLLocationCoordinate2D departureCoord = CLLocationCoordinate2DMake(trip.departStation.latitude.doubleValue, trip.departStation.longitude.doubleValue);
    if (![[TYWJCommonTool sharedTool] checkPlaceIsAssignedPlaceWithCoord:departureCoord coord2:self.latestLocation.coordinate meters:50]) {
        [[ZLPopoverView sharedInstance] showTipsViewWithTips:@"当前还未到打卡范围,是否继续打卡?" leftTitle:@"算了" rightTitle:@"打卡" RegisterClicked:^{
            [self requestClockInWithTrip:trip cell:cell mode:1];
        }];
        return;
    }
    
    
    if (nowTime - tripTime > 15*60) {
        [[ZLPopoverView sharedInstance] showTipsViewWithTips:@"超过出发时间大于十分钟,是否继续打卡?" leftTitle:@"算了" rightTitle:@"打卡" RegisterClicked:^{
            [self requestClockInWithTrip:trip cell:cell mode:1];
        }];
        return;
    }
    
    [self requestClockInWithTrip:trip cell:cell mode:1];
}

@end
