//
//  TYWJSearchRouteResultController.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/4.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJSearchRouteResultController.h"
#import "TYWJSearchReult.h"
#import "TYWJSearchRouteResultCell.h"
#import "TYWJBuyTicketController.h"
#import "TYWJDetailRouteController.h"
#import "TYWJRouteList.h"
#import <MJExtension.h>


@interface TYWJSearchRouteResultController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TYWJSearchRouteResultController
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 255.f;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJSearchRouteResultCell class]) bundle:nil] forCellReuseIdentifier:TYWJSearchRouteResultCellID];
    }
    return _tableView;
}

- (void)dealloc {
    ZLFuncLog;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    self.navigationItem.title = @"线路查询结果";
    
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJSearchRouteResultCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJSearchRouteResultCellID forIndexPath:indexPath];
    TYWJSearchReult *result = self.searchResult[indexPath.row];
    cell.result = result;
    WeakSelf;
    cell.purchaseBtnClicked = ^(TYWJSearchReult *result) {
        TYWJBuyTicketController *buyTicketVc = [[TYWJBuyTicketController alloc] init];
        buyTicketVc.result = result;
        [weakSelf.navigationController pushViewController:buyTicketVc animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJSearchReult *result = self.searchResult[indexPath.row];
    TYWJDetailRouteController *detailRouteVc = [[TYWJDetailRouteController alloc] init];
    detailRouteVc.isDetailRoute = YES;
    detailRouteVc.routeListInfo = result.routeInfo;
    [self.navigationController pushViewController:detailRouteVc animated:YES];
}


@end
