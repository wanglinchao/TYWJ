//
//  TYWJChooseSceneController.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJChooseSceneController.h"
#import "TYWJScenesA.h"
#import "TYWJScenesACell.h"
#import <WRNavigationBar.h>
#import <MJExtension.h>
#import "TYWJSceneHeaderView.h"


static CGFloat const kRowH = 35.f;

@interface TYWJChooseSceneController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* dataArray */
@property (strong, nonatomic) NSArray *dataArray;
@end

@implementation TYWJChooseSceneController
#pragma mark - lazy loading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.rowHeight = kRowH;
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[TYWJScenesACell class] forCellReuseIdentifier:TYWJScenesACellID];
        
        TYWJSceneHeaderView *headerView = [TYWJSceneHeaderView headerWithFrame:self.view.bounds];
        _tableView.tableHeaderView = headerView;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self loadData];
}

- (void)setupView {
    if (self.isGetdown) {
        self.navigationItem.title = @"目的地选择";
    }else {
        self.navigationItem.title = @"始发地选择";
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeClicked)];
    
    [self wr_setNavBarBarTintColor: ZLNavTextColor];
    [self wr_setNavBarTitleColor: [UIColor whiteColor]];
    [self wr_setNavBarTintColor: [UIColor whiteColor]];
    [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.view addSubview:self.tableView];
}

- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:TYWJScenesAPlist ofType:nil];
    if (path) {
        self.dataArray = [NSArray arrayWithContentsOfFile:path];
        self.dataArray = [TYWJScenesA mj_objectArrayWithKeyValuesArray:self.dataArray];
        [self.tableView reloadData];
    }
}

- (void)closeClicked {
    ZLFuncLog;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TYWJScenesA *sa = self.dataArray[section];
    return sa.scenes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJScenesACell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJScenesACellID forIndexPath:indexPath];
    TYWJScenesA *sa = self.dataArray[indexPath.section];
    cell.textLabel.text = sa.scenes[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kRowH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TYWJScenesA *sa = self.dataArray[section];
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = ZLGlobalBgColor;
    UILabel *l = [[UILabel alloc] init];
    l.frame = CGRectMake(15.f, 0, self.tableView.zl_width - 20.f, kRowH);
    [header addSubview:l];
    l.font = [UIFont systemFontOfSize:18.f];
    l.text = sa.type;
    header.zl_height = kRowH;
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
