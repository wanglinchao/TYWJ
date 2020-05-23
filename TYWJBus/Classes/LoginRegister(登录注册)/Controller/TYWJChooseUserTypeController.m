//
//  TYWJChooseUserTypeController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJChooseUserTypeController.h"
#import "NGSVerticalButton.h"
#import "TYWJLoginController.h"
#import "TYWJLoginTool.h"


@interface TYWJChooseUserTypeController ()

@property (weak, nonatomic) IBOutlet NGSVerticalButton *driverBtn;
@property (weak, nonatomic) IBOutlet NGSVerticalButton *passengerBtn;


@end

@implementation TYWJChooseUserTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
    
    [TYWJCommonTool show3DTouchActionShow:NO];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"选择用户类型";
//    self.navigationItem.leftBarButtonItem = nil;
    
    [self.driverBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.passengerBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
}

#pragma mark - 按钮点击事件

- (IBAction)driverClicked:(id)sender {
    ZLFuncLog;
    [self pushToLoginVCWithUserType:TYWJLoginTypeDriver];
    
}

- (IBAction)passengerClicked:(id)sender {
    ZLFuncLog;
    [self pushToLoginVCWithUserType:TYWJLoginTypePassenger];
}

- (void)pushToLoginVCWithUserType:(TYWJLoginType)userType {
    [TYWJLoginTool sharedInstance].userType = userType;
    TYWJLoginController *loginVc = [[TYWJLoginController alloc] init];
    [self.navigationController pushViewController:loginVc animated:YES];
}
@end
