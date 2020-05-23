//
//  TYWJMileageInfoController.m
//  TYWJBus
//
//  Created by MacBook on 2018/12/13.
//  Copyright © 2018 MacBook. All rights reserved.
//  油耗信息界面

#import "TYWJMileageInfoController.h"
#import "TYWJDriverLicensesCell.h"
#import "ZLPopoverView.h"
#import "TYWJMileageLog.h"

static NSString * const kAllCarLicenseString = @"所有车辆";

@interface TYWJMileageInfoController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* headerView */
@property (strong, nonatomic) UIButton *headerView;
/* selectedLicenses */
@property (copy, nonatomic) NSArray *selectedMileages;
/* selectedLicense */
@property (copy, nonatomic) NSString *selectedLicense;

@end

@implementation TYWJMileageInfoController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 60.f;
        
        
        [_tableView registerNib:[UINib nibWithNibName:@"TYWJDriverLicensesCell" bundle:nil] forCellReuseIdentifier:TYWJDriverLicensesCellID];
        
    }
    return _tableView;
}

- (UIButton *)headerView {
    if (!_headerView) {
        _headerView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth, 40.f)];
        _headerView.backgroundColor = ZLGlobalBgColor;
        [_headerView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_headerView setTitle:[NSString stringWithFormat:@"%@ ▼",kAllCarLicenseString] forState:UIControlStateNormal];
        [_headerView addTarget:self action:@selector(headerClicked) forControlEvents:UIControlEventTouchUpInside];
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
    self.navigationItem.title = @"里程记录";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"作废" style:UIBarButtonItemStylePlain target:self action:@selector(clearClicked)];
    self.selectedMileages = [self.mileageInfos copy];
    self.selectedLicense = kAllCarLicenseString;
    
    if (self.mileageInfos.count) {
        [self.view addSubview:self.tableView];
    }else {
        [TYWJCommonTool loadNoDataViewWithImg:@"icon_no_ticket" tips:@"暂无录入的油耗信息" btnTitle:nil isHideBtn:YES showingVc:self];
    }
    
    
}

#pragma mark - 按钮点击

- (void)clearClicked {
    ZLFuncLog;
    [MBProgressHUD zl_showAlert:@"暂未开放此功能" afterDelay:2.f];
}

- (void)headerClicked {
    ZLFuncLog;
    WeakSelf;
    [[ZLPopoverView sharedInstance] showChooseCarLicenseViewWithCarLicenses:self.carLicenses cellSelected:^(NSString *cl) {
        if ([cl isEqualToString:kAllCarLicenseString]) {
            weakSelf.selectedMileages = [weakSelf.mileageInfos copy];
            
        }else {
            NSMutableArray *tmpArr = [NSMutableArray array];
            for (TYWJMileageLog *mileage in weakSelf.mileageInfos) {
                if ([mileage.carNumber isEqualToString:cl] ) {
                    [tmpArr addObject:mileage];
                }
            }
            weakSelf.selectedMileages = [tmpArr copy];
        }
        
        weakSelf.selectedLicense = cl;
        [weakSelf.headerView setTitle:[NSString stringWithFormat:@"%@ ▼",cl] forState:UIControlStateNormal];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedMileages.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJDriverLicensesCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJDriverLicensesCellID forIndexPath:indexPath];
    TYWJMileageLog *mileage = self.selectedMileages[indexPath.row];
    cell.mileageLog = mileage;
    return cell;
}

- (void)setCarLicenses:(NSMutableArray *)carLicenses {
    _carLicenses = [NSMutableArray array];
    [_carLicenses addObject:kAllCarLicenseString];
    [_carLicenses addObjectsFromArray:carLicenses];
}

@end
