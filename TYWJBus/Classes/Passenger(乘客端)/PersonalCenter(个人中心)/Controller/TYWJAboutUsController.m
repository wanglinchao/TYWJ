//
//  TYWJAboutUsController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/26.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJAboutUsController.h"
#import "TYWJAboutUsCell.h"


@interface TYWJAboutUsController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* plistArray */
@property (strong, nonatomic) NSArray *plistArray;

@end

@implementation TYWJAboutUsController
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 50.f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJAboutUsCell class]) bundle:nil] forCellReuseIdentifier:TYWJAboutUsCellID];
        
        UIImageView *headerImgView = [[UIImageView alloc] init];
        headerImgView.image = [UIImage imageNamed:@"AppIcon167*167"];
        headerImgView.contentMode = UIViewContentModeCenter;
        headerImgView.backgroundColor = [UIColor clearColor];
        headerImgView.zl_height = 200.f;
        _tableView.tableHeaderView = headerImgView;
        
        
    }
    return _tableView;
}

#pragma mark -

- (void)dealloc {
    ZLFuncLog;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self loadPlist];
}

- (void)setupView {
    self.navigationItem.title = @"关于我们";
    
    [self.view addSubview:self.tableView];
}

- (void)loadPlist {
    NSString *path = [[NSBundle mainBundle] pathForResource:TYWJAboutUsPlist ofType:nil];
    if (path) {
        self.plistArray = [NSArray arrayWithContentsOfFile:path];
    }
    if (self.plistArray) {
        [self.tableView reloadData];
    }
}
#pragma mark - delegate

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.plistArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJAboutUsCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJAboutUsCellID forIndexPath:indexPath];
    NSString *text = self.plistArray[indexPath.row];
    if (indexPath.row == 1) {
        text = [NSString stringWithFormat:@"官方网站:%@",text];
    }
    if (indexPath.row == 2) {
        
        text = [text stringByAppendingString:[TYWJCommonTool sharedTool].currentVersion];
    }
    cell.text = text;
    return cell;
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 1) {
//        WeakSelf;
//        [[ZLPopoverView sharedInstance] showTipsViewWithTips:@"是否用safari打开网站?" leftTitle:@"下次吧" rightTitle:@"好的" RegisterClicked:^{
//            [TYWJCommonTool jumpToSafariWithUrl:weakSelf.plistArray[indexPath.row]];
//        }];
//
//    }
//}

@end
