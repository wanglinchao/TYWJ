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
@interface TYWJDrierAchievementController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) TYWJAchievementHeaderView *headerView;


@end

@implementation TYWJDrierAchievementController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看绩效";
    [self loadData];
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadData {
    WeakSelf;
    NSDictionary *param = @{
        @"driver_code":@"467676735333203968",
    };
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.192:9008/fnc/driver/achievement" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        [self.headerView confirgCellWithParam:[dic objectForKey:@"data"]];
        NSArray *data = [[dic objectForKey:@"data"] objectForKey:@"day_achievement_list"];
        if (data.count) {
            self.dataArr = [TYWJAchievementinfo mj_objectArrayWithKeyValuesArray:data];
            [self.tableView reloadData];
        }else {
//             weakSelf.tableView.hidden = YES;
//            [weakSelf showNoDataViewWithDic:@{}];
        }

    } WithFailurBlock:^(NSError *error) {
        [weakSelf showRequestFailedViewWithImg:@"icon_no_network" tips:@"网络差，请稍后再试" btnTitle:nil btnClicked:^{
            [self loadData];
        }];
    }];

}
- (void)setupView{
    self.headerView = [[TYWJAchievementHeaderView alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth, 100)];
    self.tableView.tableHeaderView = self.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TYWJCommonSectionHeaderView *view = [[TYWJCommonSectionHeaderView alloc] initWithFrame:CGRectMake(0, 100, ZLScreenWidth, 50)];
    [view confirgCellWithParam:@"今日绩效"];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
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
