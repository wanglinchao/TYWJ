//
//  TYWJLoginController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJLoginController.h"
#import "TYWJLeftImageTextField.h"
#import "TYWJCombineTextButton.h"
#import "TYWJProtocolController.h"
#import "TYWJTabBarController.h"

#import "ZLPopoverView.h"
#import "ZLLoginRegisterTool.h"
#import "TYWJLoginTool.h"
#import "AppDelegate.h"
#import "ZLLoginAnimButton.h"
#import "WRNavigationBar.h"
#import <MJExtension.h>
#import <ATAuthSDK/ATAuthSDK.h>
#import "TYWJThirdLoginView.h"
#import <WechatOpenSDK/WXApiObject.h>
#import <WXApi.h>
#import "TYWJChooseUserTypeView.h"
#import "TYWJChooseUserTypeWindow.h"

@interface TYWJLoginController ()

@property (weak, nonatomic) IBOutlet TYWJLeftImageTextField *loginUserTF;
@property (weak, nonatomic) IBOutlet TYWJLeftImageTextField *loginPwdTF;
@property (weak, nonatomic) IBOutlet TYWJCombineTextButton *combineTextView;

/* afMgr */
@property (strong, nonatomic) AFHTTPSessionManager *afMgr;
@property (weak, nonatomic) IBOutlet UIView *getCodeView;
@property (weak, nonatomic) IBOutlet ZLLoginAnimButton *loginBtn;
@property (nonatomic, strong) NSString *authState;
@property (nonatomic, strong) TYWJThirdLoginView *thirdLoginView;
@property (nonatomic, strong)TYWJChooseUserTypeWindow *chooseUserTypeWindow;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIButton *fastLoginBtn;

/* cover */
@property (strong, nonatomic) UIWindow *cover;
@property (nonatomic, assign) int x;
@property (nonatomic, assign) int y;
@property (nonatomic, assign) int z;

@end

@implementation TYWJLoginController

#pragma mark - 懒加载

#pragma mark - setup view
- (void)dealloc {
    [self removeNotis];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    SAVEISDRIVER(NO);
    //    [self showUIRectEdgeNone];
    self.chooseUserTypeWindow = [[TYWJChooseUserTypeWindow alloc] init];
    [self.chooseUserTypeWindow showWithAnimation];
    // Do any additional setup after loading the view from its nib.
    [self addNotis];
    [self setupView];
    [self fastLogin];
    [self getCodeBtn];
}
- (IBAction)fastLogin:(id)sender {
    [self fastLogin];
}

