//
//  TYWJDriverMeController.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/30.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJDriverMeController.h"
#import "TYWJLogMilesController.h"
#import "TYWJSideHeaderView.h"
#import "TYWJLoginTool.h"
#import "TYWJNavigationController.h"
#import "TYWJPersonalInfoController.h"
#import "TYWJVerifyCodeController.h"
#import "TYWJAboutUsController.h"
#import "TYWJChooseUserTypeController.h"
#import "TYWJDriverSalaryController.h"
#import "TYWJCheckCommentController.h"
#import "TYWJMoreCell.h"
#import "TYWJUserBasicInfo.h"
#import "TYWJMoreCellList.h"
#import "ZLPopoverView.h"
#import "AppDelegate.h"
#import <WRNavigationBar.h>
#import <MJExtension.h>

static CGFloat const kHeaderViewH = 160.f;
static CGFloat const kRowH = 46.f;

@interface TYWJDriverMeController ()<UITableViewDelegate,UITableViewDataSource>

/* headerView */
@property (strong, nonatomic) UIImageView *headerView;
/* headView */
@property (weak, nonatomic) TYWJSideHeaderView *headView;
/* tableview */
@property (strong, nonatomic) UITableView *tableView;
/* cellLists */
@property (strong, nonatomic) NSArray *cellLists;

@end

@implementation TYWJDriverMeController
- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kHeaderViewH,self.view.zl_width , kHeaderViewH)];
        _headerView.userInteractionEnabled = YES;
        _headerView.image = [UIImage imageNamed:@"IMG_0607"];
        TYWJSideHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"TYWJSideHeaderView" owner:self options:nil] lastObject];
        headerView.frame = _headerView.bounds;
        headerView.backgroundColor = [UIColor whiteColor];
        headerView.arrowIcon.hidden = YES;
        //ZLColorWithRGB(241, 245, 248);
        _headView = headerView;
        [_headerView addSubview:headerView];
    }
    return _headerView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor whiteColor];//ZLColorWithRGB(241, 245, 248);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight  = kRowH;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [tableView addSubview:self.headerView];
        tableView.contentInset = UIEdgeInsetsMake(kHeaderViewH - kNavBarH, 0, 0, 0);
        _tableView = tableView;
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self loadPlist];
}


- (void)setupView {
    [self wr_setNavBarBackgroundAlpha:0];
    [self wr_setNavBarShadowImageHidden:YES];
    [self.view addSubview:self.tableView];
    
    WeakSelf;
//    self.headView.viewClicked = ^{
//        //headerView 点击
//        TYWJPersonalInfoController *piVc= [[TYWJPersonalInfoController alloc] init];
//        [weakSelf.navigationController pushViewController:piVc animated:YES];
//
//    };
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJMoreCell class]) bundle:nil] forCellReuseIdentifier: TYWJMoreCellID];
    
    CGFloat footerH = 84.f;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.zl_width, footerH)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    
    UIButton *footerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, footerView.zl_height - 44.f, self.view.zl_width, 44.f)];
    footerBtn.backgroundColor = [UIColor whiteColor];
    [footerBtn setTitle:@"安全退出" forState:UIControlStateNormal];
    footerBtn.titleLabel.font = [UIFont systemFontOfSize:20.f];
    [footerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [footerBtn addTarget:self action:@selector(quitClicked) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:footerBtn];
    
    [self setDefaultSettings];
}

- (void)setDefaultSettings {
    //这里需要登录返回信息
    TYWJUserBasicInfo *userBasicInfo = [[TYWJUserBasicInfo alloc] init];
    userBasicInfo.avatarImage = @"icon_my_header";
    userBasicInfo.nickname = [TYWJLoginTool sharedInstance].nickname;
    userBasicInfo.phoneNum = [TYWJLoginTool sharedInstance].phoneNum;
    if ([TYWJLoginTool sharedInstance].driverInfo) {
        userBasicInfo.nickname = [TYWJLoginTool sharedInstance].driverInfo.name;
        userBasicInfo.phoneNum = [TYWJLoginTool sharedInstance].driverInfo.tel;
    }
    self.headView.userBasicInfo = userBasicInfo;
}

