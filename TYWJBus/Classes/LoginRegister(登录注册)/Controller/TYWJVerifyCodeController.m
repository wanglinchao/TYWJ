//
//  TYWJVerifyCodeController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/28.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJVerifyCodeController.h"
#import "TYWJBorderButton.h"
#import "TYWJContactCustomerServiceView.h"
#import "TYWJSetLoginPwdController.h"
#import "TYWJLoginTool.h"
#import "ZLHTTPSessionManager.h"
#import "TYWJSoapTool.h"


@interface TYWJVerifyCodeController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (strong, nonatomic) TYWJContactCustomerServiceView *contactView;


/* count */
@property (assign, nonatomic) NSInteger count;

/* timer */
@property (strong, nonatomic) NSTimer *timer;
/* enteredBgDate */
@property (strong, nonatomic) NSDate *enteredBgDate;
/* verifyCode */
@property (copy, nonatomic) NSString *verifyCode;
@property (weak, nonatomic) IBOutlet UIView *fView;

@end

@implementation TYWJVerifyCodeController
#pragma mark - 懒加载

- (TYWJContactCustomerServiceView *)contactView {
    if (!_contactView) {
        _contactView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TYWJContactCustomerServiceView class]) owner:nil options:nil] lastObject];
        _contactView.frame = CGRectMake(0, 0, self.fView.zl_width, self.fView.zl_height);
    }
    return _contactView;
}

#pragma mark - setup view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addNotis];
    [self setupView];
    [self getCodeClicked:self.getCodeBtn];
}

- (void)setupView {
//    CATransition
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"请输入短信验证码";
    
    
    [self.getCodeBtn setTitleColor:ZLGlobalTextColor forState:UIControlStateDisabled];
    [self.getCodeBtn setTitleColor:ZLNavTextColor forState:UIControlStateNormal];
    
    self.textfield.delegate = self;
    [self.textfield becomeFirstResponder];
    self.textfield.keyboardType = UIKeyboardTypeNumberPad;
    self.textfield.tintColor = ZLNavTextColor;
    self.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    if ([TYWJLoginTool sharedInstance].phoneNum) {
        self.tipsLabel.text = [NSString stringWithFormat:@"请输入%@收到的短信验证码",[TYWJLoginTool sharedInstance].phoneNum];
    }
    
    [self.fView addSubview:self.contactView];
    WeakSelf;
    self.contactView.combineViewClicked = ^{
        [weakSelf.view endEditing:YES];
    };
    [self.contactView.nextBtn addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)settingVerifyCode {
    int num = (arc4random() % 10000);
    NSString *randomNum = [NSString stringWithFormat:@"%.4d", num];
    self.verifyCode = randomNum;
    
//    NSString *latitude = @"30.548";
//    NSString *longitude = @"104.068";
//
//    int num1 = (arc4random() % 1000000);
//    NSString *randomNum = [NSString stringWithFormat:@"%.6d", num1];
//    latitude = [latitude stringByAppendingString:randomNum];
//
//    int num2 = (arc4random() % 1000000);
//    randomNum = [NSString stringWithFormat:@"%.6d", num2];
//    longitude = [longitude stringByAppendingString:randomNum];
    
}
#pragma mark - others
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        self.getCodeBtn.enabled = YES;
        
    }
    self.textfield.text = @"";
    self.getCodeBtn.enabled = YES;
    self.contactView.nextBtn.enabled = NO;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)dealloc {
    ZLFuncLog;
    [self removeNotis];
}
#pragma mark - 通知相关

- (void)addNotis {
    [ZLNotiCenter addObserver:self selector:@selector(appDidEnterBg) name:TYWJAppDidEnterBgNoti object:nil];
    [ZLNotiCenter addObserver:self selector:@selector(appDidEnterFg) name:TYWJAppDidEnterFgNoti object:nil];
}

- (void)removeNotis {
    [ZLNotiCenter removeObserver:self name:TYWJAppDidEnterBgNoti object:nil];
    [ZLNotiCenter removeObserver:self name:TYWJAppDidEnterFgNoti object:nil];
}

/**
 进入后台
 */
- (void)appDidEnterBg {
    ZLFuncLog;
    self.enteredBgDate = [NSDate date];
}

/**
 进入前台
 */
- (void)appDidEnterFg {
    ZLFuncLog;
    
    NSTimeInterval timeinterval = [[NSDate date] timeIntervalSinceDate:self.enteredBgDate];
    NSInteger deltaTime = timeinterval;
    self.count -= deltaTime;
    if (self.count <= 0) {
        self.getCodeBtn.enabled = YES;
        [self.timer invalidate];
        self.timer = nil;
    }else {
        [self setCountDownText];
    }
}
#pragma mark - 按钮点击

/**
 获取验证码按钮点击
 */
- (IBAction)getCodeClicked:(id)sender {
    
    [self requestSetVerifyCode];
}

