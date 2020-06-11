//
//  TYWJTableViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/5/18.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJDriverMoreLineController.h"
#import "TYWJTableViewControllerCell.h"
#import "ZLRefreshGifHeader.h"
@interface TYWJDriverMoreLineController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation TYWJDriverMoreLineController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看更多";
    [self loadData];
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadData {
//    WeakSelf;
//    NSInteger index ;
//    NSDictionary *param = @{
//        @"driver_code":@"467676735333203968",
//    };
//    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.192:9005" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
//        NSArray *data = [dic objectForKey:@"data"];
//        if (data.count) {
//            self.dataArr = [TYWJTicketStoreList mj_objectArrayWithKeyValuesArray:data];
//        }else {
//             weakSelf.tableView.hidden = YES;
//            [weakSelf showNoDataViewWithDic:@{}];
//        }
//        TYWJTableViewController *vc = [[TYWJTableViewController alloc] init];
//        [TYWJCommonTool pushToVc:vc];
//    } WithFailurBlock:^(NSError *error) {
//        [weakSelf showRequestFailedViewWithImg:@"icon_no_network" tips:@"网络差，请稍后再试" btnTitle:nil btnClicked:^{
//            [self loadData];
//        }];
//    }];
    self.dataArr  = [NSMutableArray array];
    NSArray *arr = @[@"",@"",@""];
    [self.dataArr addObjectsFromArray:arr];
}
- (void)setupView {
    ZLRefreshGifHeader *mjHeader = [ZLRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _tableView.mj_header = mjHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TYWJTableViewControllerCell *cell = [TYWJTableViewControllerCell cellForTableView:tableView];
    [cell confirgCellWithParam:@{}];
    cell.backgroundColor = randomColor;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
