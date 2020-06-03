//
//  TYWJPersonalInfoController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/24.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJPersonalInfoController.h"
#import "TYWJPersonalInfoCell.h"
#import "TYWJLoginTool.h"
#import "TYWJModifyUsernameViewController.h"
#import "ZLPopoverView.h"

#import <MJExtension.h>

@interface TYWJPersonalInfoController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;


@end

@implementation TYWJPersonalInfoController
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.zl_y = 0;
//        _tableView.zl_height = self.view.zl_height - kNavBarH;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
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
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setupView];

}
- (void)setupView {
    self.navigationItem.title = @"个人信息";
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
//    [self modifyAvatar];
}
- (void)modifyAvatar{
    NSDictionary *param = @{@"uid": [ZLUserDefaults objectForKey:TYWJLoginUidString],@"avatar":@"https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png"};
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:POST WithPath:@"/userinfo/update/avatar" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        //设置用户信息

    } WithFailurBlock:^(NSError *error) {
        [MBProgressHUD zl_showError:@"保存失败"];
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 90;
    }
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJPersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJPersonalInfoCellID forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.info = @{@"title":@"头像",@"showArr":@YES,@"subTitle":@"",@"showImage":@YES};
        cell.checkAvatarClicked = ^(UIImage *img,UIButton *sender){
            //查看大图
            [[ZLPopoverView sharedInstance] showCheckAvatarViewWithPicture:img sender:sender];
        };
    } else if (indexPath.row == 1) {
        cell.info = @{@"title":@"昵称",@"showArr":@YES,@"subTitle":[TYWJLoginTool sharedInstance].nickname,@"showImage":@NO};
    }else if (indexPath.row == 2) {
        cell.info = @{@"title":@"用户ID",@"showArr":@NO,@"subTitle":[TYWJLoginTool sharedInstance].uid,@"showImage":@NO};
    }else if (indexPath.row == 3) {
        cell.info = @{@"title":@"手机号码",@"showArr":@NO,@"subTitle":[TYWJLoginTool sharedInstance].phoneNum,@"showImage":@NO};
    }
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    switch (indexPath.row) {
        case 0:
            {
                [[ZLPopoverView sharedInstance] showChangeAvatarView];
                
            }
            break;
            case 1:
            {
                TYWJModifyUsernameViewController *vc = [[TYWJModifyUsernameViewController alloc] init];
                [TYWJCommonTool pushToVc:vc];
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


#pragma mark - others
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[TYWJLoginTool sharedInstance] getLoginInfo];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
