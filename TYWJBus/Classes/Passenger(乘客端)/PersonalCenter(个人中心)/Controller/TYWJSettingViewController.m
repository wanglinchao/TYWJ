//
//  TYWJSettingViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/5/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJSettingViewController.h"
#import "TYWJAboutUsController.h"
#import "TYWJCarProtocolController.h"
#import "ZLPopoverView.h"
#import <MJExtension.h>
@interface TYWJSettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@end

@implementation TYWJSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"设置"];
  if (LOGINSTATUS) {
        self.logoutBtn.hidden = NO;
    }else {
        self.logoutBtn.hidden = YES;
    }
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)handBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 200:
        {
            //用户协议
            TYWJCarProtocolController *protocolVc = [[TYWJCarProtocolController alloc] init];
            protocolVc.type = TYWJCarProtocolControllerTypeCarProtocol;
            [self.navigationController pushViewController:protocolVc animated:YES];
        }
            break;
        case 201:
     {
         //关于我们
         TYWJAboutUsController *aboutUsVc = [[TYWJAboutUsController alloc] init];
         [self.navigationController pushViewController:aboutUsVc animated:YES];
     }
            break;
        default:
            break;
    }
}
- (IBAction)logoutAction:(id)sender {
        ZLFuncLog;
        WeakSelf;
        [[ZLPopoverView sharedInstance] showTipsViewWithTips:@"是否确定退出登录?" leftTitle:@"取消" rightTitle:@"确定" RegisterClicked:^{
            [[TYWJNetWorkTolo sharedManager] requestWithMethod:POST WithPath:@"/user/user-detail" WithParams:@{@"uid":[ZLUserDefaults objectForKey:TYWJLoginUidString]} WithSuccessBlock:^(NSDictionary *dic) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                [TYWJCommonTool signOutUserWithView:weakSelf.view];
                return;
            } WithFailurBlock:^(NSError *error) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                              [TYWJCommonTool signOutUserWithView:weakSelf.view];
            }];


        }];
}

@end
