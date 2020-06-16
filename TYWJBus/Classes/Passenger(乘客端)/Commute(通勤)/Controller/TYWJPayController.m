//
//  TYWJPayDetailController.m
//  TYWJBus
//
//  Created by tywj on 2020/6/3.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJPayController.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import "TYWJWechatPayModel.h"
#import <MJExtension.h>
#import "TYWJCarProtocolController.h"
@interface TYWJPayController ()
{
    NSInteger _payType;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *payType1;
@property (weak, nonatomic) IBOutlet UIButton *payType2;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *getupL;
@property (weak, nonatomic) IBOutlet UILabel *getdownL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@end

@implementation TYWJPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    if (self.paramDic && self.paramDic.allKeys.count > 0) {
        [self setupView];
    }
    _payType = 0;
    self.payType1.selected = YES;
    _contentView.zl_width = ZLScreenWidth;
    self.scrollview.contentSize = CGSizeMake(ZLScreenWidth, self.contentView.zl_height);
    [self.scrollview addSubview:_contentView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"购买说明" forState:UIControlStateNormal];
    [button setTitleColor:ZLNavTextColor forState:UIControlStateNormal];
    button.zl_size = CGSizeMake(80, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(purchaseDescriptionClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftbutton setTitle:@"购买说明" forState:UIControlStateNormal];
    [leftbutton setImage:[UIImage imageNamed:@"icon_nav_back"] forState:UIControlStateNormal];
    [leftbutton setTitleColor:ZLNavTextColor forState:UIControlStateNormal];
    leftbutton.zl_size = CGSizeMake(40, 40);
    leftbutton.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftbutton addTarget:self action:@selector(popToPreVC) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    
    
//
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor redColor];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popToPreVC)];
}
- (void)setupView{
    _titleL.text = [self.paramDic objectForKey:@"line_name"];
    _getupL.text = [self.paramDic objectForKey:@"geton_loc"];
    _getdownL.text = [self.paramDic objectForKey:@"getoff_loc"];
    _timeL.text = [self.paramDic objectForKey:@"line_time"];
    _peopleNumL.text = [NSString stringWithFormat:@"%@",[self.paramDic objectForKey:@"number"]];
    NSString *priceStr = [self.paramDic objectForKey:@"money"];
    _priceL.text = [NSString stringWithFormat:@"￥ %0.2f",priceStr.floatValue/100];
    [_payBtn setTitle:[NSString stringWithFormat:@"确认支付￥ %0.2f",priceStr.floatValue/100] forState:UIControlStateNormal];
}
/**
 购票说明点击
 */