- (void)countDown {
    if (self.count == 0) {
        self.getCodeBtn.enabled = YES;
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    self.count--;
    [self setCountDownText];
    
}

- (void)setCountDownText {
    NSString *title = [NSString stringWithFormat:@"重新获取%lds",self.count];
    [self.getCodeBtn setTitle:title forState:UIControlStateDisabled];
    
}
/**
 下一步按钮点击
 */
- (void)nextClicked:(id)sender {
    if (self.textfield.text.intValue == self.verifyCode.intValue) {
        switch (self.type) {
            case TYWJVerifyCodeControllerTypeRegister:
            {
                //注册手机号
                TYWJSetLoginPwdController *setLoginVc = [[TYWJSetLoginPwdController alloc] init];
                [self.navigationController pushViewController:setLoginVc animated:YES];
            }
                break;
            case TYWJVerifyCodeControllerTypeForgetPwd:
            {
                //忘记密码
                TYWJSetLoginPwdController *setLoginVc = [[TYWJSetLoginPwdController alloc] init];
                setLoginVc.isForgetPwd = YES;
                setLoginVc.isDriver = self.isDriver;
                [self.navigationController pushViewController:setLoginVc animated:YES];
            }
                break;
            case TYWJVerifyCodeControllerTypeUpdateUid:
            {
                //更新uid
                [self updateUid];
            }
                break;
        }
        
    }else {
        [MBProgressHUD zl_showError:@"验证码不正确，请重新输入"];
    }
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [TYWJCommonTool configTextfield:textField string:string btn:self.contactView.nextBtn limitNums:4];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.contactView.nextBtn.enabled = NO;
    return YES;
}

#pragma mark - 请求数据

- (void)requestSetVerifyCode {
    WeakSelf;
    [self settingVerifyCode];
    [MBProgressHUD zl_showMessage:TYWJWarningLoading];
    NSString *service = @"http://sms.cd917.com/api/SmsService/SendSms";
    
    NSString *msg = [NSString stringWithFormat:@"【胖哒直通车】您的验证码为%@,请妥善保管，切勿泄漏给他人。",self.verifyCode];
//    msg = @"丹丹，我知道你肯定对我之前说的话很气，我也理解你这很倔的脾气，因为我以前就和你一样的这个脾气，明明是很生气的，但是就是打死不承认，而且还很倔，确实，我们两之间还不是很熟悉，以至于我一直在你面前放不开，也总是让你觉得我在你面前表现得不真实，这其实也怪我，怪我只能在熟悉的人面前放得很开，怪我只能在熟悉的人面前大大咧咧的。其实呢，既然我们两都还不熟悉，何谈的不合适呢？丹丹，你知道我很爱你的，但是你可能理解不到我爱你的程度，我可以毫不夸张的说，高中和现在这次，出现这几乎同样的情况，我都是一样的感觉:生活没动力，学习工作没力气，吃饭没胃口，只要一想到今后的日子里没有你，我真的就不知道今后的生活到底该怎么办，到底该怎样才能生活下去，因为我真的太爱你。我知道，这一切都怪我太喜欢你了。丹丹，你知道我为什么这么些年都不喜欢别人吗，因为我这些年里心里一直有你，我一直对你还抱有希望。这么多年了，我都坚持等下来了，现在在这种节骨眼上了，我是肯定不会放弃的。丹丹，真的很希望能和你心平气和的好好坐下来聊一聊，好好静下心来解决这个原本就可以解决的矛盾。我爱你，这么多年到现在还是那么的爱你，现在在我眼中，我看什么都是你。我好想你丹丹。最近这几天躺下闭上眼睛想到的是你，醒来睁开眼睛，想到的还是你。丹丹，把我微信和电话取消拉黑吧，你知道我这几天还是天天不停的加你，有事没事就打你电话，每次加你，都盼望着加你的消息能发送成功，每次打你电话，都盼望着能打通能接通。丹丹，我不能没有你";
//    msg = @"高中时我已经傻逼的错过了你一次，这次我知道可能时机也不是很对（因为大家年纪开始大了，没时间折腾了），但是我知道这次再错过你，就没有下一次了，这最后一次的机会，我死也不会放弃的";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tel"] = [TYWJLoginTool sharedInstance].phoneNum;
    params[@"content"] = msg;
    
    [[ZLHTTPSessionManager manager] POST:service parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        if ([responseObject[@"MessageDTO"][@"Code"] intValue] == 0) {
            [MBProgressHUD zl_showSuccess:@"验证码已发送，请注意查收"];
            if (weakSelf.timer) {
                [weakSelf.timer invalidate];
                weakSelf.timer = nil;
            }
            weakSelf.getCodeBtn.enabled = NO;
            weakSelf.count = 60;
            [weakSelf setCountDownText];
            
            weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:weakSelf selector:@selector(countDown) userInfo:nil repeats:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork];
    }];
    
}

- (void)updateUid {
    WeakSelf;
    NSString * soapBodyStr = [NSString stringWithFormat:
                              @"<%@ xmlns=\"%@\">\
                              <yhm>%@</yhm>\
                              <uid>%@</uid>\
                              </%@>",TYWJRequestUpdateUserUid,TYWJRequestService,[TYWJLoginTool sharedInstance].phoneNum,[TYWJCommonTool sharedTool].deviceID,TYWJRequestUpdateUserUid];
    
    [TYWJSoapTool SOAPDataWithSoapBody:soapBodyStr success:^(id responseObject) {
        NSString *responseString = responseObject[0][@"NS1:updateuserResponse"];
        if ([responseString isEqualToString:@"ok"]) {
            [MBProgressHUD zl_showSuccess:@"更新成功，请重新登录"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
            [MBProgressHUD zl_showError:responseString];
        }
    } failure:nil];
}
@end
