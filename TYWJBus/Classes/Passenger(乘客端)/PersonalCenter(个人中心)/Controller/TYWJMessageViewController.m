//
//  TYWJMessageViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/5/18.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJMessageViewController.h"
#import "TYWJMessageTableViewCell.h"
#import "ZLRefreshGifHeader.h"
#import "TYWJMessageDetailTableViewController.h"
#import "TYWJMessageModel.h"
@interface TYWJMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TYWJMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupView];
    [_tableView.mj_header beginRefreshing];
}
- (void)setupView {
    ZLRefreshGifHeader *mjHeader = [ZLRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _tableView.mj_header = mjHeader;
    [_tableView.mj_header beginRefreshing];

}
- (void)loadData{
    WeakSelf;
    NSDictionary *param = @{
        @"page_size":@"20",
        @"page_type":@"1",
        @"uid":[ZLUserDefaults objectForKey:TYWJLoginUidString],
    };
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.91:9005/loc/remind/list" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        NSArray *data = [dic objectForKey:@"data"];
        weakSelf.dataArr = [TYWJMessageModel mj_objectArrayWithKeyValuesArray:data];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        if (self.dataArr.count == 0) {
            self.tableView.hidden = YES;
            [self showNoDataViewWithDic:@{@"image":@"消息中心_空状态",@"title":@"暂无消息"}];
        }
    } WithFailurBlock:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TYWJMessageTableViewCell *cell = [TYWJMessageTableViewCell cellForTableView:tableView];
    [cell confirgCellWithParam:[self.dataArr objectAtIndex:indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TYWJMessageDetailTableViewController *vc = [TYWJMessageDetailTableViewController new];
    vc.dataArr = @[[self.dataArr objectAtIndex:indexPath.row]];
    [TYWJCommonTool pushToVc:vc];
}

@end
