//
//  TYWJTableViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/5/18.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJMyApplyController.h"
#import "TYWJApplyListCell.h"
#import "ZLRefreshGifHeader.h"
#import "TYWJApplyListCell.h"

@interface TYWJMyApplyController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation TYWJMyApplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"行程";
    [self loadData];
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadData {
    self.dataArr  = [NSMutableArray array];
    NSArray *arr = @[@[@[@"1",@"2",@"3"],@[@"1"]],@[@[@"4"]],@[@[@"5",@"6"]]];
    [self.dataArr addObjectsFromArray:arr];
}
- (void)setupView {
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
    return 80;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    TYWJApplyListCell *cell = [TYWJApplyListCell cellForTableView:tableView];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
//    TYWJApplyList *model = self.dataArray[indexPath.row];
//    cell.applyListInfo = model.applyListInfo;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
