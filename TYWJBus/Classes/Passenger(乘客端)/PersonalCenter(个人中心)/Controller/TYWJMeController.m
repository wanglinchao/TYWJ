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
#import "ZLScrollTitleViewController.h"
#import <WRNavigationBar.h>
#import "ZLPOPAnimation.h"
#import "TYWJSettingViewController.h"
#import "TYWJApplyLineViewController.h"
#import "TYWJFeedbackViewController.h"
#import <MJExtension.h>

@interface TYWJMeController ()
@property (weak, nonatomic) IBOutlet UIView *headinView;
@property (weak, nonatomic) TYWJSideHeaderView *headView;
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
    ZLScrollTitleViewController *vc = [[TYWJCommonTool sharedTool] setMyOrderVc];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)applicationRoute:(id)sender {
    TYWJApplyLineViewController *applyVC = [[TYWJApplyLineViewController alloc] init];
    [self.navigationController pushViewController:applyVC animated:YES];
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
    [self setDefaultSettings];
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

@end
