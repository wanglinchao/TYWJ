//
//  TYWJHotScenesRankingController.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/20.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJHotScenesRankingController.h"
#import "TYWJShoppingCarController.h"
#import "TYWJScenesRankingCell.h"


@interface TYWJHotScenesRankingController()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TYWJHotScenesRankingController
#pragma mark - lazi loading

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 290.f;
        [_tableView registerNib:[UINib nibWithNibName:@"TYWJScenesRankingCell" bundle:nil] forCellReuseIdentifier:TYWJScenesRankingCellID];
    }
    return _tableView;
}

#pragma mark - set up view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    self.navigationItem.title = @"热门景区排行榜";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"购物车" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClicked)];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJScenesRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJScenesRankingCellID forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
        {
            cell.rankingImg = @"IMG_0552";
        }
            break;
        case 1:
        {
            cell.rankingImg = @"IMG_0608";
        }
            break;
        case 2:
        {
            cell.rankingImg = @"IMG_0609";
        }
            break;
            
        default:
        {
            cell.rankingTitle = [NSString stringWithFormat:@"Top %ld",indexPath.row + 1];
        }
            break;
    }
    return cell;
}

#pragma mark - 按钮点击

- (void)rightItemClicked {
    ZLFuncLog;
    TYWJShoppingCarController *Vc = [[TYWJShoppingCarController alloc] init];
    [self.navigationController pushViewController:Vc animated:YES];
}

@end
