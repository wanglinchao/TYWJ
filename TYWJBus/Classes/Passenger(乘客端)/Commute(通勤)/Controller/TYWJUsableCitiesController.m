
//
//  TYWJUsableCitiesController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/28.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJUsableCitiesController.h"
#import "TYWJRequestFailedController.h"
#import "TYWJUsableCitiesCurrentCityCell.h"
#import "TYWJUsableCitiesDredgedCityCell.h"



#import <MJExtension.h>


static CGFloat const kSectionHeaderH = 36.f;

@interface TYWJUsableCitiesController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;


@end

@implementation TYWJUsableCitiesController
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 50.f;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJUsableCitiesCurrentCityCell class]) bundle:nil] forCellReuseIdentifier:TYWJUsableCitiesCurrentCityCellID];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJUsableCitiesDredgedCityCell class]) bundle:nil] forCellReuseIdentifier:TYWJUsableCitiesDredgedCityCellID];
    }
    return _tableView;
}

#pragma mark - setup view
- (void)dealloc {
    ZLFuncLog;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *windows = [UIApplication sharedApplication].windows;
    ZLLog(@"---%@",windows);
    [self setupView];
}

- (void)setupView {
    self.navigationItem.title = @"选择城市";
    [self.view addSubview:self.tableView];
    if (!(self.cityList.count > 0)) {
            [self loadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD zl_hideHUD];
}


#pragma mark - 请求数据
- (void)loadData {
    WeakSelf;

    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.91:9005/ticket/position/city" WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        NSArray *data = [dic objectForKey:@"data"];
        weakSelf.cityList = [TYWJUsableCity mj_objectArrayWithKeyValuesArray:data];
        if (weakSelf.cityList) {
            [weakSelf.tableView reloadData];
        }
     

    } WithFailurBlock:^(NSError *error) {
        [weakSelf showRequestFailedViewWithImg:@"icon_no_network" tips:@"网络差，请稍后再试" btnTitle:nil btnClicked:^{
            [self loadData];
        }];
    }];
}
#pragma mark - <UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else {
        return self.cityList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TYWJUsableCitiesCurrentCityCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJUsableCitiesCurrentCityCellID forIndexPath:indexPath];
        return cell;
    }
    else {
        TYWJUsableCitiesDredgedCityCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJUsableCitiesDredgedCityCellID forIndexPath:indexPath];
        TYWJUsableCity *city = self.cityList[indexPath.row];
        cell.city = city;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        TYWJUsableCity *city = self.cityList[indexPath.row];
        [TYWJCommonTool sharedTool].selectedCity = city;
        [[TYWJCommonTool sharedTool] saveSelectedCityInfo];
        //发送通知
        [ZLNotiCenter postNotificationName:TYWJSelectedCityChangedNoti object:city.city_name];
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 00.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionHeaderH;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.zl_width, kSectionHeaderH)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.f, 0, self.view.zl_width - 40.f, headerView.zl_height)];
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    [headerView addSubview:titleLabel];
    if (section == 0) {
        titleLabel.text = @"当前城市";
    }else {
        titleLabel.text = @"开通城市";
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark - 显示no data view
- (void)showRequestFailedViewWithImg:(NSString *)img tips:(NSString *)tips btnTitle:(NSString *)btnTitle {
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    TYWJRequestFailedController *vc = [[TYWJRequestFailedController alloc] init];
    vc.view.frame = self.view.bounds;
    WeakSelf;
    __weak typeof(vc) weakVc = vc;
    
    [self.view addSubview:vc.view];
    vc.reloadClicked = ^{
        [weakVc.view removeFromSuperview];
        [weakSelf loadData];
        [weakVc removeFromParentViewController];
        [weakSelf.view addSubview:self.tableView];
    };
    [vc setImg:img tips:tips btnTitle:btnTitle isHideBtn:NO];
    [self addChildViewController:vc];
    ZLLog(@"--个数--%ld",self.childViewControllers.count);
}
@end
