//
//  TYWJDriverPerformanceController.m
//  TYWJBus
//
//  Created by MacBook on 2018/12/28.
//  Copyright © 2018 MacBook. All rights reserved.
//  司机绩效

#import "TYWJDriverPerformanceController.h"
#import "TYWJDriverSignUpTitleView.h"
#import "TYWJDriverPerformanceCell.h"
#import "TYWJJsonRequestUrls.h"
#import "ZLHTTPSessionManager.h"
#import "TYWJLoginTool.h"
#import "TYWJDriverPerformanceHeaderView.h"
#import "TYWJBonus.h"
#import <MJExtension.h>

static CGFloat const kHeaderViewH = 100.f;
static CGFloat const kRowH = 70.f;

@interface TYWJDriverPerformanceController ()<UITableViewDelegate,UITableViewDataSource>

/* titleView */
@property (strong, nonatomic) TYWJDriverSignUpTitleView *titleView;
/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* dateArr */
@property (strong, nonatomic) TYWJBonus *bonus;
/* TYWJDriverPerformanceHeaderView */
@property (strong, nonatomic) TYWJDriverPerformanceHeaderView *headerView;

@end

@implementation TYWJDriverPerformanceController
#pragma mark - lazy loading

- (TYWJDriverSignUpTitleView *)titleView {
    if (!_titleView) {
        _titleView = [TYWJDriverSignUpTitleView titleViewWithSize:CGSizeMake(200.f, 44.f)];
        [_titleView setTitle:@"绩效查看"];
        
        NSString *dateString = [[TYWJCommonTool sharedTool] getTomorrowDay: [NSDate date]];
        [_titleView setDateTitle:dateString];
        [self requestPerformanceWithDate:dateString];
        WeakSelf;
        _titleView.dateUpdated = ^(NSString * _Nonnull selectedDate) {
            //日期更新
//            for (UIView *subView in weakSelf.view.subviews) {
//                [subView removeFromSuperview];
//            }
            [weakSelf requestPerformanceWithDate:selectedDate];
        };
    }
    return _titleView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.rowHeight = kRowH;
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.backgroundColor = ZLGlobalBgColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"TYWJDriverPerformanceCell" bundle:nil] forCellReuseIdentifier:TYWJDriverPerformanceCellID];
    }
    return _tableView;
}

- (TYWJDriverPerformanceHeaderView *)headerView {
    if (!_headerView ) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"TYWJDriverPerformanceHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0, ZLScreenWidth, kHeaderViewH);
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

#pragma mark - set up view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}


- (void)setupView {
    self.view.backgroundColor = ZLGlobalBgColor;
    self.navigationItem.titleView = self.titleView;
    
    [self.view addSubview:self.tableView];
    
}

/*
 ▿ {
 "data" : {
 "monthSum" : 8,
 "bonus" : [
 {
 "status" : null,
 "updateTime" : null,
 "depart" : "熊猫基地",
 "arrive" : "武侯祠\/锦里",
 "sent" : null,
 "day" : 20181227,
 "amount" : 4,
 "userId" : 368135,
 "tripId" : 2839001,
 "createTime" : 1545904671000,
 "id" : 157765
 },
 {
 "status" : null,
 "updateTime" : null,
 "depart" : "熊猫基地",
 "arrive" : "宽窄巷子",
 "sent" : null,
 "day" : 20181227,
 "amount" : 4,
 "userId" : 368135,
 "tripId" : 2839000,
 "createTime" : 1545926082000,
 "id" : 157766
 }
 ],
 "total" : 2
 },
 "errCode" : 0,
 "msg" : "请求成功"
 }

*/

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bonus.bonus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJDriverPerformanceCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJDriverPerformanceCellID forIndexPath:indexPath];
    TYWJBonusInfo *info = self.bonus.bonus[indexPath.row];
    cell.info = info;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.headerView.bonus = self.bonus;
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kHeaderViewH;
}
#pragma mark - 数据请求

- (void)requestPerformanceWithDate:(NSString *)date {
    WeakSelf;
    date = [date stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:self.view];
    ZLHTTPSessionManager *mgr = [ZLHTTPSessionManager signManager];
    [mgr.requestSerializer setValue:[TYWJLoginTool sharedInstance].driverInfo.token forHTTPHeaderField:@"token"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"startDay"] = date;
    params[@"requestFrom"] = @"iOS";
    params[@"pageNum"] = @1;
    params[@"pageSize"] = @50;
    
    [mgr GET:[TYWJJsonRequestUrls sharedRequest].bonus parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        responseObject = @{
//                           @"data" : @{
//                                   @"monthSum" : @8,
//                                   @"bonus" : @[@{
//                                    @"status" : @"",
//                                    @"updateTime" : @"",
//                                    @"depart" : @"熊猫基地",
//                                    @"arrive" : @"武侯祠锦里",
//                                    @"sent" : @"",
//                                    @"day" : @20181227,
//                                    @"amount" : @4,
//                                    @"userId" : @368135,
//                                    @"tripId" : @2839001,
//                                    @"createTime" : @1545904671000,
//                                    @"id" : @157765
//                                    },
//                           @{
//                               @"status" : @"",
//                               @"updateTime" : @"",
//                               @"depart" : @"熊猫基地",
//                               @"arrive" : @"宽窄巷子",
//                               @"sent" : @"",
//                               @"day" : @20181227,
//                               @"amount" : @4,
//                               @"userId" : @368135,
//                               @"tripId" : @2839000,
//                               @"createTime" : @1545926082000,
//                               @"id" : @157766
//                           }
//                           ],
//                                   @"total" : @2
//            },
//                           @"errCode" : @0,
//                           @"msg" : @"请求成功"
//            };
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        if ([responseObject[@"errCode"] integerValue] == 0) {
            [MBProgressHUD zl_hideHUDForView:weakSelf.view];
            weakSelf.bonus = [TYWJBonus mj_objectWithKeyValues:responseObject[@"data"]];
            [weakSelf.tableView reloadData];
        }else {
            [MBProgressHUD zl_showError:responseObject[@"msg"] toView:weakSelf.view];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:weakSelf.view];
        [[TYWJCommonTool sharedTool] returnRequestErrorInfoWithError:error];
    }];
}


- (void)setBonus:(TYWJBonus *)bonus {
    _bonus = bonus;
    if (!bonus.bonus.count) {
        [MBProgressHUD zl_showAlert:@"当日无绩效数据" afterDelay:2.f];
    }
}

@end
