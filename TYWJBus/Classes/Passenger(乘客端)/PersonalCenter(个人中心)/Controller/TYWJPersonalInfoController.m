//
//  TYWJPersonalInfoController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/24.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJPersonalInfoController.h"
#import "TYWJPersonalInfoPlist.h"
#import "TYWJPersonalInfoCell.h"
#import "TYWJLoginTool.h"

#import "ZLPopoverView.h"

#import <MJExtension.h>

@interface TYWJPersonalInfoController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* plistArr */
@property (strong, nonatomic) NSArray *plistArray;

@end

@implementation TYWJPersonalInfoController
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.zl_y = 0;
//        _tableView.zl_height = self.view.zl_height - kNavBarH;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.rowHeight = 50.f;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJPersonalInfoCell class]) bundle:nil] forCellReuseIdentifier:TYWJPersonalInfoCellID];
    }
    return _tableView;
}
#pragma mark - set up view
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
    self.navigationItem.title = @"个人信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveInfoClicked)];
    [self.view addSubview:self.tableView];
}

- (void)loadPlist {
    NSString *path = [[NSBundle mainBundle] pathForResource:TYWJPersonalCenterPlist ofType:nil];
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:path];
    self.plistArray = [TYWJPersonalInfoPlist mj_objectArrayWithKeyValuesArray:dataArr];
    if (self.plistArray) {
        [self.view addSubview:self.tableView];
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.plistArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 90;
    }
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJPersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJPersonalInfoCellID forIndexPath:indexPath];
    TYWJPersonalInfoPlist *plist = self.plistArray[indexPath.row];
    
    cell.plist = plist;
    if (plist.index.intValue == 0) {
        cell.checkAvatarClicked = ^(UIImage *img,UIButton *sender){
            //查看大图
            [[ZLPopoverView sharedInstance] showCheckAvatarViewWithPicture:img sender:sender];
        };
    } else if (plist.index.intValue == 1) {
        cell.info = [TYWJLoginTool sharedInstance].nickname;
    }else if (plist.index.intValue == 2) {
        cell.info = [TYWJLoginTool sharedInstance].phoneNum;
    }else if (plist.index.intValue == 3) {
        cell.info = [TYWJLoginTool sharedInstance].phoneNum;
    }
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    TYWJPersonalInfoPlist *plist = self.plistArray[indexPath.row];
    switch (plist.index.intValue) {
        case 0:
            {
                [[ZLPopoverView sharedInstance] showChangeAvatarView];
                
            }
            break;
        case 3:
        {
            //换性别点击
        }
            break;

        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
#pragma makr - 按钮点击

- (void)saveInfoClicked {
    ZLFuncLog;
    if ([[TYWJLoginTool sharedInstance].nickname isEqualToString:@""]) {
        [MBProgressHUD zl_showError:@"请输入用户名"];
        return;
    }
    [[TYWJLoginTool sharedInstance] saveLoginInfo];
    [MBProgressHUD zl_showSuccess:@"保存成功"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - others
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[TYWJLoginTool sharedInstance] getLoginInfo];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
