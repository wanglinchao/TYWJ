//
//  TYWJDriverHomeController.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/30.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJDriverHomeController.h"
#import "TYWJDriverHomeCell.h"
#import "TYWJLaunchedController.h"
#import "TYWJSoapTool.h"
#import "TYWJLoginTool.h"
#import "TYWJDriverRouteList.h"
#import "TYWJDetailRouteController.h"
#import "ZLPopoverView.h"
#import "SURefreshHeader.h"

#import <MJExtension.h>
#import <WRNavigationBar.h>

static CGFloat const kRowH = 120.f;

@interface TYWJDriverHomeController()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* dataLists */
@property (strong, nonatomic) NSArray *dataLists;

@end

@implementation TYWJDriverHomeController
#pragma mark - lazy loading

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = kRowH;
        _tableView.backgroundColor = [UIColor whiteColor];
        WeakSelf;
        [_tableView addRefreshHeaderWithHandle:^{
            [weakSelf loadRouteData];
        }];
//        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJDriverHomeCell class]) bundle:nil] forCellReuseIdentifier:TYWJDriverHomeCellID];
        
    }
    return _tableView;
}


#pragma mark - set up view

- (void)dealloc {
    [ZLNotiCenter removeObserver:self name:TYWJCloseRouteNoti object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [ZLNotiCenter addObserver:self selector:@selector(closeRouteNoti) name:TYWJCloseRouteNoti object:nil];
    [self setupView];
    [self loadRouteData];
}

- (void)setupView {
    self.navigationItem.title = @"通勤";
    self.navigationController.navigationBar.backgroundColor = UIColor.whiteColor;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self wr_setNavBarBackgroundAlpha:1.f];
    
    if ([[TYWJLoginTool sharedInstance].phoneNum isEqualToString:TYWJTestPhoneNum]) {
        return;
    }
    WeakSelf;
    if (![TYWJLoginTool sharedInstance].driverLoginPwd) {
        [[ZLPopoverView sharedInstance] showSingleBtnViewWithTips:@"为保障您的账号安全,请重新登录" confirmClicked:^{
            [TYWJCommonTool signOutUserWithView:weakSelf.navigationController.view];
        }];
        return;
    }
    
}

#pragma mark - 加载数据
- (void)loadRouteData {
    WeakSelf;
    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:self.view];
    NSString *bodyStr = [NSString stringWithFormat:
                         @"<%@ xmlns=\"%@\">\
                         <sjsjh>%@</sjsjh>\
                         </%@>",TYWJRequestGetDriverRoute,TYWJRequestService,[TYWJLoginTool sharedInstance].phoneNum,TYWJRequestGetDriverRoute];
    
    [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:bodyStr success:^(id responseObject) {
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        [weakSelf.tableView.header endRefreshing];
        id resData = responseObject[0][@"NS1:getsijixianluResponse"][@"sjxlList"][@"xlbh"];
        if ([resData isKindOfClass: [NSArray class]]) {
            weakSelf.dataLists = [TYWJDriverRouteList mj_objectArrayWithKeyValuesArray:resData];
            [weakSelf.view addSubview:weakSelf.tableView];
            [weakSelf.tableView reloadData];
        }else if([resData isKindOfClass: [NSDictionary class]]) {
            TYWJDriverRouteList *list = [TYWJDriverRouteList mj_objectWithKeyValues:resData];
            weakSelf.dataLists = @[list];
            [weakSelf.view addSubview:self.tableView];
            [weakSelf.tableView reloadData];
        }else {
            [weakSelf loadNoDataViewWithImg:@"icon_no_ticket" tips:@"您今天没有线路~~" btnTitle:nil isHideBtn:YES];
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.header endRefreshing];
//        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:weakSelf.view];
        [weakSelf loadNoDataViewWithImg:@"icon_no_ticket" tips:@"网络差,请稍后重试~~" btnTitle:nil isHideBtn:NO];
    }];
}

- (void)requestLaunchCarWithRouteListInfo:(TYWJDriverRouteListInfo *)listInfo {
    WeakSelf;
    [MBProgressHUD zl_showMessage:@"正在发车..." toView:self.view];
    NSString *bodyStr = [NSString stringWithFormat:
                         @"<%@ xmlns=\"%@\">\
                         <xlbh>%@</xlbh>\
                         </%@>",TYWJRequestDriverLuanchCar,TYWJRequestService,listInfo.routeNum,TYWJRequestDriverLuanchCar];
    [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:bodyStr success:^(id responseObject) {
        if ([responseObject[0][@"NS1:sijichufaResponse"] isEqualToString:@"ok"]) {
            [MBProgressHUD zl_hideHUDForView:self.view];
            TYWJLaunchedController *launchedVc = [[TYWJLaunchedController alloc] init];
            launchedVc.listInfo = listInfo;
            [weakSelf.navigationController pushViewController:launchedVc animated:YES];
        }else {
            [MBProgressHUD zl_showError:@"未找到线路" toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:self.view];
    }];
}


#pragma mark - 通知相关

- (void)closeRouteNoti {
    ZLFuncLog;
    [self loadRouteData];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJDriverHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJDriverHomeCellID forIndexPath:indexPath];
    TYWJDriverRouteList *list = self.dataLists[indexPath.row];
    cell.listInfo = list.listInfo;
    WeakSelf;
    cell.launchBtnClicked = ^{
#ifdef DEBUG
#else
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm";
        NSTimeInterval ticketTime = [[dateFormatter dateFromString:list.listInfo.startTime] timeIntervalSince1970];
        NSTimeInterval nowTime = [[dateFormatter dateFromString: [dateFormatter stringFromDate: [NSDate date]]] timeIntervalSince1970];
        if (ticketTime - nowTime > 10*60) {
            ZLLog(@"不到发车时间");
            //            NSString *time = [dateFormatter stringFromDate: [NSDate dateWithTimeIntervalSince1970:ticketTime - nowTime]];
            [MBProgressHUD zl_showError:@"未到发车时间" toView:self.view];
            return;
        }
#endif
        if ([list.listInfo.carStatus isEqualToString:@"空闲"]) {
            [weakSelf requestLaunchCarWithRouteListInfo:list.listInfo];
        }else {
            TYWJLaunchedController *launchedVc = [[TYWJLaunchedController alloc] init];
            launchedVc.listInfo = list.listInfo;
            [weakSelf.navigationController pushViewController:launchedVc animated:YES];
        }
        
        
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJDriverRouteList *list = self.dataLists[indexPath.row];
    TYWJDetailRouteController *detailVc = [[TYWJDetailRouteController alloc] init];
    detailVc.driverListInfo = list.listInfo;
    detailVc.isDetailRoute = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - 显示no data view
- (void)loadNoDataViewWithImg:(NSString *)img tips:(NSString *)tips btnTitle:(NSString *)btnTitle isHideBtn:(BOOL)isHideBtn {
    
    WeakSelf;
    [TYWJCommonTool loadNoDataViewWithImg:img tips:tips btnTitle:btnTitle isHideBtn:isHideBtn showingVc:self btnClicked:^(UIViewController *failedVc) {
        [failedVc.view removeFromSuperview];
        [weakSelf loadRouteData];
        [failedVc removeFromParentViewController];
    }];
}
@end
