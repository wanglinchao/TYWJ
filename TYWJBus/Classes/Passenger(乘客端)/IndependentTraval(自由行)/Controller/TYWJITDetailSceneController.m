//
//  TYWJITDetailSceneController.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/20.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJITDetailSceneController.h"
#import "TYWJShoppingCarController.h"
#import "TYWJITDetailSceneHeader.h"
#import <WRNavigationBar.h>


@interface TYWJITDetailSceneController()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TYWJITDetailSceneController
#pragma mark - lazy loading

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.contentInset = UIEdgeInsetsMake(-kNavBarH, 0, 0, 0);
        
        TYWJITDetailSceneHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"TYWJITDetailSceneHeader" owner:nil options:nil] lastObject];
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
    if ([TYWJCommonTool sharedTool].currentSysVersion.doubleValue < 11) {
        self.tableView.autoresizesSubviews = YES;
    }
    self.view.backgroundColor = ZLGlobalBgColor;
    self.navigationItem.title = @"景区详情";
    [self wr_setNavBarBackgroundAlpha:0];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"购物车" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClicked)];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
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
