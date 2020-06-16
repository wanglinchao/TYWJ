//
//  TYWJMeController.h
//  TYWJBus
//
//  Created by tywj on 2020/5/21.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJMeController.h"
#import "TYWJSideHeaderView.h"
#import "TYWJUserBasicInfo.h"
#import "TYWJLoginTool.h"
#import "TYWJPersonalInfoController.h"
#import "ZLPopoverView.h"
#import "TYWJMyOrderViewController.h"
#import "WRNavigationBar.h"
#import "ZLPOPAnimation.h"
#import "TYWJSettingViewController.h"
#import "TYWJApplyLineViewController.h"
#import "TYWJFeedbackViewController.h"
#import <MJExtension.h>
#import "TYWJDirveShowCodeVC.h"

@interface TYWJMeController ()
@property (weak, nonatomic) IBOutlet UIView *headinView;
@property (weak, nonatomic) TYWJSideHeaderView *headView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopHeight;
@end

@implementation TYWJMeController
- (TYWJSideHeaderView *)headView {
    if (!_headView) {
        TYWJSideHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"TYWJSideHeaderView" owner:self options:nil] lastObject];
        headerView.frame = _headinView.bounds;
        _headView = headerView;
    }
    return _headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageTopHeight.constant = kNavBarH - 44;
    self.title = @"个人中心";
    [self.headinView addSubview:[self headView]];
    [self setupView];
    [self addNotis];
}
#pragma mark - 通知
- (void)addNotis {
    [ZLNotiCenter addObserver:self selector:@selector(setDefaultSettings) name:TYWJModifyUserInfoNoti object:nil];
}
- (void)removeNotis {
    [ZLNotiCenter removeObserver:self name:TYWJModifyUserInfoNoti object:nil];
}

- (IBAction)orderAction:(UIButton *)sender {
    [TYWJGetCurrentController showLoginViewWithSuccessBlock:^{
        [TYWJCommonTool pushToVc:[TYWJMyOrderViewController new]];
    }];
    
}

- (IBAction)applicationRoute:(id)sender {
    TYWJApplyLineViewController *applyVC = [[TYWJApplyLineViewController alloc] init];
    [self.navigationController pushViewController:applyVC animated:YES];
}

- (IBAction)feedbackAction:(id)sender {
        [TYWJGetCurrentController showLoginViewWithSuccessBlock:^{
        TYWJFeedbackViewController *vc = [[TYWJFeedbackViewController alloc] init];
        [TYWJCommonTool pushToVc:vc];
    }];
    
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
- (IBAction)showDriveCode:(id)sender {
    [TYWJCommonTool pushToVc:[TYWJDirveShowCodeVC new]];
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
    [self setDefaultSettings];
}

- (void)setDefaultSettings {
    //这里需要登录返回信息
    TYWJUserBasicInfo *userBasicInfo = [[TYWJUserBasicInfo alloc] init];
    if (LOGINSTATUS) {
        userBasicInfo.uid = [TYWJLoginTool sharedInstance].uid;
        userBasicInfo.nickname = [TYWJLoginTool sharedInstance].nickname;
        userBasicInfo.phoneNum = [TYWJLoginTool sharedInstance].phoneNum;
    }else{
        userBasicInfo.uid = @"";
        userBasicInfo.nickname = @"未登陆";
        userBasicInfo.phoneNum = @"";
        userBasicInfo.avatarImage = @"";
    }
    self.headView.userBasicInfo = userBasicInfo;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
//    [WRNavigationBar wr_setDefaultNavBarBarTintColor:[UIColor clearColor]];

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TYWJLoginTool checkUniqueLoginWithVC:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
//    [WRNavigationBar wr_setDefaultNavBarBarTintColor:ZLNavBgColor];

}

@end
