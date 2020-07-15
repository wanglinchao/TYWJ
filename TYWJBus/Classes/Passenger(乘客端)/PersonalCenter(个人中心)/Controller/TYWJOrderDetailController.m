//
//  TYWJOrderDetailController.m
//  TYWJBus
//
//  Created by tywj on 2020/6/5.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJOrderDetailController.h"
#import "TYWJBottomPurchaseView.h"
#import "TYWJOrderDetail.h"
#import "TYWJCarProtocolController.h"
#import "TYWJPayController.h"
#import "TYWJCalendarView.h"
#import "TYWJCalendarModel.h"
#import "TYWJDetailRouteController.h"
#import "TYWJRouteList.h"
#import "TYWJCalendarModel.h"
#define ContentViewHeight 712 -246 + CalendarViewHeight + 10

@interface TYWJOrderDetailController ()
@property (strong, nonatomic) TYWJBottomPurchaseView *bottomView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet UIView *bottomV;
@property (strong, nonatomic) TYWJOrderDetail *dataModel;
@property (strong, nonatomic) TYWJTripList *tripList;

@property (weak, nonatomic) IBOutlet UILabel *upL;
@property (weak, nonatomic) IBOutlet UILabel *downL;
@property (weak, nonatomic) IBOutlet UILabel *numL;
@property (weak, nonatomic) IBOutlet UILabel *startTimeL;
@property (weak, nonatomic) IBOutlet UILabel *order_serial_noL;
@property (weak, nonatomic) IBOutlet UILabel *lineNameL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;

@property (weak, nonatomic) IBOutlet UILabel *creatTimeL;
@property (weak, nonatomic) IBOutlet UILabel *payTimeL;
@property (weak, nonatomic) IBOutlet UILabel *refundAmoutL;
@property (weak, nonatomic) IBOutlet UILabel *discountAmoutL;
@property (weak, nonatomic) IBOutlet UILabel *orderAmountL;

@property (weak, nonatomic) IBOutlet UILabel *payAmountL;
@property (weak, nonatomic) IBOutlet UIButton *refundBtn;
@property (weak, nonatomic) IBOutlet UIView *calendarContentView;
@property (strong, nonatomic) TYWJCalendarView *calendarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *payTitleL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payTitleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payTimeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refundTitleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refundHeight;
@property (weak, nonatomic) IBOutlet UILabel *refundL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payTopHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refundTopHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payTimeTopHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refundAmountTopHeight;

@end

@implementation TYWJOrderDetailController
#pragma mark - 懒加载

