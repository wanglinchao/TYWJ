//
//  TYWJPayController.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/13.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJPayController.h"
#import "TYWJPayCell.h"
#import "TYWJNavigationController.h"
#import "TYWJCouponController.h"
#import "ZLPopoverView.h"
#import "TYWJLoginTool.h"
#import "TYWJRouteList.h"
#import "TYWJJsonRequestUrls.h"
#import "ZLHTTPSessionManager.h"

#import "TYWJWechatPayModel.h"
#import "TYWJPeirodTicket.h"

#import "TYWJBorderButton.h"

#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import <MJExtension.h>
#import "TYWJCarProtocolController.h"


static CGFloat const kFooterH = 44.f;

@interface TYWJPayController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* timer */
@property (strong, nonatomic) NSTimer *timer;
/* count */
@property (assign, nonatomic) NSInteger count;
/* header */
@property (strong, nonatomic) UILabel *header;
/* 支付按钮 */
@property (weak, nonatomic) TYWJBorderButton *payBtn;

/* enteredBgTime */
@property (strong, nonatomic) NSDate *enteredBgDate;
/* 订单id */
@property (copy, nonatomic) NSString *orderID;
/* 微信支付时的ip地址 */
@property (copy, nonatomic) NSString *wxPayIp;
/* selectedPayBtn */
@property (weak, nonatomic) UIButton *selectedPayBtn;

@end

@implementation TYWJPayController
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.zl_height -= kTabBarH + kFooterH;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 435.f;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJPayCell class]) bundle:nil] forCellReuseIdentifier:TYWJPayCellID];
    }
    return _tableView;
}

#pragma mark - set up view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addNotis];
    [self setupView];
    [self initializePay];
}
/**
 购票说明点击
 */
- (void)purchaseDescriptionClicked {
    TYWJCarProtocolController *vc = [[TYWJCarProtocolController alloc] init];
    vc.type = TYWJCarProtocolControllerTypeTicketingInformation;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setupView {
    self.view.backgroundColor = [UIColor clearColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"购买说明" forState:UIControlStateNormal];
        [button setTitleColor:ZLNavTextColor forState:UIControlStateNormal];
        button.zl_size = CGSizeMake(80, 30);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(purchaseDescriptionClicked) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    TYWJNavigationController *navi = (TYWJNavigationController *)self.navigationController;
    WeakSelf;
    __weak typeof(navi) weakNavi = navi;
    navi.blockPop = ^{
        [[ZLPopoverView sharedInstance] showTipsViewWithTips:@"确定取消购买?" leftTitle:@"继续购买" rightTitle:@"取消购买" RegisterClicked:^{
            weakNavi.isBlockPop = NO;
            [weakSelf requestQuitTicket];
            [weakNavi popViewControllerAnimated:YES];
            if (weakSelf.timer) {
                [weakSelf.timer invalidate];
                weakSelf.timer = nil;
            }
        }];
    };
    
    if (self.periodTicket) {
        self.totalFee = [NSString stringWithFormat:@"¥%@",self.periodTicket.price];
    }
    self.navigationItem.title = @"支付";
    self.count = 180;
    
    [self.view addSubview:self.tableView];
    [self addFooterBtn];
}

- (void)addFooterBtn {
    UIView *footer = [[UIView alloc] init];
    footer.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), self.view.zl_width, kFooterH + kTabBarH);
    footer.backgroundColor = ZLNavTextColor;
    
    TYWJBorderButton *btn = [[TYWJBorderButton alloc] initWithFrame:CGRectMake(0, 0, self.view.zl_width, kFooterH)];
    [btn addTarget:self action:@selector(payClicked) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:[NSString stringWithFormat:@"确认支付 %@",self.totalFee] forState:UIControlStateNormal];
    [btn setRoundViewWithCornerRaidus:0];
    self.payBtn = btn;
    [footer addSubview:btn];
    [self.view addSubview:footer];
}

