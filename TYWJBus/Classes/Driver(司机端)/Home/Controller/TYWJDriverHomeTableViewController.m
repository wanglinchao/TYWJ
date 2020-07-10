//
//  TYWJTableViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/5/18.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJDriverHomeTableViewController.h"
#import "TYWJDriverHomeCell.h"
#import "ZLRefreshGifHeader.h"
#import "TYWJDriveHomeDetailViewController.h"
#import "TYWJDriveHomeList.h"
#import "MJRefreshBackStateFooter.h"
#import "TYWJSingleLocation.h"
@interface TYWJDriverHomeTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isRefresh;
    NSString *_time;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation TYWJDriverHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _time = @"";
    self.dataArr = [NSMutableArray array];
    self.title = self.dayStr?self.dayStr:[TYWJCommonTool getTodayDay];
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadData{
    WeakSelf;
    NSLog(@"%@",[ZLUserDefaults objectForKey:TYWJLoginUidString]);
    NSInteger page_size = 10;

    NSDictionary *param = @{
        @"driver_code":[ZLUserDefaults objectForKey:TYWJLoginUidString],
        @"status":self.status,
        @"line_date":self.dayStr?self.dayStr:[TYWJCommonTool getTodayDay],
        @"create_time":_isRefresh?@"":_time,
        @"page_size":@(page_size),
        @"page_type":@"1",
    };
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.191:9005/ticket/inspect/driver/store" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        NSArray *dataArr = [dic objectForKey:@"data"];
        if (self->_isRefresh) {
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.tableView.mj_header endRefreshing];
            if ([dataArr count] == 0) {
                self.tableView.hidden = YES;
                [self showNoDataViewWithDic:@{@"image":@"我的订单_空状态",@"title":@"这里空空如也"}];
            }
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        if ([dataArr count] < page_size) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if ([dataArr count] > 0) {
            NSString *time = [[dataArr lastObject] objectForKey:@"create_time"];
            self->_time = time;
            [self.dataArr addObjectsFromArray:[TYWJDriveHomeList mj_objectArrayWithKeyValuesArray:dataArr]];
        }
        [self.tableView reloadData];
        
        
        
        
        
        
        
        
//        NSArray *data = [dic objectForKey:@"data"];
//        if (data.count > 0) {
//            self.dataArr = [TYWJDriveHomeList mj_objectArrayWithKeyValuesArray:data];
//            [self.tableView reloadData];
//        }else {
//            [weakSelf showNoDataViewWithDic:@{}];
//        }

    } WithFailurBlock:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf showRequestFailedViewWithImg:@"icon_no_network" tips:TYWJWarningBadNetwork btnTitle:nil btnClicked:^{
            [self loadData];
        }];
    }];
}
- (void)startSign:(TYWJDriveHomeList *)model{
    TYWJSingleLocation *loc = [TYWJSingleLocation stantardLocation];
    [loc startBasicLocation];
    loc.locationDataDidChange = ^(AMapLocationReGeocode *reGeocode,CLLocation *location) {
        if (reGeocode) {
            
        }
        NSDictionary *param = @{
            @"uid":[ZLUserDefaults objectForKey:TYWJLoginUidString],
            @"loc":@[@(location.coordinate.latitude),@(location.coordinate.longitude)],
            @"line_code": model.line_code,
            @"name": @"",
            @"store_no": model.store_no,
            @"vehicle_code": model.vehicle_code,
            @"vehicle_no": model.vehicle_no,
        };
        [[TYWJNetWorkTolo sharedManager] requestWithMethod:POST WithPath:@"http://192.168.2.191:9001/gps/route" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
            
            [self startUpdatingLocation:model];
            NSLog(@"上传成功");
        } WithFailurBlock:^(NSError *error) {
            NSLog(@"上传失败");
            [MBProgressHUD zl_showError:@"打卡失败"];
        }];
    };
}
- (void)startUpdatingLocation:(TYWJDriveHomeList *)model{
    TYWJSingleLocation *mgr = [TYWJSingleLocation stantardLocation];
    mgr.updatingLocationCallback = ^(CLLocation *location, AMapLocationReGeocode *reGeocode) {
        NSDictionary *param = @{
            @"uid":[ZLUserDefaults objectForKey:TYWJLoginUidString],
            @"loc":@[@(location.coordinate.latitude),@(location.coordinate.longitude)],
            @"line_code": model.line_code,
            @"name": @"",
            @"store_no": model.store_no,
            @"vehicle_code": model.vehicle_code,
            @"vehicle_no": model.vehicle_no,
        };
        [[TYWJNetWorkTolo sharedManager] requestWithMethod:POST WithPath:@"http://192.168.2.191:9001/gps/route" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
            NSLog(@"上传成功");
            BOOL start = YES;
            BOOL end = NO;

            if (start) {
                
            }
            if (end) {
                [mgr stopUpdatingLocation];

            }
        } WithFailurBlock:^(NSError *error) {
            NSLog(@"上传失败");
        }];
    };
    [mgr startUpdatingLocation];
}
- (void)setupView {
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70.f, 40.f)];
    rightBtn.tag = 201;
    [rightBtn setTitle:@"更多班次" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    _tableView.mj_header = [ZLRefreshGifHeader headerWithRefreshingBlock:^{
        self->_isRefresh = YES;
        [self loadData];
    }];
    _tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        self->_isRefresh = NO;
        [self loadData];
    }];
    [_tableView.mj_header beginRefreshing];
}
- (void)backAction{

    [self.navigationController popViewControllerAnimated:NO];
        [ZLNotiCenter postNotificationName:@"TYWJDriverHomeViewViewControllerShowCalendar" object:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 166;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TYWJDriverHomeCell *cell = [TYWJDriverHomeCell cellForTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TYWJDriveHomeList *model = [self.dataArr objectAtIndex:indexPath.row];
    [cell confirgCellWithParam:model];
    __weak typeof(cell) weakCell = cell;
    cell.buttonSeleted = ^(NSInteger index) {
        //开始打卡
        [self startSign:model];
        [weakCell.singnBtn setTitle:@"结束打卡" forState:UIControlStateNormal];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

       [ZLNotiCenter postNotificationName:@"TYWJDriverHomeDetailViewController" object:[self.dataArr objectAtIndex:indexPath.row] ];


}

@end
