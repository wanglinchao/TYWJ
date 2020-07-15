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
#import "TYWJTripList.h"
#import "TYWJDetailRouteController.h"
#import "TYWJRouteList.h"
#import "MJRefreshBackStateFooter.h"

@interface TYWJSchedulingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isRefresh;
    NSString *_time;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableDictionary *showHeaderDic;

@end

@implementation TYWJSchedulingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isHistory) {
        self.title = @"历史行程";
    } else {
        self.title = @"行程";
    }
    //    [self loadData];
    [self setupView];
    self.showHeaderDic = [[NSMutableDictionary alloc] init];
    self.dataArr  = [NSMutableArray array];
    [self addNotis];
    // Do any additional setup after loading the view from its nib.
}
- (void)dealloc {
    ZLFuncLog;
    [self removeNotis];
}
#pragma mark - 通知相关
- (void)addNotis {
    [ZLNotiCenter addObserver:self selector:@selector(loadData) name:@"TYWJRefreshScheduleList" object:nil];
}

- (void)removeNotis {
    [ZLNotiCenter removeObserver:self name:@"TYWJRefreshScheduleList" object:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.dataArr.count == 0) {
        [_tableView.mj_header beginRefreshing];
        
        
    }
    
}
- (void)loadData {
    NSInteger page_size = 1;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
        @"uid": [ZLUserDefaults objectForKey:TYWJLoginUidString],
        @"days": @(page_size),
    }];
    if (!_isRefresh) {
        [param setValue:_time forKey:@"line_Date"];
    }
    WeakSelf;
    NSString *urlStr = @"";
    if (self.isHistory) {
        urlStr = @"http://192.168.2.91:9005/ticket/orderinfo/search/trip/his";
    } else {
        urlStr = @"http://192.168.2.91:9005/ticket/orderinfo/search/trip";
    }
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:urlStr WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        NSArray *dataArr = [dic objectForKey:@"data"];
        if (self->_isRefresh) {
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.tableView.mj_header endRefreshing];
            if ([dataArr count] == 0) {
                [weakSelf showRequestFailedViewWithImg:@"行程_空状态" tips:@"你还没有待消费的行程哦，马上买一个吧" btnTitle:@"刷新" btnClicked:^{
                    [self loadData];
                }];
                
                //                
                //                self.tableView.hidden = YES;
                //                [self showNoDataViewWithDic:@{@"image":@"行程_空状态",@"title":@"你还没有待消费的行程哦，马上买一个吧"}];
            }
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        if ([dataArr count] < page_size) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if ([dataArr count] > 0) {
            NSString *time = [[dataArr lastObject] objectForKey:@"line_date"];
            self->_time = time;
            [self.dataArr addObjectsFromArray:[TYWJTripList mj_objectArrayWithKeyValuesArray:dataArr]];
            [self checkIsFirstDay];
        }
        
        [self.tableView reloadData];
        
        
        
        
        
        
    } WithFailurBlock:^(NSError *error) {
        [self->_tableView.mj_header endRefreshing];
        [self->_tableView.mj_footer endRefreshing];
        [weakSelf showRequestFailedViewWithImg:@"icon_no_network" tips:TYWJWarningBadNetwork btnTitle:nil btnClicked:^{
            [self loadData];
        }];
    } showLoad:NO];
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
- (void)showHistory{
    TYWJSchedulingViewController *hisVC = [[TYWJSchedulingViewController alloc] init];
    hisVC.isHistory = YES;
    [TYWJCommonTool pushToVc:hisVC];
}
- (void)setupView {
    if (!self.isHistory) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"历史行程" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        button.zl_size = CGSizeMake(80, 30);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(showHistory) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJSchedulingTableViewCell class]) bundle:nil] forCellReuseIdentifier:TYWJSchedulingTableViewCellID];
    
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    model.line_info_id = [NSString stringWithFormat:@"%@",getModel.line_code];
    detailRouteVc.isDetailRoute = NO;
    detailRouteVc.routeListInfo = model;
    detailRouteVc.tripListInfo = getModel;
    [self.navigationController pushViewController:detailRouteVc animated:YES];
}

@end
