//
//  TYWJSetLoginPwdController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/28.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJSetLoginPwdController.h"
#import "TYWJContactCustomerServiceView.h"
#import "TYWJBorderButton.h"
#import "TYWJLoginTool.h"
#import "TYWJSoapTool.h"
#import "TYWJActivityCenter.h"
#import "ZLHTTPSessionManager.h"
#import "TYWJJsonRequestUrls.h"
#import <MJExtension.h>




@interface TYWJSetLoginPwdController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UITextField *secondPwdTF;

//@property (weak, nonatomic) IBOutlet UIButton *checkoutPwdBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UITextField *inviteCodeTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inviteViewH;
@property (weak, nonatomic) IBOutlet UIView *inviteView;
@property (weak, nonatomic) IBOutlet UIView *fView;


/* finishView */
@property (strong, nonatomic) TYWJContactCustomerServiceView *finishView;
@end

@implementation TYWJSetLoginPwdController
#pragma mark - 懒加载
- (TYWJContactCustomerServiceView *)finishView {
    if (!_finishView) {
        _finishView = [[[NSBundle mainBundle] loadNibNamed:@"TYWJContactCustomerServiceView" owner:nil options:nil] lastObject];
        _finishView.frame = CGRectMake(0, 0, self.fView.zl_width, self.fView.zl_height);
        [_finishView.nextBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishView.nextBtn addTarget:self action:@selector(finishClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishView;
}
#pragma mark - set up view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupVeiw];
}

- (void)setupVeiw {
    if (self.isForgetPwd) {
        self.inviteView.hidden = YES;
        self.inviteViewH.constant = 0;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置登录密码";
    self.textfield.secureTextEntry = YES;
    self.textfield.keyboardType = UIKeyboardTypeAlphabet;
    self.textfield.delegate = self;
    self.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.textfield becomeFirstResponder];
    self.secondPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.secondPwdTF.delegate = self;
    self.secondPwdTF.keyboardType = UIKeyboardTypeAlphabet;
    self.textfield.secureTextEntry = YES;
    
    self.inviteCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    WeakSelf;
    
    [self.fView addSubview:self.finishView];
    self.finishView.combineViewClicked = ^{
        [weakSelf.view endEditing:YES];
    };
    
    
}

#pragma mark - view点击，退出键盘

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

///**
// 查看密码点击
// */
//- (IBAction)checkoutPwdClicked:(id)sender {
//    ZLFuncLog;
//    self.checkoutPwdBtn.selected = !self.checkoutPwdBtn.selected;
//    if (self.checkoutPwdBtn.selected) {
//        self.textfield.secureTextEntry = NO;
//    }else {
//        self.textfield.secureTextEntry = YES;
//    }
//}

/**
 完成点击
 */
- (void)finishClicked {
    ZLFuncLog;
    if (![self.textfield.text isEqualToString:self.secondPwdTF.text]) {
        [MBProgressHUD zl_showError:@"两次输入的密码不一致,请重新输入!"];
        return;
    }
    if (self.textfield.text.length < 6) {
        [MBProgressHUD zl_showError:@"设置密码不能小于6位"];
        return;
    }
    if (self.textfield.text.length > 20) {
        [MBProgressHUD zl_showError:@"设置密码不能大于20位"];
        return;
    }
    if (self.isForgetPwd) {
        //忘记密码
        if (self.isDriver) {
            [self loadModifyDriverPwdData];
        }else {
            [self loadModifyPwdData];
        }
        
        return;
    }
    //注册
    [self loadData];
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.finishView.nextBtn.enabled = NO;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //输入删除键的时候，不做其他任何操作
    if ([string isEqualToString:@""]) {
        if (textField.text.length < 7) {
            self.finishView.nextBtn.enabled = NO;
        }
        return YES;
    }
    //当长度大于limitNums -1的时候，就是现在已经这个输入已经limitNums位了，就不让继续输入了，否则继续输入
    if (textField.text.length > 4) {
        self.finishView.nextBtn.enabled = YES;
        if (textField.text.length == 20) {
            return NO;
        }
        return YES;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.secureTextEntry == YES) {
        textField.text = @"";
        self.finishView.nextBtn.enabled = NO;
    }
    
    return YES;
}

#pragma mark - 请求数据

/**
 注册
 */
- (void)loadData {
    NSString *bodyStr = nil;
    WeakSelf;
    if ([TYWJLoginTool sharedInstance].userType == TYWJLoginTypePassenger) {
        NSString *inviteCode = self.inviteCodeTF.text;
        bodyStr = [NSString stringWithFormat:
                   @"<%@ xmlns=\"%@\">\
                   <yhm>%@</yhm>\
                   <ma>%@</ma>\
                   <uid>%@</uid>\
                   <qdh>%@</qdh>\
                   </%@>",TYWJRequestRegisterPassenger,TYWJRequestService,[TYWJLoginTool sharedInstance].phoneNum,self.textfield.text,[TYWJCommonTool sharedTool].deviceID,inviteCode,TYWJRequestRegisterPassenger];
    }else {
        bodyStr = [NSString stringWithFormat:
                   @"<%@ xmlns=\"%@\">\
                   <yhm>%@</yhm>\
                   <ma>%@</ma>\
                   <uid>%@</uid>\
                   </%@>",TYWJRequestRegisterDriver,TYWJRequestService,[TYWJLoginTool sharedInstance].phoneNum,self.textfield.text,[TYWJCommonTool sharedTool].deviceID, TYWJRequestRegisterDriver];
    }
    [TYWJSoapTool SOAPDataWithSoapBody:bodyStr success:^(id responseObject) {
        NSString *retString = nil;
        if ([TYWJLoginTool sharedInstance].userType == TYWJLoginTypePassenger) {
            retString = responseObject[0][@"NS1:ck_userinsertResponse"];
        }else {
            retString = responseObject[0][@"NS1:sj_userinsertResponse"];
        }
        if ([retString isEqualToString:@"ok"]) {
            [MBProgressHUD zl_showSuccess:@"注册成功"];
            [weakSelf requestACData];
            UIViewController *vc1 = weakSelf.navigationController.childViewControllers[1];
            [weakSelf.navigationController popToViewController:vc1 animated:YES];
        }else {
            [MBProgressHUD zl_showError:@"注册失败"];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:weakSelf.view];
    }];
}

/**
 修改密码
 */
- (void)loadModifyPwdData {
    WeakSelf;
    NSString *bodyStr = nil;
    if ([TYWJLoginTool sharedInstance].userType == TYWJLoginTypePassenger) {
        bodyStr = [NSString stringWithFormat:
                   @"<%@ xmlns=\"%@\">\
                   <yhm>%@</yhm>\
                   <yhmm>%@</yhmm>\
                   </%@>",TYWJRequestModifyPwd,TYWJRequestService,[TYWJLoginTool sharedInstance].phoneNum,self.textfield.text,TYWJRequestModifyPwd];
    }else {
        bodyStr = [NSString stringWithFormat:
                   @"<%@ xmlns=\"%@\">\
                   <yhm>%@</yhm>\
                   <yhmm>%@</yhmm>\
                   </%@>",TYWJRequestModifyDriverPwd,TYWJRequestService,[TYWJLoginTool sharedInstance].phoneNum,self.textfield.text, TYWJRequestModifyDriverPwd];
    }
    [TYWJSoapTool SOAPDataWithSoapBody:bodyStr success:^(id responseObject) {
        NSString *retString = nil;
        if ([TYWJLoginTool sharedInstance].userType == TYWJLoginTypePassenger) {
            retString = responseObject[0][@"NS1:ck_updatepsdResponse"];
        }else {
            retString = responseObject[0][@"NS1:sj_updatepsdResponse"];
        }
        if ([retString isEqualToString:@"ok"]) {
            [MBProgressHUD zl_showSuccess:@"修改密码成功"];
//            [weakSelf requestACData];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else {
            [MBProgressHUD zl_showError:@"修改密码失败"];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
/**
 修改司机密码
 */
- (void)loadModifyDriverPwdData {
    WeakSelf;
    [MBProgressHUD zl_showMessage:TYWJWarningLoading];
    ZLHTTPSessionManager *mgr = [ZLHTTPSessionManager signManager];
    [mgr.requestSerializer setValue:[TYWJLoginTool sharedInstance].driverInfo.token forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"oldPassword"] = [TYWJLoginTool sharedInstance].driverLoginPwd;
    params[@"newPassword"] = self.textfield.text;
    params[@"requestFrom"] = @"iOS";
    [mgr POST:[TYWJJsonRequestUrls sharedRequest].password parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        if ([responseObject[@"errCode"] integerValue] == 0) {
            [TYWJLoginTool sharedInstance].driverLoginPwd = weakSelf.textfield.text;
            [MBProgressHUD zl_showSuccess:@"修改密码成功"];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else {
            [MBProgressHUD zl_showError:@"修改密码失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork];
    }];
}

/**
 请求活动中心数据
 */
- (void)requestACData {
    WeakSelf;
//    __block NSArray *dataArray = nil;
    NSString *bodyStr = [NSString stringWithFormat:
                         @"<%@ xmlns=\"%@\">\
                         </%@>",TYWJRequestAcitivity,TYWJRequestService,TYWJRequestAcitivity];
    [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:bodyStr success:^(id responseObject) {
        ZLFuncLog;
        id data = responseObject[0][@"NS1:huodongzhongxinResponse"][@"huodongzhongxinList"][@"huodongzhongxin"];
        if ([data isKindOfClass: [NSDictionary class]]) {
            TYWJActivityCenter *ac = [TYWJActivityCenter mj_objectWithKeyValues:data];
            if (ac.info.isSendMsg.boolValue) {
                NSString *url = ac.info.content;
                if (![url containsString:@"http"]) {
                    url = [NSString stringWithFormat:@"http://%@",url];
                    [weakSelf requestSetVerifyCodeWithUrl:url];
                }
            }
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestSetVerifyCodeWithUrl:(NSString *)url {
    
    NSString *service = @"http://sms.cd917.com/api/SmsService/SendSms";
    
    NSString *msg = [NSString stringWithFormat:@"【胖哒直通车】有最新活动啦，请点击以下链接进入:\n%@",url];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tel"] = [TYWJLoginTool sharedInstance].phoneNum;
    params[@"content"] = msg;
    
    [[ZLHTTPSessionManager manager] POST:service parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"MessageDTO"][@"Code"] intValue] == 0) {
            ZLLog(@"活动短信发送成功!");
        }
    } failure:nil];
    
}
@end
