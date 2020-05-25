//
//  TYWJMeController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJMeController.h"
#import "TYWJSideHeaderView.h"
#import "TYWJUserBasicInfo.h"
#import "TYWJLoginTool.h"
#import "TYWJTabBarController.h"
#import "TYWJPersonalInfoController.h"
#import "ZLPopoverView.h"
#import "TYWJNavigationController.h"
#import "TYWJZYXWebController.h"
#import "ZLScrollTitleViewController.h"
#import <WRNavigationBar.h>

#import "TYWJSideTableModel.h"
#import "TYWJSideCell.h"
#import "ZLPOPAnimation.h"


#import "TYWJMyRouteController.h"
#import "TYWJMyTicketController.h"
#import "TYWJCouponController.h"
#import "TYWJActivityController.h"
#import "TYWJApplyRouteController.h"
#import "TYWJSettingViewController.h"

#import "TYWJApplyLineViewController.h"
#import "TYWJMessageCenterBaseController.h"
#import "TYWJFeedbackViewController.h"

#import <MJExtension.h>

//extern void _objc_autoreleasePoolPrint(void);

#pragma mark - 常量
static CGFloat const kAnimTimeInterval = 0.35f;
static CGFloat const kAnimSpeed = 15.f;
static CGFloat const kHeaderViewH = 160.f;

#pragma mark - enum

typedef enum : NSUInteger {
    TYWJSideTableTypeMyRoute = 0,
    TYWJSideTableTypeMyTicket,
    TYWJSideTableTypeCoupon,
    TYWJSideTableTypeActivity,
    TYWJSideTableTypeApplyRoute,
    TYWJSideTableTypeCustomerService,
    TYWJSideTableTypeMore,
    TYWJSideTableTypeOrder
} TYWJSideTableType;

@interface TYWJMeController ()<UITableViewDelegate,UITableViewDataSource>
/* showingView */
@property (strong, nonatomic) UIView *showingView;
/* headerView */
@property (strong, nonatomic) UIImageView *headerView;
/* headView */
@property (weak, nonatomic) IBOutlet UIView *headinView;
@property (weak, nonatomic) TYWJSideHeaderView *headView;

/* tableview */
@property (strong, nonatomic) UITableView *tableView;
/* effectView */
@property (strong, nonatomic) UIVisualEffectView *effectView;
/* sideTableModel */
@property (strong, nonatomic) NSArray *sideTableModels;
/* 要显示的view的宽度 */
@property (assign, nonatomic) CGFloat showingViewW;

@end

@implementation TYWJMeController
#pragma mark - 懒加载
- (UIView *)showingView {
    if (!_showingView) {
        UIView *showingView = [[UIView alloc] init];
        showingView.frame = CGRectMake(-self.showingViewW, 0, self.showingViewW, self.view.zl_height);
        showingView.backgroundColor = [UIColor whiteColor];
        _showingView = showingView;
    }
    return _showingView;
}


- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffectView.frame = self.view.bounds;
        visualEffectView.alpha = 0;
        _effectView = visualEffectView;
    }
    return _effectView;
}
- (TYWJSideHeaderView *)headView {
    if (!_headView) {
        TYWJSideHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"TYWJSideHeaderView" owner:self options:nil] lastObject];
        headerView.frame = _headinView.bounds;
        _headView = headerView;
    }
    return _headView;
}

#pragma mark - setup view
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.headinView addSubview:[self headView]];
//    self.navigationController.navigationBarHidden = YES;
//        [self wr_setNavBarBackgroundAlpha:1];

//    [self wr_setNavBarBackgroundImage:[UIImage imageNamed:@"nav_backImage"]];
    // Do any additional setup after loading the view.
    [self setupView];
    [self loadSideModels];
    [self animToShowView];
    [self addNotis];
//    _objc_autoreleasePoolPrint;
//    _objc_autoreleasePoolPrint;
}
#pragma mark - 通知
- (void)addNotis {
    [ZLNotiCenter addObserver:self selector:@selector(setDefaultSettings) name:TYWJModifyUserInfoNoti object:nil];

}

