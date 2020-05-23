//
//  TYWJRouteAppliedSuccessfullyController.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/17.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJRouteAppliedSuccessfullyController.h"
#import "TYWJApplyRouteController.h"
#import "TYWJApplyRouteCell.h"
#import "TYWJBorderButton.h"
#import "TYWJRouteAppliedSucFooter.h"
#import "TYWJApplyRoute.h"
#import "TYWJApplyLineViewController.h"

#import <MJExtension.h>


@interface TYWJRouteAppliedSuccessfullyController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TYWJRouteAppliedSuccessfullyController
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0, 10.f, ZLScreenWidth, ZLScreenHeight - 75.f - kTabBarH - kNavBarH);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 54.f;
        _tableView.backgroundColor = ZLGlobalBgColor;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJApplyRouteCell class]) bundle:nil] forCellReuseIdentifier:TYWJApplyRouteCellID];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self addFooterView];
}

#pragma mark -

- (void)dealloc {
    ZLFuncLog;
}

- (void)setupView {
    self.navigationItem.title = @"线路申请成功";
    

    [self.view addSubview:self.tableView];
}

- (void)addFooterView {
    TYWJBorderButton *commitBtn = [[TYWJBorderButton alloc] init];
    commitBtn.frame = CGRectMake(20.f, self.view.zl_height - kTabBarH - 60.f, ZLScreenWidth - 46.f, 46.f);
    [commitBtn setTitle:@"重新填写" forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [commitBtn addTarget:self action:@selector(commitClicked) forControlEvents:UIControlEventTouchUpInside];
    [commitBtn setRoundViewWithCornerRaidus:8.f];
    [self.view addSubview:commitBtn];
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJApplyRouteCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJApplyRouteCellID forIndexPath:indexPath];
    TYWJApplyRoute *route = self.dataList[indexPath.row];
    cell.route = route;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TYWJRouteAppliedSucFooter *footer = [[NSBundle mainBundle] loadNibNamed:@"TYWJRouteAppliedSucFooter" owner:nil options:nil].lastObject;
    footer.backgroundColor = ZLGlobalBgColor;
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 70.f;
}
#pragma mark - 按钮点击

- (void)commitClicked {
    ZLFuncLog;
    UINavigationController *nav = self.navigationController;
    [nav popToRootViewControllerAnimated:NO];
    
//    TYWJApplyRouteController *vc = [[TYWJApplyRouteController alloc] init];
//    [nav pushViewController:vc animated:YES];
    TYWJApplyLineViewController *applyVC = [[TYWJApplyLineViewController alloc] init];
    [nav pushViewController:applyVC animated:YES];
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:TYWJApplyRoutePlist ofType:nil];
    if (path) {
        NSArray *listArray = [NSArray arrayWithContentsOfFile:path];
        self.dataList = [TYWJApplyRoute mj_objectArrayWithKeyValuesArray:listArray];
        
        for (NSInteger i = 0; i < 4; i++) {
            TYWJApplyRoute *route = self.dataList[i];
            NSString *string = dataArr[i];
            string = [string stringByReplacingOccurrencesOfString:@"__" withString:@"&"];
            route.body = string;
        }
        [self.tableView reloadData];
    }
}
@end
