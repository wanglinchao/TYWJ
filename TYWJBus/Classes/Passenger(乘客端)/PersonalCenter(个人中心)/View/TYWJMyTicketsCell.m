//
//  TYWJMyTicketsCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/15.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJMyTicketsCell.h"
#import "TYWJCheckTicketBtn.h"
#import "ZLPopoverView.h"
#import "TYWJTicketList.h"
#import "TYWJApplyRoute.h"
#import "TYWJMyTicketTableCell.h"
#import "TYWJComplaintController.h"
#import "TYWJSoapTool.h"
#import "TYWJDetailRouteController.h"
#import "TYWJMonthTicket.h"

#import <MJExtension.h>

NSString * const TYWJMyTicketsCellID = @"TYWJMyTicketsCellID";

static CGFloat const kRowH = 50.f;

@interface TYWJMyTicketsCell()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet TYWJCheckTicketBtn *verifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *ticketTypeBtn;
@property (weak, nonatomic) IBOutlet UILabel *getupDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeStationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *endStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketLicenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
/* 验票后的颜色 */
@property (strong, nonatomic) UIColor *checkedColor;
@property (weak, nonatomic) IBOutlet UIView *cView;
@property (weak, nonatomic) IBOutlet UIView *leftCircle;
@property (weak, nonatomic) IBOutlet UIView *rightCircle;
@property (weak, nonatomic) IBOutlet UILabel *tickeetIDLabel;


/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* dataList */
@property (strong, nonatomic) NSArray *dataList;
/* dateFormatter */
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation TYWJMyTicketsCell

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.rowHeight = kRowH;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJMyTicketTableCell class]) bundle:nil] forCellReuseIdentifier:TYWJMyTicketTableCellID];
    }
    return _tableView;
}

- (UIColor *)checkedColor {
    if (!_checkedColor) {
        _checkedColor = ZLNavTextColor;
    }
    return _checkedColor;
}

#pragma mark - set up view
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupView];
}

- (void)setupView {
    [self.cView setRoundViewWithCornerRaidus:10.f];
    self.cView.backgroundColor = [UIColor whiteColor];
    
    self.backgroundColor = [UIColor clearColor];
    [self.verifyBtn setBorderWidth:0];
    __weak typeof(self) weakSelf = self;
    self.verifyBtn.checkTicketSuc = ^{
        //验票动画成功结束
        
        [weakSelf verifyTicket];
    };
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    self.leftCircle.backgroundColor = ZLColorWithRGB(112, 116, 122);
    self.rightCircle.backgroundColor = ZLColorWithRGB(112, 116, 122);
    [self.leftCircle setRoundView];
    [self.rightCircle setRoundView];
    
}




