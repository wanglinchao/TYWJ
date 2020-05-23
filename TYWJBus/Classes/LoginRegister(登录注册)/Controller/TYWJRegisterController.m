//
//  TYWJRegisterController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJRegisterController.h"
#import "TYWJBorderButton.h"
#import "TYWJCombineTextButton.h"
#import "TYWJCarProtocolController.h"
#import "ZLLoginRegisterTool.h"
#import "TYWJSoapTool.h"

#import "ZLPopoverView.h"
#import "TYWJNavigationController.h"
#import "TYWJLoginTool.h"
#import "TYWJContactCustomerServiceView.h"
#import "TYWJVerifyCodeController.h"


@interface TYWJRegisterController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet TYWJCombineTextButton *combineView;

/* contactView */
@property (strong, nonatomic) TYWJContactCustomerServiceView *contactView;
@property (weak, nonatomic) IBOutlet UIView *fView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *combineViewH;

@end

@implementation TYWJRegisterController
#pragma mark - 懒加载
- (TYWJContactCustomerServiceView *)contactView {
    if (!_contactView) {
        _contactView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TYWJContactCustomerServiceView class]) owner:nil options:nil] lastObject];
        _contactView.frame = CGRectMake(0, 0, self.fView.zl_width, self.fView.zl_height);
        [_contactView.nextBtn addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contactView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.phoneNumTF.delegate = self;
    [self.phoneNumTF becomeFirstResponder];
    [self.combineView setTips:@"点击下一步，表示已同意" protocol:@"<<胖哒用车协议>>"];
    
    WeakSelf;
    self.combineView.btnClicked = ^{
        TYWJCarProtocolController *protocolVc = [[TYWJCarProtocolController alloc] init];
        [weakSelf.navigationController pushViewController:protocolVc animated:YES];
    };
    self.contactView.combineViewClicked = ^{
        [weakSelf.view endEditing:YES];
    };
    
    if (self.type == TYWJRFTypeRegister) {
        self.navigationItem.title = @"手机注册";
    }else {
        self.combineView.hidden = YES;
        self.combineViewH.constant = 0;
        self.navigationItem.title = @"忘记密码";
    }
    
    self.phoneNumTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneNumTF.tintColor = ZLNavTextColor;
    
    [self.fView addSubview:self.contactView];
}

#pragma mark - 界面点击，退出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [TYWJCommonTool configTextfield:textField string:string btn:self.contactView.nextBtn limitNums:11];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.contactView.nextBtn.enabled = NO;
    return YES;
}

#pragma mark - 按钮点击

- (void)nextClicked:(id)sender {
    //下一步点击
    if ([ZLLoginRegisterTool isMobileNumber:self.phoneNumTF.text]) {//如果输入正确的电话号码
        [self.view endEditing:YES];
        if (self.type == TYWJRFTypeRegister) {//如果是注册界面
            //TODO --   这里要等到有数据了进行请求判断是否输入了已注册的手机号
            [self checkPhoneIsResgistered];
        }
        else {
            [self checkPhoneIsResgistered];
        }
    }
    else {
        //当输入的不是合法的手机号码时，弹出提示窗口
        [MBProgressHUD zl_showError:@"请输入正确的手机号码"];
    }
}

- (void)pushToVerifyVCWithType:(TYWJVerifyCodeControllerType)type {
    TYWJVerifyCodeController *verifyVc = [[TYWJVerifyCodeController alloc] init];
    verifyVc.type = type;
    [self.navigationController pushViewController:verifyVc animated:YES];
    
    [TYWJLoginTool sharedInstance].phoneNum = self.phoneNumTF.text;
}


- (void)checkPhoneIsResgistered {
    WeakSelf;
    NSString *requestMethod  = [TYWJLoginTool sharedInstance].userType == TYWJLoginTypePassenger ? TYWJRequestCheckPassengerUserIsRegistered : TYWJRequestCheckDriverUserIsRegistered;
    NSString * soapBodyStr = [NSString stringWithFormat:
                              @"<%@ xmlns=\"%@\">\
                              <tel>%@</tel>\
                              </%@>",requestMethod,TYWJRequestService,self.phoneNumTF.text,requestMethod];
    NSString *p = nil;
    if ([TYWJLoginTool sharedInstance].userType == TYWJLoginTypeDriver) {
        p = @"NS1:checksijiuserResponse";
    }else {
        p = @"NS1:checkuserResponse";
    }
    [TYWJSoapTool SOAPDataWithSoapBody:soapBodyStr success:^(id responseObject) {
        if (weakSelf.type == TYWJRFTypeForget) {
            if ([responseObject[0][p] isEqualToString:@"false"]) {//如果输入正确的手机号
                //TODO --   这里要等到有数据了进行请求判断是否输入了已注册的手机号
                [weakSelf pushToVerifyVCWithType:TYWJVerifyCodeControllerTypeForgetPwd];
                
            }
            else {
                [[ZLPopoverView sharedInstance] showTipsViewWithTips:@"该手机号码还未注册胖哒账号，请先注册嗷(*^__^*)" leftTitle:@"更换手机号" rightTitle:@"手机注册" RegisterClicked:^{
                    TYWJRegisterController *registerVc = [[TYWJRegisterController alloc] init];
                    TYWJNavigationController *nav = (TYWJNavigationController *)weakSelf.navigationController;
                    registerVc.type = TYWJRFTypeRegister;
                    [nav popViewControllerAnimated:NO];
                    
                    [nav pushViewController:registerVc animated:YES];
                }];
            }
        }
        else {
            if ([responseObject[0][p] isEqualToString:@"true"]) {//如果输入正确的手机号
                [weakSelf pushToVerifyVCWithType:TYWJVerifyCodeControllerTypeRegister];
            }
            else {
                [[ZLPopoverView sharedInstance] showTipsViewWithTips:@"该手机号码已注册过胖哒账号，请直接登录(*^__^*)" leftTitle:@"更换手机号" rightTitle:@"前往登录" RegisterClicked:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    [ZLNotiCenter postNotificationName:TYWJBackToLoginWithPhoneNum object:self.phoneNumTF.text];
                }];
            }
        }
        

    } failure:nil];
}

@end
