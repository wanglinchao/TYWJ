//
//  TYWJSchedulingViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/5/18.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJSchedulingViewController.h"
#import "TYWJSectionHeadView.h"
#import "TYWJSchedulingTableViewCell.h"
#import "ZLRefreshGifHeader.h"
#import "TYWJSchedulingDetialViewController.h"
#import "TYWJTripList.h"
#import "TYWJDetailRouteController.h"
#import "TYWJRouteList.h"
@interface TYWJSchedulingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableDictionary *showHeaderDic;

@end

@implementation TYWJSchedulingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"行程";
    [self loadData];
    [self setupView];
    self.showHeaderDic = [[NSMutableDictionary alloc] init];
    self.dataArr  = [NSMutableArray array];

    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)loadData {
    NSDictionary *param = @{
        @"uid": [ZLUserDefaults objectForKey:TYWJLoginUidString],
         @"line_Date": [TYWJCommonTool getCurrcenTimeStr],
          @"days": @10,
    };
    WeakSelf;
    
    
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.91:9005/ticket/orderinfo/search/trip" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        NSArray *dataArr = [dic objectForKey:@"data"];
        if ([dataArr count] > 0) {
            self.dataArr = [TYWJTripList mj_objectArrayWithKeyValuesArray:dataArr];
            [self checkIsFirstDay];
            [self.view addSubview:self.tableView];
            [self.tableView reloadData];
        } else {
            self.tableView.hidden = YES;
            [self showNoDataViewWithDic:@{@"image":@"行程_空状态",@"title":@"你还没有待消费的行程哦，马上买一个吧"}];
        }
    } WithFailurBlock:^(NSError *error) {
        [weakSelf showRequestFailedViewWithImg:@"icon_no_network" tips:@"网络差，请稍后再试" btnTitle:nil btnClicked:^{
            [self loadData];
        }];
    }];
}
- (void)checkIsFirstDay{
    NSMutableDictionary *dayDic = [[NSMutableDictionary alloc] init];
    for (int i = 0; i<self.dataArr.count; i ++) {
        TYWJTripList *getModel = self.dataArr[i];
        NSMutableDictionary *dic = [dayDic mutableCopy];
        [dayDic setValue:@"1" forKey:getModel.line_date];
        if (dayDic.allKeys.count > dic.allKeys.count) {
            getModel.isFristDay = YES;
        }
    }
}
- (void)setupView {
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJSchedulingTableViewCell class]) bundle:nil] forCellReuseIdentifier:TYWJSchedulingTableViewCellID];

    ZLRefreshGifHeader *mjHeader = [ZLRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _tableView.mj_header = mjHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYWJTripList *getModel = self.dataArr[indexPath.row];
    if (getModel.isFristDay) {
        return 204;
    }
    return 204 - 50;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    TYWJSchedulingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJSchedulingTableViewCellID forIndexPath:indexPath];
    [cell confirgCellWithModel:[self.dataArr objectAtIndex:indexPath.row]];
    TYWJTripList *getModel = self.dataArr[indexPath.row];

    if (getModel.isFristDay) {
        [cell showHeaderView:YES];
    } else {
        [cell showHeaderView:NO];
    }
    return cell;
 
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TYWJDetailRouteController *detailRouteVc = [[TYWJDetailRouteController alloc] init];
    TYWJTripList *getModel = self.dataArr[indexPath.row];
    TYWJRouteListInfo *model = [[TYWJRouteListInfo alloc] init];
    model.line_info_id = [NSString stringWithFormat:@"%@",getModel.line_name];
    detailRouteVc.stateValue = getModel.status;
    detailRouteVc.isDetailRoute = NO;
    detailRouteVc.routeListInfo = model;
    [self.navigationController pushViewController:detailRouteVc animated:YES];
}

@end
