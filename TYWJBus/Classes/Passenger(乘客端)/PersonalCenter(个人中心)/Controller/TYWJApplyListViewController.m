//
//  TYWJApplyListViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/3/11.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJApplyListViewController.h"
#import "TYWJApplyDetailRouteController.h"
#import "TYWJUnmatchViewController.h"

#import "TYWJApplyListCell.h"

#import <MJRefresh.h>
//#import "JXNewsModel.h"
#import <MJExtension.h>

#import "ZLRefreshGifHeader.h"
#import "TYWJLoginTool.h"
#import "TYWJSoapTool.h"
#import "TYWJApplyList.h"
#import "TYWJRouteList.h"

@interface TYWJApplyListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataArray;
@property(nonatomic,weak) UITableView *tableView;
@end

@implementation TYWJApplyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = ZLColorWithRGB(236, 236, 236);
    [self initNav];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)initNav
{
    self.navigationItem.title = @"我的申请";
}

- (void)initTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth, ZLScreenHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    ZLRefreshGifHeader *mjHeader = [ZLRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    tableView.mj_header = mjHeader;
    self.tableView = tableView;
    self.tableView.backgroundColor = ZLColorWithRGB(236, 236, 236);
    
}

- (void)loadData
{
    [self.tableView.mj_footer endRefreshing];
    self.tableView.mj_footer.hidden = YES;
    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:self.view];
    WeakSelf;
    NSString *bodyStr = [NSString stringWithFormat:
                         @"<%@ xmlns=\"%@\">\
                         <yhm>%@</yhm>\
                         </%@>",TYWJRequestCheckoutAppliedRoute,TYWJRequestService,[TYWJLoginTool sharedInstance].phoneNum,TYWJRequestCheckoutAppliedRoute];
    [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:bodyStr success:^(id responseObject) {
        [weakSelf.tableView.mj_header endRefreshing];
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        id data = responseObject[0][@"NS1:xianlushenqingResponse"][@"xianlushenqingList"][@"xianlushenqing"];
        if ([data isKindOfClass: [NSArray class]]) {
            NSArray *dataArr = [TYWJApplyList mj_objectArrayWithKeyValuesArray:data];
            if (dataArr.count) {
                weakSelf.dataArray = dataArr;
                [weakSelf.view addSubview:weakSelf.tableView];

                [weakSelf.tableView reloadData];
            }
        }else if ([data isKindOfClass: [NSDictionary class]]) {
            TYWJApplyList *dataModel = [TYWJApplyList mj_objectWithKeyValues:data];
            weakSelf.dataArray = @[dataModel];
            [weakSelf.view addSubview:weakSelf.tableView];
            [weakSelf.tableView reloadData];
        }
        
        if (!weakSelf.dataArray.count) {
            [weakSelf showRequestFailedViewWithImg:@"icon_no_line" tips:nil btnTitle:nil];
        }
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork];
        if (error) {
            
            [weakSelf showRequestFailedViewWithImg:@"icon_no_network" tips:@"网络差，请稍后再试" btnTitle:nil];
        }
    }];
}

#pragma mark - 显示no data view
- (void)showRequestFailedViewWithImg:(NSString *)img tips:(NSString *)tips btnTitle:(NSString *)btnTitle {
    WeakSelf;
    [TYWJCommonTool loadNoDataViewWithImg:img tips:tips btnTitle:btnTitle isHideBtn:NO showingVc:self btnClicked:^(UIViewController *failedVc) {
        [failedVc.view removeFromSuperview];
        [weakSelf loadData];
        [failedVc removeFromParentViewController];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYWJApplyListCell *cell = [TYWJApplyListCell cellForTableView:tableView];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    TYWJApplyList *model = self.dataArray[indexPath.row];
    cell.applyListInfo = model.applyListInfo;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYWJApplyList *model = self.dataArray[indexPath.row];
    if ([model.applyListInfo.kind isEqualToString:@"往返线路"]) {
        return 146;
    }
    return 116;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYWJApplyList *model = self.dataArray[indexPath.row];
    ZLLog(@"-----%@---%@---%@----%@",model.applyListInfo.sbid,model.applyListInfo.sbState,model.applyListInfo.xbid,model.applyListInfo.xbState);
    
    if ([model.applyListInfo.status isEqualToString:@"已匹配"] || [model.applyListInfo.status isEqualToString:@"待处理"]) {
        TYWJApplyDetailRouteController *detailRouteVc = [[TYWJApplyDetailRouteController alloc] init];
        detailRouteVc.isDetailRoute = YES;
        TYWJRouteListInfo *info = [[TYWJRouteListInfo alloc] init];
        info.routeNum = model.applyListInfo.routeNum;
        info.routeName = model.applyListInfo.routeName;
        info.startingStop = model.applyListInfo.startingStop;
        info.stopStop = model.applyListInfo.stopStop;
        info.oriPrice = model.applyListInfo.oriPrice;
        info.startingTime = model.applyListInfo.startingTime;
        info.stopTime = model.applyListInfo.stopTime;
        info.price = model.applyListInfo.price;
        info.isFullPrice = model.applyListInfo.isFullPrice;
        info.carLicenseNum = model.applyListInfo.carLicenseNum;
        info.carStatus = model.applyListInfo.carStatus;
        info.cityID = model.applyListInfo.cs;
        info.type = model.applyListInfo.type;
        info.startStopId = model.applyListInfo.startStopId;
        info.stopStopId = model.applyListInfo.stopStopId;
        detailRouteVc.routeListInfo = info;
        detailRouteVc.applyListInfo = model.applyListInfo;
        detailRouteVc.kind = model.applyListInfo.kind;
        detailRouteVc.ppid = model.applyListInfo.ppid;
        detailRouteVc.sbid = model.applyListInfo.sbid;
        detailRouteVc.sbState = model.applyListInfo.sbState;
        detailRouteVc.xbid = model.applyListInfo.xbid;
        detailRouteVc.xbState = model.applyListInfo.xbState;
        detailRouteVc.status = model.applyListInfo.status;
        [self.navigationController pushViewController:detailRouteVc animated:YES];
    }else {
        TYWJUnmatchViewController *vc = [[TYWJUnmatchViewController alloc] init];
        TYWJApplyList *model = self.dataArray[indexPath.row];
        vc.applyListInfo = model.applyListInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