- (void)fastLogin{
    NSString *info = @"IOJJdMN6NItfGBhZjizlvB9oBjah3kjXwCK8YYpPICLBk88TGPhkTqbqGlUhaXkrLLa6Xo+v7ks4IzgByxjM/34XkDJ22UNbNsce0KeGF5bIPo5Ff6PFiGEOJhnu0O2ZHatOeip2vzePxOC4aE6fkGNG4nlEndg7p3HXjVibEz7S3zYsPa6BQoA5zlsjtJo4l1+jUEjBuv+VbyY1Fgd0y8WI974SoL2THs66SKfEc/cwhSyp6DNfnIwL3R29z/w7";
    __weak typeof(self) weakSelf = self;
    //设置SDK参数，app生命周期内调用一次即可
    [[TXCommonHandler sharedInstance] setAuthSDKInfo:info complete:^(NSDictionary * _Nonnull resultDic) {
        NSString *code = [resultDic objectForKey:@"resultCode"];
        if ([code isEqualToString:PNSCodeSuccess]) {
            NSLog(@"初始化成功");
            [self checkEnvAvailable];
            
        } else {
            NSLog(@"初始化失败");
        }
    }];
    
}
- (void)checkEnvAvailable{
    [[TXCommonHandler sharedInstance] checkEnvAvailableWithAuthType:(2) complete:^(NSDictionary * _Nullable resultDic) {
        NSString *code = [resultDic objectForKey:@"resultCode"];
        if ([code isEqualToString:PNSCodeSuccess]) {
            NSLog(@"可以一键登录");
            [self getPhoneNumber];
            
        } else {
            NSLog(@"不能一键登录");
        }
        
    }];
}
- (void)getPhoneNumber{
    
    [[TXCommonHandler sharedInstance] accelerateLoginPageWithTimeout:(3) complete:^(NSDictionary * _Nonnull resultDic) {
        NSString *code = [resultDic objectForKey:@"resultCode"];
        if ([code isEqualToString:PNSCodeSuccess]) {
            NSLog(@"取号成功");
            [self getLoginToken];
        } else {
            NSLog(@"取号失败");
            
        }
        
    }];
}
- (void)getLoginToken{
    [[TXCommonHandler sharedInstance] getLoginTokenWithTimeout:(3) controller:self model:[self getCustomModel] complete:^(NSDictionary * _Nonnull resultDic) {
        
        NSString *code = [resultDic objectForKey:@"resultCode"];
        if ([code isEqualToString:PNSCodeLoginControllerPresentSuccess]) {
            self.fastLoginBtn.hidden = NO;
            NSLog(@"弹起授权页成功");
        } else if ([code isEqualToString:PNSCodeLoginControllerClickCancel]) {
            NSLog(@"点击了授权页的返回");
            
        } else if ([code isEqualToString:PNSCodeLoginControllerClickChangeBtn]){
            [self hidFastAuth];
        } else if ([code isEqualToString:PNSCodeLoginControllerClickLoginBtn]){
            if ([[resultDic objectForKey:@"isChecked"] boolValue] == true) {
                NSLog(@"点击了登录按钮，check box选中，SDK内部接着会去获取登陆Token");
                self.thirdLoginView.hidden = YES;
                
            } else {
                [MBProgressHUD zl_showError:@"用户条款未同意"];
                
                NSLog(@"点击了登录按钮，check box选中，SDK内部不会去获取登陆Token");
            }
        } else if ([code isEqualToString:PNSCodeLoginControllerClickCheckBoxBtn]) {
            NSLog(@"点击check box");
            
        } else if ([code isEqualToString:PNSCodeLoginControllerClickProtocol]){
            NSLog(@"点击了协议富文本");
            [self.chooseUserTypeWindow hideWithAnimation];
        } else if ([code isEqualToString:PNSCodeSuccess]){
            NSString *token = [resultDic objectForKey:@"token"];
            NSDictionary *param = @{
                @"ali_accesstoken": token,
                @"ali_id": @"",
                @"ali_out_id": @"",
                @"login_type": @"1",
                @"mobile_phone_number": @"",
                @"mobile_validate_code": @"",
                @"platform_type": @"1",
                @"qq_id": @"",
                @"union_id": @""
            };
            [self login:param isFast:YES];
        }
    }];
}
- (TXCustomModel *)getCustomModel{
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.navColor = UIColor.whiteColor;
    model.navTitle = [[NSAttributedString alloc] init];
    model.navBackImage = [UIImage imageNamed:@"icon_nav_back"];
    model.navBackButtonFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return  CGRectMake(15, 43, 40, 40);
    };
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    model.logoImage = [UIImage imageNamed:@"app_icon"];
    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return  CGRectMake((ZLScreenWidth - 88)/2, 48, 88, 88);
    };
    NSString *serverName = @"";
    if ([TXCommonUtils isChinaUnicom]) {
        serverName = @"中国联通";
    } else if ([TXCommonUtils isChinaMobile]) {
        serverName = @"中国移动";
    } else if ([TXCommonUtils isChinaTelecom]) {
        serverName = @"中国电信";
    }
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return  CGRectMake(frame.origin.x, 240 - 64, frame.size.width, 28);
    };
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return  CGRectMake(frame.origin.x, 274 - 64, frame.size.width, frame.size.height);
    };
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = [UIColor grayColor];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    model.sloganText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@账号提供登录服务",serverName] attributes:attributes];
    
    
    NSMutableDictionary *sloganTextattributes = [NSMutableDictionary dictionary];
    sloganTextattributes[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#333333"];
    sloganTextattributes[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    model.loginBtnText = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:sloganTextattributes];
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        float width = ZLScreenWidth * 0.83;
        float height = 44.0;
        
        return  CGRectMake((ZLScreenWidth - width)/2, 322 - 64, width, height);
    };
    model.loginBtnBgImgs = @[[UIImage imageNamed:@"login_back"],[UIImage imageNamed:@"login_back"],[UIImage imageNamed:@"login_back"]];
    
    NSMutableDictionary *changeBtnTitletattributes = [NSMutableDictionary dictionary];
    changeBtnTitletattributes[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"3F3F3F"];
    changeBtnTitletattributes[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    model.changeBtnTitle = [[NSAttributedString alloc] initWithString:@"其它手机号登录" attributes:changeBtnTitletattributes];
    model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return  CGRectMake((ZLScreenWidth - frame.size.width)/2, 376 - 64, frame.size.width, frame.size.height);
        
    };
    model.privacyColors = [NSArray arrayWithObjects:[UIColor redColor],[UIColor yellowColor], nil];
    model.privacyColors = @[[UIColor colorWithHexString:@"3F3F3F"],[UIColor colorWithHexString:@"FED302"]];
    model.privacyOne = @[@"《胖哒用户协议》",TYWJCarProtocolUrl];
    model.privacyPreText = @"点击登录，即表示您已同意";
    model.privacyAlignment = NSTextAlignmentCenter;
    model.privacyOperatorPreText = @"《";
    model.privacyOperatorSufText = @"》";
    model.privacyNavBackImage = [UIImage imageNamed:@"导航栏_图标_back"];
    model.checkBoxImages = @[[UIImage imageNamed:@"login_regual"],[UIImage imageNamed:@"login_regual_selected"]];
    model.checkBoxIsChecked = true;
    if ([WXApi isWXAppInstalled]) {
        model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
            _thirdLoginView = [[TYWJThirdLoginView alloc] initWithFrame:CGRectMake(0,  ZLScreenHeight - kNavBarH - kTabBarH - 50 - 140, ZLScreenWidth, 50)];
            WeakSelf;
            _thirdLoginView.buttonSeleted = ^(NSInteger index) {
                if (index == 201) {
                    [weakSelf wechatLogin];
                } else {
                    NSString *avatarString = @"https://panda-pubs.oss-cn-chengdu.aliyuncs.com/20200423/3x_image.png";
                    [TYWJLoginTool sharedInstance].loginStatus = 1;
                    [TYWJLoginTool sharedInstance].phoneNum = @"18280192284";
                    [TYWJLoginTool sharedInstance].uid = @"83005092";
                    [TYWJLoginTool sharedInstance].nickname = @"wanglc";
                    [TYWJLoginTool sharedInstance].avatarString = avatarString;
                    [[TYWJLoginTool sharedInstance] saveLoginInfo];
                    [[TYWJLoginTool sharedInstance] getLoginInfo];
                    [[NSUserDefaults standardUserDefaults] setValue:@"1e5f68582df84ab889ce6c6af138b83a" forKey:@"Authorization"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    SAVEISDRIVER(YES);
                    [[TYWJCommonTool sharedTool] setRootVcWithTabbarVc];
                }
            };
            [superCustomView addSubview:_thirdLoginView];
        };
    }
    
    return model;
}
- (void)wechatLogin{
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq* req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        self.authState = req.state = [self randomKey];
        [WXApi sendAuthReq:req viewController:self delegate:nil completion:^(BOOL success) {
            
        }];
    } else {
        [MBProgressHUD zl_showError:@"未安装微信"];
    }
    
    
    
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
- (void)getWeChatLoginCode:(NSNotification *)notification {
    WeakSelf;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",TYWJWechatAppKey, TYWJWechatSecretKey, [notification.userInfo objectForKey:@"code"]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"]; //请求方式
    [request setTimeoutInterval:10]; //请求超时限制
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData]; //缓存模式
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"请求错误：%@", error);
            return;
        }
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"结果：\n%@", dataString);
        NSDictionary *accessDict = [self dictionaryWithJsonString:dataString];
        NSString *openID = [accessDict objectForKey:@"openid"];
        NSString *accessToken = [accessDict objectForKey:@"access_token"];
        NSString *unionid = [accessDict objectForKey:@"unionid"];
        NSDictionary *param = @{
            @"ali_accesstoken": @"",
            @"ali_id": @"",
            @"ali_out_id": @"",
            @"login_type": @"2",
            @"mobile_phone_number": @"",
            @"mobile_validate_code": @"",
            @"platform_type": @"1",
            @"qq_id": @"",
            @"union_id": @"",
            @"open_id":openID,
            @"union_id":unionid,
            @"wx_access_token":accessToken,
            
        };
        dispatch_async(dispatch_queue_create(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf login:param isFast:NO];
            });
        });
    }];
    [task resume];
}
- (NSString *)randomKey {
    /* Get Random UUID */
    NSString *UUIDString;
    CFUUIDRef UUIDRef = CFUUIDCreate(NULL);
    CFStringRef UUIDStringRef = CFUUIDCreateString(NULL, UUIDRef);
    UUIDString = (NSString *)CFBridgingRelease(UUIDStringRef);
    CFRelease(UUIDRef);
    /* Get Time */
    double time = CFAbsoluteTimeGetCurrent();
    /* MD5 With Sale */
    return [NSString stringWithFormat:@"%@%f", UUIDString, time];
}
- (void)getUserInfoWithUid:(NSString *)uid{
    NSDictionary *param = @{@"uid": uid};
    WeakSelf;
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:POST WithPath:@"http://192.168.2.91:9001/user/user-detail" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        //设置用户信息
        NSDictionary *userDic = [dic objectForKey:@"data"];
        [TYWJLoginTool sharedInstance].loginStatus = 1;
        [TYWJLoginTool sharedInstance].phoneNum = [userDic objectForKey:@"phone"];
        [TYWJLoginTool sharedInstance].uid = [userDic objectForKey:@"uid"];
        NSString *nick_name = [userDic objectForKey:@"nick_name"];
        nick_name =![TYWJCommonTool isBlankString:nick_name]?nick_name:@"请输入昵称";
        [TYWJLoginTool sharedInstance].nickname = nick_name;
        [TYWJLoginTool sharedInstance].avatarString = [userDic objectForKey:@"avatar"];
        [[TYWJLoginTool sharedInstance] saveLoginInfo];
        [[TYWJLoginTool sharedInstance] getLoginInfo];
        if (![TYWJCommonTool isBlankString:[userDic objectForKey:@"rongyun_token"]]) {
            [[NSUserDefaults standardUserDefaults] setValue:[userDic objectForKey:@"rongyun_token"] forKey:@"rongyun_token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [ZLNotiCenter postNotificationName:TYWJModifyUserInfoNoti object:nil];
        [[TYWJCommonTool sharedTool] setRootVcWithTabbarVc];
        [weakSelf.chooseUserTypeWindow hideWithAnimation];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } WithFailurBlock:^(NSError *error) {
        [self.loginBtn loginFailed];
        
        [MBProgressHUD zl_showError:@"获取用户信息失败"];
    } showLoad:NO];
}
- (void)login:(NSDictionary *)param isFast:(BOOL) isFast{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:param];
    [dic setValue:ISDRIVER?@(2):@(1) forKey:@"user_type"];
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:POST WithPath:@"http://192.168.2.91:9001/user/auth/login" WithParams:dic WithSuccessBlock:^(NSDictionary *dic) {
        //        [MBProgressHUD zl_showSuccess:@"成功"];
        [[NSUserDefaults standardUserDefaults] setValue:[[dic objectForKey:@"data"] objectForKey:@"token"] forKey:@"Authorization"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self getUserInfoWithUid:[[dic objectForKey:@"data"] objectForKey:@"uid"]];
        NSLog(@"成功");
        
    } WithFailurBlock:^(NSError *error) {
        [self.loginBtn loginFailed];
        [MBProgressHUD zl_showError:[error.userInfo objectForKey:@"msg"]];
        if (isFast) {
            //            [self hidFastAuth];
        }
    } showLoad:NO];
}
- (void)hidFastAuth {
    [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
}
- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    //    [self wr_setNavBarTintColor:ZLColorWithRGB(0, 0, 0)];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(registerClicked:)];
    [self.loginUserTF setIcon:nil placeholder:@"请输入手机号码" isPwd:NO];
    self.loginUserTF.backgroundColor = [UIColor clearColor];
    [self.loginUserTF setKeyboardType:UIKeyboardTypeNumberPad];
    
    [self.loginPwdTF setIcon:nil placeholder:@"请输入登录密码" isPwd:YES];
    self.loginPwdTF.backgroundColor = [UIColor clearColor];
    
    [self.combineTextView setTips:@"点击登录，即表示您已同意" protocol:@"<<胖哒用车协议>>"];
    WeakSelf;
    self.combineTextView.btnClicked = ^{
        [weakSelf jumpCarProtocolController];
    };
    [self.loginBtn setRoundViewWithCornerRaidus:8.f];
}
- (void)jumpCarProtocolController{
    [self.chooseUserTypeWindow hideWithAnimation];
    TYWJProtocolController *protocolVc = [[TYWJProtocolController alloc] init];
    protocolVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:protocolVc animated:NO completion:^{
        
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    self.chooseUserTypeWindow = [[TYWJChooseUserTypeWindow alloc] init];
    
    [self.chooseUserTypeWindow showWithAnimation];
    
    NSString *phoneNum = [TYWJLoginTool sharedInstance].phoneNum;
    if (phoneNum && ![phoneNum isEqualToString:@""]) {
        self.loginUserTF.textField.text = phoneNum;
    }
    [self.loginUserTF becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.loginUserTF resignFirstResponder];
    [self.loginPwdTF resignFirstResponder];
    
    
}


#pragma mark - 通知
- (void)addNotis {
    [ZLNotiCenter addObserver:self selector:@selector(backToLoginWithPhoneNum:) name:TYWJBackToLoginWithPhoneNum object:nil];
    [ZLNotiCenter addObserver:self selector:@selector(getWeChatLoginCode:) name:@"WeChatLoginCode" object:nil];
    [ZLNotiCenter addObserver:self selector:@selector(chooseUserType) name:@"ChooseUserTypeView" object:nil];
    
    [ZLNotiCenter addObserver:self selector:@selector(showVhooseUserTypeView) name:@"showVhooseUserTypeView" object:nil];
    
}
-(void)showVhooseUserTypeView{
    [self.chooseUserTypeWindow showWithAnimation];
}
- (void)chooseUserType{
    if (ISDRIVER) {
        _thirdLoginView.hidden = YES;
    }else{
        _thirdLoginView.hidden = NO;
        
    }
    
}
- (void)removeNotis {
    [ZLNotiCenter removeObserver:self name:TYWJBackToLoginWithPhoneNum object:nil];
    [ZLNotiCenter removeObserver:self name:@"WeChatLoginCode" object:nil];
    [ZLNotiCenter removeObserver:self name:@"ChooseUserTypeView" object:nil];
    [ZLNotiCenter removeObserver:self name:@"showVhooseUserTypeView" object:nil];
    
    
    
}

- (void)backToLoginWithPhoneNum:(NSNotification *)noti {
    NSString *phoneNum = [noti object];
    if (phoneNum) {
        self.loginUserTF.textField.text = phoneNum;
    }
}
#pragma mark - 数据请求

/**
 登录请求
 */
- (void)loadLoginRequest {
    NSDictionary *param = @{
        @"ali_accesstoken": @"",
        @"ali_id": @"",
        @"ali_out_id": @"",
        @"login_type": @"5",
        @"mobile_phone_number": self.loginUserTF.textField.text,
        @"mobile_validate_code": self.loginPwdTF.textField.text,
        @"platform_type": @"1",
        @"qq_id": @"",
        @"union_id": @""
    };
    [self login:param isFast:NO];
}



#pragma mark - 登录成功
/**
 登录成功
 */


#pragma mark - 点击事件
/**
 view点击，退出键盘
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



/**
 登录按钮点击
 */
- (BOOL)checkloginUserTF{
    if ([self.loginUserTF.textField.text isEqualToString:@""]) {
        [self.loginBtn loginFailed];
        [MBProgressHUD zl_showError:@"手机号码不能为空"];
        return NO;
    }
    if (![ZLLoginRegisterTool isMobileNumber:self.loginUserTF.textField.text]) {
        [self.loginBtn loginFailed];
        [MBProgressHUD zl_showError:@"请输入正确的手机号码"];
        return NO;
    }
    return YES;
    
}
- (BOOL)checkloginPwdTF{
    if ([self.loginPwdTF.textField.text isEqualToString:@""]) {
        [self.loginBtn loginFailed];
        [MBProgressHUD zl_showError:@"验证码不能为空"];
        return NO;
    }
    return YES;
    
}
- (IBAction)loginClicked:(id)sender {
    ZLFuncLog;
    //    [self.view endEditing:YES];
    if ([self checkloginUserTF] && [self checkloginPwdTF]) {
        [self loadLoginRequest];
    }
    
}


#pragma mark - 获取验证码

- (void)getCodeAction{
    if (![self checkloginUserTF]) {
        return;
    }
    
    
    NSDictionary *para = @{@"phone":self.loginUserTF.textField.text};
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:POST WithPath:@"http://192.168.2.91:9001/user/auth/get/validate" WithParams:para WithSuccessBlock:^(NSDictionary *dic) {
        [self dianji];
        [MBProgressHUD zl_showSuccess:@"成功获取手机验证码"];
        NSLog(@"获取手机验证码成功");
        
    } WithFailurBlock:^(NSError *error) {
        
        [MBProgressHUD zl_showError:@"获取验证码失败,请重试"];
        
    }];
}
- (void)dianji{
    UILabel * hongse = (UILabel *)[self.view viewWithTag:1];
    UILabel * huise = (UILabel *)[self.view viewWithTag:2];
    hongse.hidden = YES;
    huise.hidden = NO;
    UIButton * btn = (UIButton *)[self.view viewWithTag:3];
    btn.userInteractionEnabled = NO;
    
    if (btn.userInteractionEnabled == NO) {
        if (_z == 0) {
            [self xianshi];
        }else{
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(xianshi) userInfo:nil repeats:NO];
        }
    }
}
- (void)xianshi{
    _z = 1;
    UILabel * hongse = (UILabel *)[self.view viewWithTag:1];
    UILabel * huise = (UILabel *)[self.view viewWithTag:2];
    UIButton * btn = (UIButton *)[self.view viewWithTag:3];
    
    huise.text = [NSString stringWithFormat:@"还剩%d秒",_y];
    _y -= 1;
    
    if (_y == -1) {
        btn.userInteractionEnabled = YES;
        _y = 60;
        hongse.hidden = NO;
        huise.hidden = YES;
        _z = 0;
        [self ok];
    }else{
        [self dianji];
    }
}
- (void)ok{
    NSLog(@"循环结束");
}
- (void)getCodeBtn{
    _x = 0;
    _y = 60;
    _z = 0;
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 3;
    btn.frame = CGRectMake(0, 0, 80, 28);
    [btn addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.getCodeView addSubview:btn];
    
    UILabel * hongse_Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 28)];
    hongse_Label.tag = 1;
    hongse_Label.text = @"获取验证码";
    hongse_Label.textColor = [UIColor colorWithHexString:@"#333333"];
    hongse_Label.font = [UIFont systemFontOfSize:12];
    hongse_Label.backgroundColor = [UIColor colorWithHexString:@"#FDD000"];
    hongse_Label.layer.cornerRadius = 10;
    hongse_Label.layer.masksToBounds = YES;
    hongse_Label.textAlignment = NSTextAlignmentCenter;
    [btn addSubview:hongse_Label];
    
    UILabel * huise_Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 28)];
    huise_Label.tag = 2;
    huise_Label.textColor = [UIColor whiteColor];
    huise_Label.backgroundColor = [UIColor grayColor];
    
    huise_Label.layer.cornerRadius = 10;
    huise_Label.layer.masksToBounds = YES;
    huise_Label.textAlignment = NSTextAlignmentCenter;
    huise_Label.font = [UIFont systemFontOfSize:12];
    huise_Label.alpha = 0.4;
    [btn addSubview:huise_Label];
    
    huise_Label.hidden = YES;
}

#pragma mark - dealloc

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.afMgr) {
        //如果请求还在进行，则关闭当前请求，且dismiss数据加载界面
        [MBProgressHUD zl_hideHUD];
        [self.afMgr.operationQueue cancelAllOperations];
    }
}

@end
