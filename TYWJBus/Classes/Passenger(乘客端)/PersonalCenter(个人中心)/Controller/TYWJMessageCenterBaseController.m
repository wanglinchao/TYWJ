//
//  TYWJMessageCenterBaseController.m
//  TYWJBus
//
//  Created by tywj on 2020/5/21.
//  Copyright © 2020 MacBook. All rights reserved.
//
#import "TYWJMessageCenterBaseController.h"
#import "TYWJRequestFailedController.h"
#import "TYWJDetailActivityController.h"
#import "TYWJActivityCenterCell.h"
#import "TYWJSoapTool.h"
#import "TYWJActivityCenter.h"
#import <MJExtension.h>


@interface TYWJMessageCenterBaseController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* dataArray */
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation TYWJMessageCenterBaseController
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 98;
        [_tableView registerNib:[UINib nibWithNibName:@"TYWJActivityCenterCell" bundle:nil] forCellReuseIdentifier:TYWJActivityCenterCellID];
    }
    return _tableView;
}
#pragma mark - setup view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self setupView];
}

#pragma mark -

- (void)dealloc {
    ZLFuncLog;
}

- (void)setupView {
    self.navigationItem.title = @"消息中心";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)showTableView {
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

- (void)showNoDataView {
    TYWJRequestFailedController *vc = [[TYWJRequestFailedController alloc] init];
    vc.view.frame = self.view.bounds;
    vc.view.zl_y = kNavBarH;
    vc.view.zl_height -= kNavBarH;
    [vc setImg:@"icon_no_ticket" tips:@"活动君正在赶来,敬请期待~" btnTitle:nil isHideBtn:YES];
    [self.view addSubview:vc.view];
}
#pragma mark - 加载数据
- (void)loadData {
    WeakSelf;
    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:self.view];
    NSString *bodyStr = [NSString stringWithFormat:
                         @"<%@ xmlns=\"%@\">\
                         </%@>",TYWJRequestAcitivity,TYWJRequestService,TYWJRequestAcitivity];
    [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:bodyStr success:^(id responseObject) {
        ZLFuncLog;
        [MBProgressHUD zl_hideHUDForView:self.view];
        id data = responseObject[0][@"NS1:huodongzhongxinResponse"][@"huodongzhongxinList"][@"huodongzhongxin"];
        if ([data isKindOfClass: [NSDictionary class]]) {
            TYWJActivityCenter *ac = [TYWJActivityCenter mj_objectWithKeyValues:data];
            weakSelf.dataArray = @[ac];
            [weakSelf showTableView];
        }else if ([data isKindOfClass: [NSArray class]]) {
            weakSelf.dataArray = [TYWJActivityCenter mj_objectArrayWithKeyValuesArray:data];
            [weakSelf showTableView];
        }else {
            [weakSelf showNoDataView];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        [weakSelf showNoDataView];
    }];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJActivityCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJActivityCenterCellID forIndexPath:indexPath];
    TYWJActivityCenter *ac = self.dataArray[indexPath.row];
    cell.acInfo = ac.info;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TYWJActivityCenter *ac = self.dataArray[indexPath.row];
    TYWJDetailActivityController *vc = [[TYWJDetailActivityController alloc] init];
    vc.acInfo = ac.info;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
