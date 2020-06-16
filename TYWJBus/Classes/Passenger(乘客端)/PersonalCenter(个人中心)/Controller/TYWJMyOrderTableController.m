//
//  TYWJMyOrderController.m
//  TYWJBus
//
//  Created by tywj on 2020/5/25.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJMyOrderTableController.h"
#import "TYWJLoginTool.h"
#import "TYWJMyOrderTableViewCell.h"
#import <MJExtension.h>
#import "TYWJOrderList.h"
#import "TYWJOrderDetailController.h"
@interface TYWJMyOrderTableController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* dataList */
@property (strong, nonatomic) NSMutableArray *dataArr;


@end

@implementation TYWJMyOrderTableController

#pragma mark - lazy loading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 150.f;
    }
    _tableView.frame = self.view.bounds;
    return _tableView;
}


#pragma mark - set up view
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD zl_hideHUD];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    self.navigationItem.title = @"我的订单";
    
    [self.view addSubview:self.tableView];
    
    [self loadData];
}

- (void)dealloc {
    ZLFuncLog;
}

#pragma mark - 数据请求

- (void)loadData {
    NSInteger orderStatus = 0;
    switch (self.type) {
        case ALL:
        {
           
        }
            break;
        case WAIT_PAY:
        {
            orderStatus = 0;
            
        }
            break;
        case PAYED:
        {
            orderStatus = 1;
        }
            break;
        case REFUD:
        {
            orderStatus = 2 ;
        }
            break;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
        @"uid": [ZLUserDefaults objectForKey:TYWJLoginUidString],
        @"page_size":@10,
        @"create_date":[TYWJCommonTool getCurrcenTimeStr],
        @"page_type": @"1",
    }];
    if (self.type != ALL) {
        [param setValue:@(orderStatus) forKey:@"order_status"];
    }
    WeakSelf;
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.91:9005/ticket/orderinfo/search/order" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        NSArray *dataArr = [dic objectForKey:@"data"];
        if ([dataArr count] > 0) {
            self.dataArr = [TYWJOrderList mj_objectArrayWithKeyValuesArray:dataArr];
            [self.tableView reloadData];
                } else {
                    self.tableView.hidden = YES;
                    [self showNoDataViewWithDic:@{@"image":@"我的订单_空状态",@"title":@"这里空空如也"}];
                }
            } WithFailurBlock:^(NSError *error) {
                [weakSelf showRequestFailedViewWithImg:@"icon_no_network" tips:@"网络差，请稍后再试" btnTitle:nil btnClicked:^{
                    [weakSelf loadData];
                }];
            }];
}


- (void)reloadData {
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}


#pragma mark - 显示无数据页面
- (void)loadNoDataViewWithImg:(NSString *)img tips:(NSString *)tips btnTitle:(NSString *)btnTitle isHideBtn:(BOOL)isHideBtn {
    WeakSelf;
    [TYWJCommonTool loadNoDataViewWithImg:img tips:tips btnTitle:btnTitle isHideBtn:isHideBtn showingVc:self btnClicked:^(UIViewController *failedVc) {
        [failedVc.view removeFromSuperview];
        [weakSelf loadData];
        [failedVc removeFromParentViewController];
    }];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYWJMyOrderTableViewCell *cell = [TYWJMyOrderTableViewCell cellForTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell confirgCellWithModel:[self.dataArr objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TYWJOrderDetailController *vc = [[TYWJOrderDetailController alloc] init];
    vc.model = [self.dataArr objectAtIndex:indexPath.row];
    [TYWJCommonTool pushToVc:vc];
    
    
}

@end