- (void)setTicket:(TYWJTicketListInfo *)ticket {
    _ticket = ticket;
    
    if (ticket) {
        
        self.verifyBtn.hidden = NO;
        self.tipsLabel.hidden = NO;
        
        [self.verifyBtn stopSuccAnimation];
        
        self.tickeetIDLabel.text = [NSString stringWithFormat:@"行程费id:%@",ticket.ticketToken];
        
        self.titleLabel.text = ticket.routeName;
        self.getupDateLabel.text = ticket.getupDate;
        self.routeStationsLabel.text = [NSString stringWithFormat:@"%@——%@",ticket.startStation,ticket.desStation];
        self.startTimeLabel.text = ticket.getupTime;
        self.endTimeLabel.text = ticket.getdownTime;
        self.startStationLabel.text = ticket.beginStation;
        self.endStationLabel.text = ticket.endStation;
        NSString *carLicense = @"车辆安排中...";
        if (ticket.carLicense && ![ticket.carLicense isEqualToString:@""]) {
            carLicense = ticket.carLicense;
        }
        self.ticketLicenseLabel.text = carLicense;
        [self.ticketTypeBtn setTitle:@"单次行程费" forState:UIControlStateNormal];
        if ([ticket.status isEqualToString:@"已乘车"]) {
            self.verifyBtn.userInteractionEnabled = NO;
            [self.verifyBtn setImage:[UIImage imageNamed:@"icon_oka"] forState:UIControlStateNormal];
            [self.verifyBtn setBorderColor: self.checkedColor];
            [self.verifyBtn setBorderWidth:3.f];
            [self.verifyBtn startSuccAnimation];
            
            self.ticketLicenseLabel.font = [UIFont systemFontOfSize:25.f];
            self.ticketLicenseLabel.textColor = ZLColorWithRGB(255, 135, 36);
            self.tipsLabel.text = @"已验证";
            self.tipsLabel.font = [UIFont systemFontOfSize:20.f];
            self.tipsLabel.textColor = self.checkedColor;
        }else {
            self.verifyBtn.userInteractionEnabled = YES;
            [self.verifyBtn setImage:[UIImage imageNamed:@"fingerprint_61x61_"] forState:UIControlStateNormal];
            [self.verifyBtn setBorderColor: [UIColor whiteColor]];
            [self.verifyBtn setBorderWidth:1.f];
            self.ticketLicenseLabel.font = [UIFont systemFontOfSize:12.f];
            self.ticketLicenseLabel.textColor = [UIColor blackColor];
            self.tipsLabel.text = @"请长按验证~~";
            self.tipsLabel.font = [UIFont systemFontOfSize:14.f];
            self.tipsLabel.textColor = [UIColor darkGrayColor];
        }
    }
}

- (void)setMonthTicket:(TYWJMonthTicket *)monthTicket {
    _monthTicket = monthTicket;
    
    self.verifyBtn.hidden = YES;
    self.tipsLabel.hidden = YES;
    
    self.tickeetIDLabel.text = [NSString stringWithFormat:@"行程费id:%@",monthTicket.orderId];
    
    self.titleLabel.text = monthTicket.xlmc;
    self.getupDateLabel.text = [NSString stringWithFormat:@"%@月份月行程费",monthTicket.yf];
    self.routeStationsLabel.text = [NSString stringWithFormat:@"%@——%@",monthTicket.gmqsz,monthTicket.gmzdz];
    self.startTimeLabel.text = monthTicket.scsj;
    self.endTimeLabel.text = monthTicket.xcsj;
    self.startStationLabel.text = monthTicket.gmqsz;
    self.endStationLabel.text = monthTicket.gmzdz;
    NSString *carLicense = @"车辆安排中...";
    if (monthTicket.chp && ![monthTicket.chp isEqualToString:@""]) {
        carLicense = monthTicket.chp;
    }
    self.ticketLicenseLabel.text = carLicense;
    [self.ticketTypeBtn setTitle:@"月行程费" forState:UIControlStateNormal];
}

#pragma mark - 长按
- (void)verifyTicket {
    ZLFuncLog;
    //验票
    NSString *timeString = nil;
    timeString = [NSString stringWithFormat:@"%@",self.ticket.getupDate];
    self.dateFormatter.dateFormat = @"yyyy.MM.dd";
    
    NSDate *date = [NSDate date];
    NSTimeInterval nowTime = [[self.dateFormatter dateFromString: [self.dateFormatter stringFromDate: date]] timeIntervalSince1970];
    NSTimeInterval getupTime = [[self.dateFormatter dateFromString:timeString] timeIntervalSince1970];
    if (getupTime != nowTime) {
        [self.verifyBtn setImage:[UIImage imageNamed:@"fingerprint_61x61_"] forState:UIControlStateNormal];
        [self.verifyBtn removeAnimLayer];
        [[ZLPopoverView sharedInstance] showSingleBtnViewWithTips:@"上车当天才可以验证哦~"];
        return;
    }
    //开始验票
    [self checkTicket];
}

#pragma mark - 按钮点击