- (void)removeNotis {
    [ZLNotiCenter removeObserver:self name:TYWJModifyUserInfoNoti object:nil];

}
- (IBAction)messageAction:(id)sender {
    ZLFuncLog;
    TYWJMessageCenterBaseController *vc = [[TYWJMessageCenterBaseController alloc] init];
    [TYWJCommonTool pushToVc:vc];
}
- (IBAction)orderAction:(UIButton *)sender {
    ZLScrollTitleViewController *vc = [[TYWJCommonTool sharedTool] setMyOrderVc];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)applicationRoute:(id)sender {
    [self loadAppliedData];
}
- (IBAction)feedbackAction:(id)sender {
    ZLFuncLog;
    TYWJFeedbackViewController *vc = [[TYWJFeedbackViewController alloc] init];
    [TYWJCommonTool pushToVc:vc];
}
- (IBAction)serviceAction:(id)sender {
    [[ZLPopoverView sharedInstance] showTipsViewWithTips:@"联系客服 400-82-1717" leftTitle:@"取消" rightTitle:@"确定" RegisterClicked:^{
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:400821717"]];
    }];
}
- (IBAction)settingAction:(id)sender {
    TYWJSettingViewController *settingVc = [[TYWJSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVc animated:YES];
}

- (IBAction)personInfoAction:(id)sender {
    TYWJPersonalInfoController *piVc= [[TYWJPersonalInfoController alloc] init];
      [self.navigationController pushViewController:piVc animated:YES];
}
- (void)setupView {
    self.headView.viewClicked = ^{
        [TYWJGetCurrentController showLoginViewWithSuccessBlock:^{
                        TYWJPersonalInfoController *piVc= [[TYWJPersonalInfoController alloc] init];
            [self.navigationController pushViewController:piVc animated:YES];
                   
        }];
        return;
    };
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJSideCell class]) bundle:nil] forCellReuseIdentifier: TYWJSideCellID];
    [self setDefaultSettings];
}

- (void)loadSideModels {
    NSString *path = [[NSBundle mainBundle] pathForResource:TYWJSideColumn0Plist ofType:nil];
//    if ([@"false" isEqualToString:[TYWJCommonTool sharedTool].isCheckingApp]) {
//        path = [[NSBundle mainBundle] pathForResource:TYWJSideColumn0Plist ofType:nil];
//    }
    if (path) {
        NSArray *pArr = [NSArray arrayWithContentsOfFile:path];
        if (!pArr) return;
        self.sideTableModels = [TYWJSideTableModel mj_objectArrayWithKeyValuesArray:pArr];
        if (!self.sideTableModels) return;
        [self.tableView reloadData];
        
    }
}
- (void)setDefaultSettings {
    //这里需要登录返回信息
    TYWJUserBasicInfo *userBasicInfo = [[TYWJUserBasicInfo alloc] init];
    if (LOGINSTATUS) {
        userBasicInfo.avatarImage = [TYWJLoginTool sharedInstance].avatarString;
        userBasicInfo.uid = [TYWJLoginTool sharedInstance].uid;
        userBasicInfo.nickname = [TYWJLoginTool sharedInstance].nickname;
        userBasicInfo.phoneNum = [TYWJLoginTool sharedInstance].phoneNum;
    }else{
        userBasicInfo.avatarImage = @"icon_my_header";
        userBasicInfo.uid = @"";
        userBasicInfo.nickname = @"未登陆";
        userBasicInfo.phoneNum = @"";
    }

    self.headView.userBasicInfo = userBasicInfo;
    
}



#pragma mark - 显示view时的操作

/**
 动画显示view
 */
- (void)animToShowView {
    CGRect toF = self.showingView.frame;
    toF.origin.x = 0;
    [ZLPOPAnimation animationWithView:self.showingView fromF:self.showingView.frame toF:toF springSpeed:kAnimSpeed springBounciness:0];
    WeakSelf;
    [UIView animateWithDuration:kAnimTimeInterval animations:^{
        weakSelf.effectView.alpha = TYWJEffectViewAlpha;
    }];
}

/**
 动画隐藏view
 */
- (void)animHideViewCompletion:(void (^)(void))completion {
    CGRect toF = self.showingView.frame;
    toF.origin.x = -self.showingViewW;
    [ZLPOPAnimation animationWithView:self.showingView fromF:self.showingView.frame toF:toF springSpeed:kAnimSpeed springBounciness:0 completionBlock:^{
        if (completion) {
            completion();
        }
    }];
    [UIView animateWithDuration:kAnimTimeInterval animations:^{
        self.effectView.alpha = 0;
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

    if ([TYWJLoginTool sharedInstance].userType == TYWJLoginTypePassenger) {
        if ([TYWJLoginTool sharedInstance].avatarImg) {
            self.headView.avatarImageView.image = [TYWJLoginTool sharedInstance].avatarImg;
            
        }
        if ([TYWJLoginTool sharedInstance].nickname) {
            self.headView.nickNameLabel.text = [TYWJLoginTool sharedInstance].nickname;
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [TYWJLoginTool checkUniqueLoginWithVC:self];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}




#pragma mark - 加载数据
- (void)loadAppliedData {
    TYWJApplyLineViewController *applyVC = [[TYWJApplyLineViewController alloc] init];
    [self.navigationController pushViewController:applyVC animated:YES];
}

@end
