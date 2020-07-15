//
//  TYWJMessageViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/5/18.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJMessageDetailTableViewController.h"
#import "TYWJMessageDetailTableViewCell.h"
#import "ZLRefreshGifHeader.h"
#import "TYWJMessageModel.h"
@interface TYWJMessageDetailTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *showHeaderDic;

@end

@implementation TYWJMessageDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TYWJMessageModel *model = self.dataArr.firstObject;
    self.title = model.title;
    [self loadData];
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadData {
    TYWJMessageModel *model = self.dataArr.firstObject;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
        @"id":model.id,
        @"read":@(1),
        @"uid":[ZLUserDefaults objectForKey:TYWJLoginUidString],
    }];
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:POST WithPath:@"http://192.168.2.91:9005/loc/remind/modify" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        NSLog(@"成功");
    } WithFailurBlock:^(NSError *error) {
        
    } showLoad:NO];
}
- (void)setupView {
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJMessageDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:TYWJMessageDetailTableViewCellID];
    if (self.dataArr.count == 0) {
        self.tableView.hidden = YES;
        [self showNoDataViewWithDic:@{@"image":@"消息中心_空状态",@"title":@"暂无消息"}];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    TYWJMessageDetailTableViewCell *cell = [TYWJMessageDetailTableViewCell  cellForTableView:tableView];
    [cell confirgCellWithParam:[self.dataArr objectAtIndex:indexPath.row]];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