- (IBAction)moreBtnClicked:(UIButton *)sender {
    ZLFuncLog;
    [self loadDataList];
    [[ZLPopoverView sharedInstance] showPopBubbleViewWithView:sender showingView:self.tableView showingViewH:kRowH*self.dataList.count];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJMyTicketTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJMyTicketTableCellID forIndexPath:indexPath];
    TYWJApplyRoute *model = self.dataList[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            //分享路线
            TYWJDetailRouteController *vc = [[TYWJDetailRouteController alloc] init];
            vc.isDetailRoute = NO;
            vc.ticket = self.ticket;
            vc.monthTicket = self.monthTicket;
            [TYWJCommonTool pushToVc:vc];
            [[ZLPopoverView sharedInstance] hide];
        }
            break;
        case 1:
        {
            //投诉
            TYWJComplaintController *vc = [[TYWJComplaintController alloc] init];
            vc.ticket = self.ticket;
            [TYWJCommonTool pushToVc:vc];
            [[ZLPopoverView sharedInstance] hide];
        }
            break;
        case 2:
        {
            //退票
            [[ZLPopoverView sharedInstance] hide];
            [[ZLPopoverView sharedInstance] showTipsViewWithTips:@"确定退款吗?" leftTitle:@"取消" rightTitle:@"确定" RegisterClicked:^{
                //进入退票原因界面
                TYWJComplaintController *vc = [[TYWJComplaintController alloc] init];
                vc.isRefundTicket = YES;
                vc.ticket = self.ticket;
                [TYWJCommonTool pushToVc:vc];
            }];
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 数据请求
- (void)loadDataList {
    NSString *path = nil;
    if ([self.ticket.status isEqualToString:@"已乘车"] || self.monthTicket) {
        path = [[NSBundle mainBundle] pathForResource:TYWJMyTicketList1Plist ofType:nil];
    }else {
        path = [[NSBundle mainBundle] pathForResource:TYWJMyTicketListPlist ofType:nil];
    }
    
    if (path) {
        self.dataList = [NSArray arrayWithContentsOfFile:path];
        self.dataList = [TYWJApplyRoute mj_objectArrayWithKeyValuesArray:self.dataList];
        [self.tableView reloadData];
    }
}


- (void)checkTicket {
    WeakSelf;
    NSString *ticketID = ticketID = self.ticket.ticketID;
    
    NSString *soapBodyStr = [NSString stringWithFormat:
                              @"<%@ xmlns=\"%@\">\
                              <chepiaoid>%@</chepiaoid>\
                              </%@>",TYWJRequestCheckTicket,TYWJRequestService, ticketID,TYWJRequestCheckTicket];
    
    [TYWJSoapTool SOAPDataWithSoapBody:soapBodyStr success:^(id responseObject) {
        if ([responseObject[0][@"NS1:shangcheResponse"] isEqualToString:@"ok"]) {
            [MBProgressHUD zl_showSuccess:@"验证成功"];
            [self.verifyBtn startSuccAnimation];
            [weakSelf.verifyBtn setImage:[UIImage imageNamed:@"icon_oka"] forState:UIControlStateNormal];
            weakSelf.ticketLicenseLabel.font = [UIFont systemFontOfSize:25.f];
            weakSelf.ticketLicenseLabel.textColor = ZLColorWithRGB(255, 135, 36);
            weakSelf.tipsLabel.text = @"验证成功!";
            weakSelf.tipsLabel.font = [UIFont systemFontOfSize:20.f];
            weakSelf.tipsLabel.textColor = self.checkedColor;
            weakSelf.ticket.status = @"已乘车";
        }else {
            [weakSelf.verifyBtn setImage:[UIImage imageNamed:@"fingerprint_61x61_"] forState:UIControlStateNormal];
            [weakSelf.verifyBtn removeAnimLayer];
            [MBProgressHUD zl_showError:@"验证失败"];
        }
    } failure:nil];
}
@end