- (void)initializePay {
    [MBProgressHUD zl_showMessage:@"正在生成订单" toView:self.view];
    if (self.isSingleTicket) {
        [self paySingleTicketRequest];
    }else {
        [self payMonthTicketRequest];
//        [self payPeriodTicketRequest];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    TYWJNavigationController *navi = (TYWJNavigationController *)self.navigationController;
    navi.isBlockPop = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    TYWJNavigationController *navi = (TYWJNavigationController *)self.navigationController;
    navi.isBlockPop = YES;
}

- (void)dealloc {
    ZLFuncLog;
    [self removeNotis];
    [self invalidateTimer];
}

#pragma mark - 通知相关

- (void)addNotis {
    [ZLNotiCenter addObserver:self selector:@selector(appDidEnterBg) name:TYWJAppDidEnterBgNoti object:nil];
    [ZLNotiCenter addObserver:self selector:@selector(appDidEnterFg) name:TYWJAppDidEnterFgNoti object:nil];
    [ZLNotiCenter addObserver:self selector:@selector(WXPayResult:) name:TYWJWechatPayResultNoti object:nil];
}

- (void)removeNotis {
    [ZLNotiCenter removeObserver:self name:TYWJAppDidEnterBgNoti object:nil];
    [ZLNotiCenter removeObserver:self name:TYWJAppDidEnterFgNoti object:nil];
    [ZLNotiCenter removeObserver:self name:TYWJWechatPayResultNoti object:nil];
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
    if (!self.timer) return;
    
    NSTimeInterval timeinterval = [[NSDate date] timeIntervalSinceDate:self.enteredBgDate];
    NSInteger deltaTime = timeinterval;
    self.count -= deltaTime;
    if (self.count <= 0) {
        [self backToPreVc];
    }else {
        NSInteger minute = self.count/60;
        NSInteger second = self.count%60;
        NSString *leftTime = [NSString stringWithFormat:@"支付倒计时 %02ld:%02ld",(long)minute,(long)second];
        self.header.text = leftTime;
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    TYWJPayCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJPayCellID forIndexPath:indexPath];
    cell.couponClicked = ^{
        TYWJCouponController *couponVc = [[TYWJCouponController alloc] init];
        [weakSelf.navigationController pushViewController:couponVc animated:YES];
    };
    cell.singleTicket = self.singleTicket;
    cell.startStation = self.startStation;
    cell.desStation = self.desStation;
    cell.ticketNums = self.ticketNums;
    cell.ticketDates = self.ticketDates;
    cell.totalFee = self.totalFee;
    cell.info = self.routeListInfo;
    self.selectedPayBtn = cell.alipayBtn;
    if (self.periodTicket) {
        cell.periodTicket = self.periodTicket;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *header = [[UILabel alloc] init];
    header.backgroundColor = ZLColorWithRGB(112, 116, 122);
    header.zl_size = CGSizeMake(self.view.zl_width, 40.f);
    header.textAlignment = NSTextAlignmentCenter;
    header.textColor = [UIColor whiteColor];
    header.font = [UIFont systemFontOfSize:14.f];
    header.text = @"正在生成订单";
    self.header = header;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}

#pragma mark - 定时器

- (void)countDown {
    if (self.count == 0) {
        [self backToPreVc];
    }
    
    NSInteger minute = self.count/60;
    NSInteger second = self.count%60;
    NSString *leftTime = [NSString stringWithFormat:@"支付倒计时 %02ld:%02ld",(long)minute,(long)second];
    self.header.text = leftTime;
    self.count--;
}

- (void)payClicked {
    ZLFuncLog;
    
    [self requestToPay];
}

- (void)backToPreVc {
    [self.timer invalidate];
    self.timer = nil;
    
    [self popToPreVC];
    [MBProgressHUD zl_showError:@"支付超时，请重新购买!"];
    
}

- (void)popToPreVC {
    [self requestQuitTicket];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)validateTimer {
    self.timer = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

- (void)invalidateTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
#pragma mark - 数据请求

- (void)paySingleTicketRequest {
    
    NSDateFormatter *dateFormatter =  [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy.MM.dd";
    NSMutableArray *datesArr = [NSMutableArray array];
    NSMutableArray *ticketNumsArr = [NSMutableArray array];
    for (NSDate *date in self.ticketDates) {
        NSString *dateString = [dateFormatter stringFromDate:date];
        [datesArr addObject:dateString];
        [ticketNumsArr addObject:@(self.ticketNums)];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"yhm"] = [TYWJLoginTool sharedInstance].phoneNum;
    params[@"ch"] = self.routeListInfo.routeNum;
    params[@"gmqszId"] = self.routeListInfo.startStopId;
    params[@"gmzdzId"] = self.routeListInfo.stopStopId;
    params[@"ccsjs"] = datesArr;
    params[@"scsj"] = self.routeListInfo.startingTime;
    params[@"xcsj"] = self.routeListInfo.stopTime;
    params[@"nums"] = ticketNumsArr;
    
    WeakSelf;
    [[ZLHTTPSessionManager manager] POST:[TYWJJsonRequestUrls sharedRequest].purchaseSingleTicket parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD zl_hideHUDForView:self.view];
        if ([responseObject[@"reCode"] intValue] == 201) {
            weakSelf.orderID = responseObject[@"data"][@"id"];
            [weakSelf validateTimer];
        }else if([responseObject[@"reCode"] intValue] == 202) {
            [self jumpToMyTicketVC];
        }else {
            [MBProgressHUD zl_showError:responseObject[@"msg"]];
            weakSelf.header.text = responseObject[@"msg"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        weakSelf.header.text = TYWJWarningBadNetwork;
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:self.view];
    }];
}

- (void)payMonthTicketRequest {
    WeakSelf;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"yhm"] = [TYWJLoginTool sharedInstance].phoneNum;
    params[@"gmqszId"] = self.routeListInfo.startStopId;
    params[@"gmzdzId"] = self.routeListInfo.stopStopId;
    params[@"ch"] = self.routeListInfo.routeNum;
    
    
    [[ZLHTTPSessionManager manager] POST:[TYWJJsonRequestUrls sharedRequest].monthTicketToPay parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD zl_hideHUDForView:self.view];
        if ([responseObject[@"reCode"] intValue] == 201) {
            weakSelf.orderID = responseObject[@"data"][@"id"];
            [weakSelf validateTimer];
        }else {
            [MBProgressHUD zl_showError:responseObject[@"msg"]];
            weakSelf.header.text = @"生成订单失败";
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork];
        weakSelf.header.text = @"网络差，请重试";
    }];
}

