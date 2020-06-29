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
        [weakSelf showRequestFailedViewWithImg:@"icon_no_network" tips:@"网络差，请稍后再试" btnTitle:nil btnClicked:^{
            [self loadData];
        }];
    }];
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
