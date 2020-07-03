//
//  TYWJTableViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/5/18.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJDrierAchievementController.h"
#import "TYWJDriverAchievementCell.h"
#import "ZLRefreshGifHeader.h"
#import "TYWJAchievementinfo.h"
#import "TYWJAchievementHeaderView.h"
#import "TYWJCommonSectionHeaderView.h"
#import "MJRefreshBackStateFooter.h"
@interface TYWJDrierAchievementController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isRefresh;
    long _time;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) TYWJAchievementHeaderView *headerView;


@end

@implementation TYWJDrierAchievementController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray array];
    self.title = @"查看绩效";
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadData {
    WeakSelf;

    NSInteger page_size = 1;

    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.191:9002/mgt/driver/starLight" WithParams:@{
        @"driver_code":[ZLUserDefaults objectForKey:TYWJLoginUidString],
    } WithSuccessBlock:^(NSDictionary *dic) {
        [self.headerView confirgCellWithParam:[dic objectForKey:@"data"]];
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
            @"driver_code":[ZLUserDefaults objectForKey:TYWJLoginUidString],
            @"page_size":@(page_size),
            @"page_type":@(1)
        }];
        if (!_isRefresh) {
            [param setValue:@(_time) forKey:@"create_time"];
        }

        
        
        
        
        [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.191:9002/mgt/driver/achievement" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
            NSArray *dataArr = [dic objectForKey:@"data"];
            NSLog(@"dataArr数量%lu",(unsigned long)dataArr.count);
            if (self->_isRefresh) {
                [weakSelf.tableView.mj_footer endRefreshing];
                [weakSelf.dataArr removeAllObjects];
                [weakSelf.tableView.mj_header endRefreshing];
                if ([dataArr count] == 0) {
                    self.tableView.hidden = YES;
//                    [self showNoDataViewWithDic:@{@"image":@"我的订单_空状态",@"title":@"这里空空如也"}];
                }
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            if ([dataArr count] < page_size) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if ([dataArr count] > 0) {
                long time = [[[dataArr lastObject] objectForKey:@"create_time"] longValue];
                self->_time = time;
                [self.dataArr addObjectsFromArray:[TYWJAchievementinfo mj_objectArrayWithKeyValuesArray:dataArr]];
            }
            [self.tableView reloadData];
            
            
            
            
            
            
            
        } WithFailurBlock:^(NSError *error) {
            [weakSelf showRequestFailedViewWithImg:@"icon_no_network" tips:TYWJWarningBadNetwork btnTitle:nil btnClicked:^{
                [self loadData];
            }];
        }];
        
    } WithFailurBlock:^(NSError *error) {
        [weakSelf showRequestFailedViewWithImg:@"icon_no_network" tips:TYWJWarningBadNetwork btnTitle:nil btnClicked:^{
            [self loadData];
        }];
    }];
    
    
    
    
    

}
- (void)setupView{
    self.headerView = [[TYWJAchievementHeaderView alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth, 100)];
    self.tableView.tableHeaderView = self.headerView;
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

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    TYWJCommonSectionHeaderView *view = [[TYWJCommonSectionHeaderView alloc] initWithFrame:CGRectMake(0, 100, ZLScreenWidth, 0)];
////    [view confirgCellWithParam:@"今日绩效"];
//    return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 50;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 156;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TYWJDriverAchievementCell *cell = [TYWJDriverAchievementCell cellForTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.numL.text = [NSString stringWithFormat:@"%ld.",(long)indexPath.row + 1];
    [cell confirgCellWithParam:[self.dataArr objectAtIndex:indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