- (void)payPeriodTicketRequest {
    WeakSelf;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"yhm"] = [TYWJLoginTool sharedInstance].phoneNum;
    params[@"cplx"] = self.periodTicket.ticketID;
    params[@"cs"] = self.periodTicket.cityID;
    
    [[ZLHTTPSessionManager manager] POST:[TYWJJsonRequestUrls sharedRequest].periodTicketToPay parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD zl_hideHUDForView:self.view];
        if ([responseObject[@"reCode"] intValue] == 201) {
            weakSelf.orderID = responseObject[@"data"][@"id"];
            [weakSelf validateTimer];
        }else {
            [MBProgressHUD zl_showError:responseObject[@"msg"]];
            weakSelf.header.text = @"生成订单失败";
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork];
        weakSelf.header.text = @"网络差，请重试";
    }];
}

- (void)requestPay {
    WeakSelf;
    [MBProgressHUD zl_showMessage:@"正在调起支付,请稍后"];
//    [SVProgressHUD zl_showSuccessWithStatus:@"1---开始微信支付请求成功"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.orderID;
    params[@"orderType"] = @"zfb";
    if (!self.selectedPayBtn.selected) {
        params[@"orderType"] = @"weixin";
        params[@"realIp"] = self.wxPayIp;
    }
    
//    [SVProgressHUD zl_showSuccessWithStatus:[NSString stringWithFormat:@"3---开始微信支付请求成功--%@",params]];
    
    [[ZLHTTPSessionManager manager] POST:[TYWJJsonRequestUrls sharedRequest].toPay parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        [SVProgressHUD zl_showSuccessWithStatus:@"2---开始微信支付请求成功"];
        
        if ([responseObject[@"reCode"] intValue] == 201) {
            [MBProgressHUD zl_hideHUD];
            //这里判断选择的哪种支付方式进行支付
            if (self.selectedPayBtn.selected) {
                //支付宝
                [weakSelf alipayWithOrderString: responseObject[@"data"][@"url"]];
            }else {
                //微信
//                [SVProgressHUD zl_showSuccessWithStatus:@"3---开始微信支付请求成功--%@"];
                [self weChatPayWithData:responseObject[@"data"]];
            }
            
        }else {
           [MBProgressHUD zl_showError:@"调起支付失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([[TYWJCommonTool sharedTool] returnRequestErrorInfoWithError:error]) {
            return;
        }
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork];
    }];
}

- (void)requestToPay {
    if (!self.orderID) {
        [MBProgressHUD zl_showError:@"没有成功生成订单，请返回重试"];
        return;
    }
    if (!self.selectedPayBtn.selected) {
        WeakSelf;
        [TYWJCommonTool requestIPAdressSuccessHandler:^(NSString *ip) {
            weakSelf.wxPayIp = ip;
            [weakSelf requestPay];
        }];
    }else {
        [self requestPay];
    }
}

- (void)alipayWithOrderString:(NSString *)orderString {
    //应用注册scheme,在AliSDKDemo-Info.plist定义URL type
    // NOTE: 调用支付结果开始支付
    [self invalidateTimer];
    self.header.text = @"正在支付";
    
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
            
            [self popToPreVC];
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
    [self invalidateTimer];
    self.header.text = @"正在支付";
    
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
    
    BOOL result = [WXApi sendReq: request];
    if (result) {
        [MBProgressHUD zl_showSuccess:@"调起微信支付成功"];
    }else {
        [MBProgressHUD zl_showSuccess:@"调起微信支付失败"];
    }
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
                [self popToPreVC];
            }
                break;
            case -2:
            {
                //用户退出支付
                payResult = @"用户已经退出支付!";
                ZLLog(@"%@", payResult);
                [MBProgressHUD zl_showError:payResult];
                [self popToPreVC];
            }
                break;
            default:
            {
                //支付失败，直接返回上个界面
                payResult = [NSString stringWithFormat:@"支付失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                ZLLog(@"%@", payResult);
                [MBProgressHUD zl_showError:payResult];
                [self popToPreVC];
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

#pragma mark - 数据请求

- (void)requestQuitTicket {
    
//    [MBProgressHUD zl_showMessage:@"取消订单中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = self.orderID;

    [[ZLHTTPSessionManager manager] POST:[TYWJJsonRequestUrls sharedRequest].cancelOrder parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"reCode"] intValue] == 201) {
            ZLLog(@"取消订单成功");
//            [MBProgressHUD zl_showSuccess:@"取消成功"];

        }else {
//            [MBProgressHUD zl_showSuccess:responseObject[@"codeTxt"]];
            ZLLog(@"取消订单失败--%@",responseObject[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[TYWJCommonTool sharedTool] returnRequestErrorInfoWithError:error];

    }];
}
@end
