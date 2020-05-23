//
//  TYWJITCategoryController.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/20.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJITCategoryController.h"
#import "TYWJITCategoryCell.h"
#import "TYWJITCategoryHeaderView.h"
#import "TYWJITDetailSceneController.h"
#import "TYWJShoppingCarController.h"
#import <WRNavigationBar.h>


@interface TYWJITCategoryController()<UITableViewDelegate,UITableViewDataSource>

/* tableview */
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TYWJITCategoryController
#pragma mark - lazy loading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(-kNavBarH, 0, 0, 0);
        _tableView.rowHeight = 120.f;
        [_tableView registerNib:[UINib nibWithNibName:@"TYWJITCategoryCell" bundle:nil] forCellReuseIdentifier:TYWJITCategoryCellID];
        
        TYWJITCategoryHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"TYWJITCategoryHeaderView" owner:nil options:nil] lastObject];
        header.zl_height = 280.f;
        _tableView.tableHeaderView = header;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    self.view.backgroundColor = ZLGlobalBgColor;
    self.navigationItem.title = self.type;
    [self wr_setNavBarBackgroundAlpha:0];
    
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"购物车" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClicked)];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJITCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJITCategoryCellID forIndexPath:indexPath];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJITDetailSceneController *detailVc = [[TYWJITDetailSceneController alloc] init];
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat rate = (offsetY - kNavBarH)/kNavBarH;
    [self wr_setNavBarBackgroundAlpha:rate];
}

#pragma mark - 按钮点击

- (void)rightItemClicked {
    ZLFuncLog;
    TYWJShoppingCarController *Vc = [[TYWJShoppingCarController alloc] init];
    [self.navigationController pushViewController:Vc animated:YES];
}

@end
