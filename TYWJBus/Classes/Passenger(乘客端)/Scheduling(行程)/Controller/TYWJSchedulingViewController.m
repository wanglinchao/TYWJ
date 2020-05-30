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
    // Do any additional setup after loading the view from its nib.
}
- (void)loadData {
    self.showHeaderDic = [[NSMutableDictionary alloc] init];
    self.dataArr  = [NSMutableArray array];
    NSArray *arr = @[@[@[@"1",@"2",@"3"],@[@"1"]],@[@[@"4"]],@[@[@"5",@"6"]]];
    [self.dataArr addObjectsFromArray:arr];
}
- (void)setupView {
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJSchedulingTableViewCell class]) bundle:nil] forCellReuseIdentifier:TYWJSchedulingTableViewCellID];
    if (self.dataArr.count == 0) {
        self.tableView.hidden = YES;
        [self showNoDataViewWithDic:@{@"image":@"行程_空状态",@"title":@"你还没有待消费的行程哦，马上买一个吧"}];
    }
    ZLRefreshGifHeader *mjHeader = [ZLRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _tableView.mj_header = mjHeader;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"fff";
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TYWJSectionHeadView *header = [[[NSBundle mainBundle] loadNibNamed:@"TYWJSectionHeadView" owner:self options:nil] lastObject];
    if ([[self.showHeaderDic objectForKey:[NSString stringWithFormat:@"%ld",section]] boolValue]) {
        header.arrImage.image = [UIImage imageNamed:@"行程_箭头展开"];
    } else {
        header.arrImage.image = [UIImage imageNamed:@"行程_箭头收起"];
    }
    header.citynameL.text = @"成都";
    WeakSelf;
    header.buttonSeleted = ^{
        BOOL hide = [[weakSelf.showHeaderDic objectForKey:[NSString stringWithFormat:@"%ld",section]] boolValue];
        [weakSelf.showHeaderDic setValue:[NSNumber numberWithBool:!hide] forKey:[NSString stringWithFormat:@"%ld",section]];
        [weakSelf.tableView reloadData];

    };
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
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
    if (indexPath.row == 0) {
        [cell showHeaderView:YES];
    }else {
        [cell showHeaderView:NO];
    }
    cell.backgroundColor = randomColor;
    return cell;
 
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TYWJSchedulingDetialViewController *vc = [[TYWJSchedulingDetialViewController alloc] init];
    [TYWJCommonTool pushToVc:vc];
}

@end
