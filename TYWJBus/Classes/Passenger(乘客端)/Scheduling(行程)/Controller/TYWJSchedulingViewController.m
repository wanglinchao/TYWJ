//
//  TYWJSchedulingViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/5/18.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJSchedulingViewController.h"
#import "TYWJSectionHeadView.h"
#import "TYWJSchedulingTableViewCell.h"
#import "ZLRefreshGifHeader.h"
#import "TYWJSchedulingDetialViewController.h"
#import "TYWJTripList.h"
@interface TYWJSchedulingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableDictionary *showHeaderDic;

@end

@implementation TYWJSchedulingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"行程";
    [self loadData];
    [self setupView];
    self.showHeaderDic = [[NSMutableDictionary alloc] init];
    self.dataArr  = [NSMutableArray array];

    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)loadData {
//    NSArray *arr = @[@[@[@"1",@"2",@"3"],@[@"1"]],@[@[@"4"]],@[@[@"5",@"6"]]];
//    [self.dataArr addObjectsFromArray:arr];
    
    
    NSDictionary *param = @{
        @"uid": [ZLUserDefaults objectForKey:TYWJLoginUidString],
         @"line_Date": [TYWJCommonTool getCurrcenTimeStr],
          @"days": @10,
    };
    WeakSelf;
    
    
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.91:9005/ticket/orderinfo/search/trip" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        NSArray *dataArr = [dic objectForKey:@"data"];
        if ([dataArr count] > 0) {
            NSArray *arr = @[@[[TYWJTripList mj_objectArrayWithKeyValuesArray:dataArr]]];
            self.dataArr = [NSMutableArray arrayWithArray:arr];
            [self.view addSubview:self.tableView];
            [self.tableView reloadData];
        } else {
            self.tableView.hidden = YES;
            [self showNoDataViewWithDic:@{@"image":@"行程_空状态",@"title":@"你还没有待消费的行程哦，马上买一个吧"}];
        }
    } WithFailurBlock:^(NSError *error) {
        [weakSelf showRequestFailedViewWithImg:@"icon_no_network" tips:@"网络差，请稍后再试" btnTitle:nil btnClicked:^{
            [self loadData];
        }];
    }];
}
- (void)setupView {
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJSchedulingTableViewCell class]) bundle:nil] forCellReuseIdentifier:TYWJSchedulingTableViewCellID];

    ZLRefreshGifHeader *mjHeader = [ZLRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _tableView.mj_header = mjHeader;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BOOL hide = [[self.showHeaderDic objectForKey:[NSString stringWithFormat:@"%ld",section]] boolValue];
    if (hide) {
        return 0;
    }
    NSArray *arr = [self.dataArr objectAtIndex:section];
    NSInteger num = 0;
    for (NSArray *dataa in arr) {
        num += [dataa count];
    }
    return num;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 204;
    }
    return 204 - 50;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    TYWJSchedulingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJSchedulingTableViewCellID forIndexPath:indexPath];
    [cell confirgCellWithModel:[self.dataArr[0][0] objectAtIndex:indexPath.row]];
    if (indexPath.row == 0) {
        [cell showHeaderView:YES];
    }else {
        [cell showHeaderView:NO];
    }
    return cell;
 
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TYWJSchedulingDetialViewController *vc = [[TYWJSchedulingDetialViewController alloc] init];
    vc.model = [self.dataArr[0][0] objectAtIndex:indexPath.row];
    [TYWJCommonTool pushToVc:vc];
}

@end