#pragma mark - 加载数据
- (void)loadPlist {
    NSString *path = path = [[NSBundle mainBundle] pathForResource:TYWJDriverMoreCellListPlist ofType:nil];
    
    NSArray *cellLists = [NSArray arrayWithContentsOfFile:path];
    if (cellLists) {
        self.cellLists = [TYWJMoreCellList mj_objectArrayWithKeyValuesArray:cellLists];
        if (self.cellLists) {
            [self.tableView reloadData];
        }
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJMoreCellID forIndexPath:indexPath];
    TYWJMoreCellList *cellList = self.cellLists[indexPath.row];
    cell.cellList = cellList;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJMoreCellList *cellList = self.cellLists[indexPath.row];
    switch (cellList.index) {
        case 0:
        {
            //密码管理
            TYWJVerifyCodeController *verifyVc = [[TYWJVerifyCodeController alloc] init];
            verifyVc.type = TYWJVerifyCodeControllerTypeForgetPwd;
            verifyVc.isDriver = YES;
            [self.navigationController pushViewController:verifyVc animated:YES];
        }
            break;
        case 1:
        {
            //今日提成
            TYWJDriverSalaryController *vc = [[TYWJDriverSalaryController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            //行车记录
            if ([self judgeIsD]) {
                
            }
            
        }
            break;
        case 3:
        {
            //关于我们
            TYWJAboutUsController *aboutUsVc = [[TYWJAboutUsController alloc] init];
            [self.navigationController pushViewController:aboutUsVc animated:YES];
        }
            break;
        case 4:
        {
            //路线偏移
        }
            break;
        case 5:
        {
            //趟次绩效
            if ([self judgeIsD]) {
                
            }
        }
            break;
        case 6:
        {
            //录入油耗
            if ([self judgeIsD]) {
                TYWJLogMilesController *milesVc = [[TYWJLogMilesController alloc] init];
                [self.navigationController pushViewController:milesVc animated:YES];
            }
        }
            break;
        case 7:
        {
            //评价
            TYWJCheckCommentController *commentVc = [[TYWJCheckCommentController alloc] init];
            commentVc.type = TYWJCheckCommentTypeComment;
            [self.navigationController pushViewController:commentVc animated:YES];
        }
            break;
        case 8:
        {
            //投诉
            TYWJCheckCommentController *complaintVc = [[TYWJCheckCommentController alloc] init];
            complaintVc.type = TYWJCheckCommentTypeComplaint;
            [self.navigationController pushViewController:complaintVc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)judgeIsD {
    if ([TYWJLoginTool sharedInstance].driverInfo) {
        return YES;
    }
    [MBProgressHUD zl_showAlert:@"暂未开放此功能" afterDelay:2.f];
    return NO;
}

#pragma mark - scrollViewDidScroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 改变图片框的大小 (上滑的时候不改变)
    // 这里不能使用offsetY，因为当（offsetY < LIMIT_OFFSET_Y）的时候，y = LIMIT_OFFSET_Y 不等于 offsetY
    CGFloat newOffsetY = scrollView.contentOffset.y;
    if (newOffsetY < -kHeaderViewH)
    {
        self.headerView.frame = CGRectMake(0, newOffsetY, ZLScreenWidth, -newOffsetY);
    }
    
    ZLLog(@"newOffsetY---++%f",newOffsetY);
}


#pragma mark - 按钮点击

/**
 退出登录按钮
 */
- (void)quitClicked {
    ZLFuncLog;
    [[ZLPopoverView sharedInstance] showTipsViewWithTips:@"是否确定退出登录?" leftTitle:@"取消" rightTitle:@"确定" RegisterClicked:^{
        TYWJChooseUserTypeController *chooseVc = [[TYWJChooseUserTypeController alloc] init];
        TYWJNavigationController *nav = [[TYWJNavigationController alloc] initWithRootViewController:chooseVc];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.window.rootViewController = nav;
        [TYWJCommonTool animShowNextViewWithController:nav v:self.view circleView:nil];
        
        
        [[TYWJLoginTool sharedInstance] delLoginInfo];
//        [MBProgressHUD zl_showSuccess:@"退出成功"];
    }];
    
}

@end