- (void)purchaseDescriptionClicked {
    TYWJCarProtocolController *vc = [[TYWJCarProtocolController alloc] init];
    vc.type = TYWJCarProtocolControllerTypeTicketingInformation;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)payAction:(id)sender {
    if (_order_no.length > 0) {
        [self requestToPay];
        return;
    }
    ZLFuncLog;
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:POST WithPath:@"http://192.168.2.91:9005/ticket/order/create" WithParams:self.paramDic WithSuccessBlock:^(NSDictionary *dic) {
        self->_order_no = [[dic objectForKey:@"data"] objectForKey:@"order_no"];
        [self requestToPay];
    } WithFailurBlock:^(NSError *error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:self.view];
    }];
    //
}
- (void)requestToPay{
    NSDictionary *param = @{
        @"app_type": @"IOS_CC",
        @"money":[self.paramDic objectForKey:@"money"],
        @"open_id":@"",
        @"order_no":_order_no,
        @"pay_type":_payType?@"C003":@"C004"//C003 微信, C004 支付宝
    };
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:POST WithPath:@"http://192.168.2.91:9005/ticket/order/pre" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        NSDictionary *map = [[dic objectForKey:@"data"] objectForKey:@"map"];
        if (self->_payType) {
            [self weChatPayWithData:map];
        } else {
            NSString *orderStr = [map objectForKey:@"sign"];
            [self alipayWithOrderString:orderStr];
        }
    } WithFailurBlock:^(NSError *error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:self.view];
    }];
}
- (void)alipayWithOrderString:(NSString *)orderString {
    //应用注册scheme,在AliSDKDemo-Info.plist定义URL type
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:kAppUrlScheme callback:^(NSDictionary *resultDic) {
        ZLLog(@"reslut = %@",resultDic);
        if ([resultDic[@"resultStatus"] integerValue] == 9000) {
            //            NSString *reString = resultDic[@"result"];
            //            reString = [reString stringByReplacingOccurrencesOfString:@"\\\"" withString:@""];
            
            [MBProgressHUD zl_showSuccess:@"支付成功"];
            
            [self jumpToMyTicketVC];
            
        }else{
            if ([resultDic[@"resultStatus"] integerValue] == 6001) {
                [MBProgressHUD zl_showError:@"支付被取消"];
            }else if ([resultDic[@"resultStatus"] integerValue] == 4000) {
                [MBProgressHUD zl_showError:@"订单支付失败"];
            }else if ([resultDic[@"resultStatus"] integerValue] == 6002) {
                [MBProgressHUD zl_showError:@"网络连接出错"];
            }else if ([resultDic[@"resultStatus"] integerValue] == 8000) {
                [MBProgressHUD zl_showMessage:@"正在处理..."];
            }
            
            //            [self popToPreVC];
        }
        
    }];
}
- (void)weChatPayWithData:(NSDictionary *)data
{
    //    [SVProgressHUD zl_showSuccessWithStatus:@"开始调起微信支付"];
    if (![WXApi isWXAppInstalled]) {
        [MBProgressHUD zl_showError:@"未检测到微信,无法进行支付"];
        return;
    }
    
    TYWJWechatPayModel *model = [TYWJWechatPayModel mj_objectWithKeyValues:data];
    
    PayReq *request = [[PayReq alloc] init];
    //    request.openID = model.appid;
    /** 商家向财付通申请的商家id */
    request.partnerId = model.partnerid;
    /** 预支付订单 */
    request.prepayId = model.prepayid;
    /** 商家根据财付通文档填写的数据和签名 */
    request.package = model.package;
    /** 随机串，防重发 */
    request.nonceStr= model.noncestr;
    /** 时间戳，防重发 */
    request.timeStamp= model.timestamp;
    /** 商家根据微信开放平台文档对数据做的签名 */
    request.sign= model.sign;
    
    [WXApi sendReq:request completion:^(BOOL success) {
         if (success) {
               [MBProgressHUD zl_showSuccess:@"调起微信支付成功"];
           }else {
               [MBProgressHUD zl_showSuccess:@"调起微信支付失败"];
           }
    }];
   
    /*! @brief 发送请求到微信，等待微信返回onResp
     *
     * 函数调用后，会切换到微信的界面。第三方应用程序等待微信返回onResp。微信在异步处理完成后一定会调用onResp。支持以下类型
     * SendAuthReq、SendMessageToWXReq、PayReq等。
     * @param req 具体的发送请求，在调用函数后，请自己释放。
     * @return 成功返回YES，失败返回NO。
     */
    
}

/**
 微信支付结果回调
 */
- (void)WXPayResult:(NSNotification *)noti {
    NSDictionary *dicOfResult = [noti object];
    BaseResp *resp = dicOfResult[TYWJWechatPayResult];
    NSString *payResult = nil;
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
            {
                //支付成功，跳转到我的车票界面
                payResult = @"支付成功!";
                ZLLog(@"%@", payResult);
                [MBProgressHUD zl_showSuccess:payResult];
                
                [self jumpToMyTicketVC];
            }
                break;
            case -1:
            {
                //支付失败，直接返回上个界面
                payResult = @"支付失败!";
                ZLLog(@"%@", payResult);
                [MBProgressHUD zl_showError:payResult];
//                [self popToPreVC];
            }
                break;
            case -2:
            {
                //用户退出支付
                payResult = @"用户已经退出支付!";
                ZLLog(@"%@", payResult);
                [MBProgressHUD zl_showError:payResult];
//                [self popToPreVC];
            }
                break;
            default:
            {
                //支付失败，直接返回上个界面
                payResult = [NSString stringWithFormat:@"支付失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                ZLLog(@"%@", payResult);
                [MBProgressHUD zl_showError:payResult];
//                [self popToPreVC];
            }
                break;
        }
    }
}

- (void)jumpToMyTicketVC {
    [MBProgressHUD zl_showSuccess:@"购买成功"];
    UINavigationController *nav = self.navigationController;
    [nav popToRootViewControllerAnimated:NO];
    
    
}
- (void)popToPreVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)choosePayType:(UIButton *)sender {
    _payType = sender.tag - 200;
    self.payType1.selected = NO;
    self.payType2.selected = NO;
    sender.selected = YES;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
