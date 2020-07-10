//
//  TYWJTableViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/5/18.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJDriverPassengerListController.h"
#import "TYWJDriverPassegerCell.h"
#import "ZLRefreshGifHeader.h"
#import "TYWJPassengerInfo.h"
#import "TYWJDriverPassegerHeaderView.h"
@interface TYWJDriverPassengerListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation TYWJDriverPassengerListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray array];
    [self loadData];
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadData {
    NSArray *passengerArr = [self.dataDic objectForKey:@"assign_passenger_list"];
    if (passengerArr.count > 0) {
        [self.dataArr addObjectsFromArray:[TYWJPassengerInfo mj_objectArrayWithKeyValuesArray:passengerArr]];
        [self.tableView reloadData];
    }else{
//        [self showNoDataViewWithDic:@{}];
    }
}
- (void)setupView {

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TYWJDriverPassegerHeaderView *view = [[TYWJDriverPassegerHeaderView alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth, 98)];
    [view confirgCellWithParam:self.dataDic];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 98;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TYWJDriverPassegerCell *cell = [TYWJDriverPassegerCell cellForTableView:tableView];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    [cell confirgCellWithParam:[self.dataArr objectAtIndex:indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