- (TYWJBottomPurchaseView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[TYWJBottomPurchaseView alloc] initWithFrame:CGRectMake(0, 0, self.bottomV.zl_width, self.bottomV.zl_height)];
        _bottomView.showTips = YES;
        [_bottomView setTitle: @"支付"];
        [_bottomView setPrice: @"0"];
        [_bottomView setTipsWithNum:0];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView addTarget:self action:@selector(purchaseClicked)];
        
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.scrollView.contentSize = CGSizeMake(ZLScreenWidth, ContentViewHeight);
    self.bottomV.zl_width = ZLScreenWidth;
    self.bottomV.zl_height += kTabBarH;
    self.contentView.zl_width = ZLScreenWidth;
    [self.bottomV addSubview:self.bottomView];
    [self.scrollView addSubview:self.contentView];
    self.calendarViewHeight.constant = CalendarViewHeight;
    self.calendarView = [[TYWJCalendarView alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth - 32, CalendarViewHeight )];
    self.calendarView.type = 1;
    [self.calendarContentView addSubview:self.calendarView];
    
    
    [self loadData];
    
    [self addNotis];
}
#pragma mark - 通知
- (void)addNotis {
    [ZLNotiCenter addObserver:self selector:@selector(showTicketDetail:) name:@"TYWJShowTicketDetail" object:nil];
}
- (void)removeNotis {
    [ZLNotiCenter removeObserver:self name:@"TYWJShowTicketDetail" object:nil];
}
- (void)dealloc {
    ZLFuncLog;
    [self removeNotis];
}
- (void)showTicketDetail:(NSNotification *)noti {
    TYWJCalendarModel *modell = [noti object];
    TYWJDetailRouteController *detailRouteVc = [[TYWJDetailRouteController alloc] init];
    TYWJRouteListInfo *model = [[TYWJRouteListInfo alloc] init];
    model.line_info_id = [NSString stringWithFormat:@"%@",self.dataModel.line_code];
    detailRouteVc.isDetailRoute = NO;
    detailRouteVc.routeListInfo = model;
    self.tripList.line_date = modell.line_date;
    self.tripList.ticket_code = modell.ticket_code;
    self.tripList.number = modell.number;
    self.tripList.refund_number = modell.refund_number;
    self.tripList.status = modell.status;
    self.tripList.vehicle_no = modell.vehicle_no;
    detailRouteVc.tripListInfo = self.tripList;
    [self.navigationController pushViewController:detailRouteVc animated:YES];
    
}
- (void)loadData{
    NSDictionary *param = @{
        @"order_serial_no": self.model.order_serial_no,
    };
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.91:9005/ticket/orderinfo/search/order/detail" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        NSDictionary *dicc = [dic objectForKey:@"data"];
        if (dicc) {
            self.dataModel = [TYWJOrderDetail mj_objectWithKeyValues:dicc];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dicc];
            [dic setValue:[dicc objectForKey:@"get_off_loc"] forKey:@"getoff_loc"];
            [dic setValue:[dicc objectForKey:@"get_off_time"] forKey:@"getoff_time"];
            [dic setValue:[dicc objectForKey:@"get_on_loc"] forKey:@"geton_loc"];
            [dic setValue:[dicc objectForKey:@"get_on_time"] forKey:@"geton_time"];
            
            
            
            
            
            self.tripList =  [TYWJTripList mj_objectWithKeyValues:dic];
            [self setupView];
        }
    } WithFailurBlock:^(NSError *error) {
    }];
}
- (void)setupView{
    NSArray *arr = [TYWJCalendarModel mj_objectArrayWithKeyValuesArray:self.dataModel.calender];
    
    [_calendarView confirgCellWithModel:arr];
    if (self.dataModel.order_status == 0) {
        self.bottomViewHeight.constant = 49;
        self.refundBtn.hidden = YES;
    } else{
        self.bottomViewHeight.constant = 0;
        
    }
    [_bottomView setPrice:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%d",self.dataModel.order_fee]]];
    self.lineNameL.text= self.dataModel.line_name;
    self.upL.text = self.dataModel.get_on_loc;
    self.downL.text = self.dataModel.get_off_loc;
    self.numL.text = [NSString stringWithFormat:@"%d",self.dataModel.number];
    self.startTimeL.text = self.dataModel.line_time;
    self.statusL.text = [TYWJCommonTool getOrderStatusWithStatus:self.dataModel.order_status];
    self.order_serial_noL.text = self.dataModel.order_serial_no;
    self.creatTimeL.text = self.dataModel.order_time;
    NSInteger hiddenHeight = 0;
    if (self.dataModel.pay_time) {
        self.payTimeL.text = self.dataModel.pay_time;
    } else {
        hiddenHeight += 25;
        _payTitleL.hidden = YES;
        _payTimeHeight.constant = 0;
        _payTitleHeight.constant = 0;
        _payTopHeight.constant = 0;
        _payTimeTopHeight.constant = 0;
    }
    if (self.dataModel.refund_fee) {
        self.refundAmoutL.text = [NSString stringWithFormat:@"¥%@",self.dataModel.refund_fee];
    } else {
        hiddenHeight += 25;
        _refundL.hidden = YES;
        _refundHeight.constant = 0;
        _refundTitleHeight.constant = 0;
        _refundTopHeight.constant = 0;
        _refundAmountTopHeight.constant = 0;
    }
    
    self.totalHeight.constant = 212 - hiddenHeight;
    self.scrollView.contentSize = CGSizeMake(ZLScreenWidth, ContentViewHeight - hiddenHeight);
    self.orderAmountL.text = [NSString stringWithFormat:@"¥%@",GetPriceString(self.dataModel.order_fee)];
    self.discountAmoutL.text = [NSString stringWithFormat:@"¥%@",GetPriceString(self.dataModel.discount_fee)];
    
    self.payAmountL.text = [NSString stringWithFormat:@"¥%@",GetPriceString(self.dataModel.pay_fee)];
    
}
- (void)purchaseClicked{
    NSDictionary *param =@{
        @"getoff_loc": self.dataModel.get_off_loc,
        @"geton_loc": self.dataModel.get_on_loc,
        @"goods": self.dataModel.calender,
        @"line_code": self.dataModel.line_code?self.dataModel.line_code:@"",
        @"line_time": self.dataModel.line_time,
        @"money": @(self.dataModel.order_fee),
        @"number": @(self.dataModel.number),
        @"line_name":self.dataModel.line_name
    };
    TYWJPayController *payVc = [[TYWJPayController alloc] init];
    payVc.order_no = self.dataModel.order_serial_no;
    payVc.paramDic = [NSMutableDictionary dictionaryWithDictionary:param];
    [TYWJCommonTool pushToVc:payVc];
}
- (IBAction)refundAgreement:(id)sender {
    
    TYWJCarProtocolController *vc = [[TYWJCarProtocolController alloc] init];
    vc.type = TYWJCarProtocolControllerTypeRefundTicketingInformation;
    [self.navigationController pushViewController:vc animated:YES];
    
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
