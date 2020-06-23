//
//  TYWJMessageViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/5/18.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJMessageViewController.h"
#import "TYWJMessageTableViewCell.h"
#import "ZLRefreshGifHeader.h"
#import "TYWJMessageDetailTableViewController.h"
@interface TYWJMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableDictionary *showHeaderDic;

@end

@implementation TYWJMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    [self loadData];
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadData {
    self.showHeaderDic = [[NSMutableDictionary alloc] init];
    self.dataArr  = [NSMutableArray array];
//    NSArray *arr = @[@[@[@"1",@"2",@"3"],@[@"1"]],@[@[@"4"]],@[@[@"5",@"6"]]];
//    [self.dataArr addObjectsFromArray:arr];
}
- (void)setupView {
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJMessageTableViewCell class]) bundle:nil] forCellReuseIdentifier:TYWJMessageTableViewCellID];
    if (self.dataArr.count == 0) {
        self.tableView.hidden = YES;
        [self showNoDataViewWithDic:@{@"image":@"消息中心_空状态",@"title":@"暂无消息"}];
    }
    ZLRefreshGifHeader *mjHeader = [ZLRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _tableView.mj_header = mjHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    TYWJMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJMessageTableViewCellID forIndexPath:indexPath];
    return cell;
 
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TYWJMessageDetailTableViewController *vc = [TYWJMessageDetailTableViewController new];
    [TYWJCommonTool pushToVc:vc];
}

@end
