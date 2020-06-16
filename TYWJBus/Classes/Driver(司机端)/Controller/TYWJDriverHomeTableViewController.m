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
@interface TYWJDriverHomeTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation TYWJDriverHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.dayStr?self.dayStr:[TYWJCommonTool getTodayDay];
    [self loadData];
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadData{
    WeakSelf;
    NSDictionary *param = @{
        @"driver_code":@"467676735333203968",
        @"status":self.status,
        @"line_date":self.dayStr?self.dayStr:[TYWJCommonTool getTodayDay],
        @"create_date":@"2020:06:11",
        @"page_size":@"10",
        @"page_type":@"1",
    };
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.192:9005/ticket/inspect/driver/store" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        NSArray *data = [dic objectForKey:@"data"];
        if (data.count > 0) {
            self.dataArr = [TYWJDriveHomeList mj_objectArrayWithKeyValuesArray:data];
            [self.tableView reloadData];
        }else {
            [weakSelf showNoDataViewWithDic:@{}];
        }

    } WithFailurBlock:^(NSError *error) {
        [weakSelf showRequestFailedViewWithImg:@"icon_no_network" tips:@"网络差，请稍后再试" btnTitle:nil btnClicked:^{
            [self loadData];
        }];
    }];
}
- (void)setupView {
    ZLRefreshGifHeader *mjHeader = [ZLRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _tableView.mj_header = mjHeader;
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70.f, 40.f)];
    rightBtn.tag = 201;
    [rightBtn setTitle:@"更多班次" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
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
    [cell confirgCellWithParam:[self.dataArr objectAtIndex:indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TYWJDriveHomeDetailViewController *vc = [[TYWJDriveHomeDetailViewController alloc] init];
    vc.model = [self.dataArr objectAtIndex:indexPath.row];
    [TYWJCommonTool pushToVc:vc];
}

@end
