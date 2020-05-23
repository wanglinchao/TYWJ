//
//  TYWJHelpController.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/19.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJHelpController.h"
#import "TYWJSoapTool.h"
#import "TYWJHelpModel.h"
#import "TYWJHelpCell.h"


#import <MJExtension.h>


@interface TYWJHelpController ()<UITableViewDelegate,UITableViewDataSource>

/* dataList */
@property (strong, nonatomic) NSArray *dataList;
/* tableView */
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation TYWJHelpController
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJHelpCell class]) bundle:nil] forCellReuseIdentifier:TYWJHelpCellID];
    }
    return _tableView;
}
#pragma mark - set up view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
    [self loadData];
}

#pragma mark -

- (void)dealloc {
    ZLFuncLog;
}

- (void)setupView {
    self.navigationItem.title = @"常见问题与帮助";
    
    [self.view addSubview:self.tableView];
}

- (void)loadData {
    //TYWJRequestCommonQuestions
    WeakSelf;
    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:weakSelf.view];
    NSString * soapBodyStr = [NSString stringWithFormat:
                              @"<%@ xmlns=\"%@\">\
                              </%@>",TYWJRequestCommonQuestions,TYWJRequestService,TYWJRequestCommonQuestions];
    [TYWJSoapTool SOAPDataWithSoapBody:soapBodyStr success:^(id responseObject) {
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        if (responseObject) {
            id data = responseObject[0][@"NS1:changjianwentiResponse"][@"changjianwentiList"][@"changjianwenti"];
            if ([data isKindOfClass: [NSArray class]]) {
                weakSelf.dataList = [TYWJHelpModel mj_objectArrayWithKeyValuesArray:data];
                [weakSelf.tableView reloadData];
            }else if([data isKindOfClass: [NSDictionary class]]) {
                TYWJHelpModel *model = [TYWJHelpModel mj_objectWithKeyValues:data];
                weakSelf.dataList = @[model];
                [weakSelf.tableView reloadData];
            }else {
                [weakSelf loadNoDataViewWithImg:@"icon_no_ticket" tips:@"暂无数据哦,\n快去体验一下胖哒直通车吧~~" btnTitle:nil isHideBtn:YES];
            }
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        [weakSelf loadNoDataViewWithImg:@"icon_no_network" tips:@"网络怎么了?请稍后再试试吧" btnTitle:@"重新加载" isHideBtn:NO];
    }];
}

#pragma mark - 显示无数据页面
- (void)loadNoDataViewWithImg:(NSString *)img tips:(NSString *)tips btnTitle:(NSString *)btnTitle isHideBtn:(BOOL)isHideBtn {
    WeakSelf;
    [TYWJCommonTool loadNoDataViewWithImg:img tips:tips btnTitle:btnTitle isHideBtn:isHideBtn showingVc:self btnClicked:^(UIViewController *failedVc) {
        [failedVc.view removeFromSuperview];
        
        [weakSelf loadData];
        [failedVc removeFromParentViewController];
    }];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJHelpCellID forIndexPath:indexPath];
    TYWJHelpModel *model = self.dataList[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJHelpModel *model = self.dataList[indexPath.row];
    return model.cellH;
}

@end
