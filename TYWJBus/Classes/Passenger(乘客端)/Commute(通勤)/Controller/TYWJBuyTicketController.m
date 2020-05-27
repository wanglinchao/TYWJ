//
//  TYWJBuyTicketController.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/6.
//  Copyright © 2018 Harley He. All rights reserved.
//  购票界面

#import "TYWJBuyTicketController.h"
#import "TYWJBottomPurchaseView.h"
#import "TYWJBuyTicketChooseTypeCell.h"
#import "TYWJChooseStopsCell.h"
#import "ZLPopoverView.h"
#import "TYWJSoapTool.h"
#import "TYWJRouteList.h"
#import "TYWJSubRouteList.h"
#import "TYWJSearchReult.h"
#import "TYWJChooseStationView.h"

#import "TYWJPayController.h"
#import "TYWJCarProtocolController.h"
#import "TYWJCalendarCell.h"
#import "ZLCalendarView.h"
#import "TYWJMonthTicketCell.h"
#import "TYWJLoginTool.h"
#import "TYWJJsonRequestUrls.h"
#import "ZLHTTPSessionManager.h"
#import "TYWJCalendarList.h"
#import "TYWJMonthTicketDetailInfo.h"
#import <MJExtension.h>

static CGFloat const kBottomViewH = 56.f;

@interface TYWJBuyTicketController ()<UITableViewDelegate,UITableViewDataSource,TYWJCalendarCellDelegate>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* bottomView */
@property (strong, nonatomic) TYWJBottomPurchaseView *bottomView;
/* selectedBtn */
@property (weak, nonatomic) UIButton *selectedBtn;
/* 是否选中的是单次票 */
@property (assign, nonatomic, getter=isSingleTicket) BOOL singleTicket;
/* 票价 */
@property (assign, nonatomic) CGFloat ticketPrice;
/* ZLCalendarView */
@property (weak, nonatomic) ZLCalendarView *cusCalendar;
/* dateFormatter */
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
/* 车票nums */
@property (assign, nonatomic) int ticketNums;
/* 月票信息 */
@property (strong, nonatomic) TYWJMonthTicketDetailInfo *monthInfo;


@end

@implementation TYWJBuyTicketController
#pragma mark - 懒加载
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy.MM.dd";
    }
    return _dateFormatter;
}
- (TYWJBottomPurchaseView *)bottomView {
    if (!_bottomView) {
        CGFloat h = kTabBarH + kBottomViewH;
        _bottomView = [[TYWJBottomPurchaseView alloc] initWithFrame:CGRectMake(0, self.view.zl_height - h, self.view.zl_width, h)];
        _bottomView.showTips = YES;
        [_bottomView setPrice: @"0"];
        [_bottomView setTipsWithNum:0];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView addTarget:self action:@selector(purchaseClicked)];

    }
    return _bottomView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.zl_width, self.view.zl_height - kTabBarH - kBottomViewH) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJBuyTicketChooseTypeCell class]) bundle:nil] forCellReuseIdentifier:TYWJBuyTicketChooseTypeCellID];
        [_tableView registerClass:[TYWJChooseStopsCell class] forCellReuseIdentifier:TYWJChooseStopsCellID];
        [_tableView registerClass:[TYWJCalendarCell class] forCellReuseIdentifier:TYWJCalendarCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"TYWJMonthTicketCell" bundle:nil] forCellReuseIdentifier:TYWJMonthTicketCellID];
    }
    return _tableView;
}


#pragma mark - 通知相关

- (void)addNotis {
   [ZLNotiCenter addObserver:self selector:@selector(ticketNumsDidChange:) name:TYWJTicketNumsDidChangeNoti object:nil];
}

- (void)removeNotis {
    [ZLNotiCenter removeObserver:self name:TYWJTicketNumsDidChangeNoti object:nil];
}

- (void)ticketNumsDidChange:(NSNotification *)noti {
    ZLFuncLog;
    NSNumber *obj = noti.object;
    self.ticketNums = [obj intValue];
    [self setPriceAndNums];
}

#pragma mark - set up view
- (void)dealloc {
    ZLFuncLog;
    [self removeNotis];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNotis];
    [self setupView];
    [self loadData];
    [self loadTicketPriceData];
    [self requestLastSeats];
    [self requestMonthTicketInfo];
}

- (void)setupView {
    NSString *navTitle = self.routeListInfo.routeName;
    if (self.result) {
        navTitle = self.result.routeInfo.routeName;
    }
    self.navigationItem.title = navTitle;//@"购票";
    self.title = @"胖哒自由行";
    self.singleTicket = YES;
    self.ticketNums = 1;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"购买说明" forState:UIControlStateNormal];
        [button setTitleColor:ZLNavTextColor forState:UIControlStateNormal];
        button.zl_size = CGSizeMake(80, 30);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(purchaseDescriptionClicked) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    }
#pragma mark - 请求数据

- (void)loadData {
    if (self.routeLists) return;
    
    WeakSelf;
    NSString * soapBodyStr = [NSString stringWithFormat:
                              @"<%@ xmlns=\"%@\">\
                              <xlbh>%@</xlbh>\
                              </%@>",TYWJRequesrSubRouteList,TYWJRequestService,self.routeListInfo.routeNum,TYWJRequesrSubRouteList];
    [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:soapBodyStr success:^(id responseObject) {
        if (responseObject) {
            ZLFuncLog;
            NSArray *dataArr = responseObject[0][@"NS1:xianlubiaozibiaoResponse"][@"xianlubiaozibiaoList"][@"xianlubiaozibiao"];
            if (dataArr) {
                weakSelf.routeLists = [TYWJSubRouteList mj_objectArrayWithKeyValuesArray:dataArr];
                TYWJSubRouteList *info1 = weakSelf.routeLists.firstObject;
                weakSelf.routeListInfo.startStopId = info1.routeListInfo.stationID;
                TYWJSubRouteList *info2 = weakSelf.routeLists.lastObject;
                weakSelf.routeListInfo.stopStopId = info2.routeListInfo.stationID;
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:self.view];
    }];
    
}

- (void)loadTicketPriceData {

    if (self.singleTicket == NO) {
        //如果是月票就不进行这个操作
        return;
    }
    
    NSString *ticketPrice = self.routeListInfo.price;
    
    self.ticketPrice = ticketPrice.doubleValue;
    NSInteger num = self.cusCalendar.selectedDates.count;
    if (self.isSingleTicket) {
        NSString *priceStr = [NSString stringWithFormat:@"%.02f",self.ticketPrice*num];
        [self.bottomView setPrice:priceStr];
        [self.bottomView setTipsWithNum:num];
    }
    WeakSelf;
    NSString * soapBodyStr = [NSString stringWithFormat:
                              @"<%@ xmlns=\"%@\">\
                              <xianlu>%@</xianlu>\
                              <qsz>%@</qsz>\
                              <zdz>%@</zdz>\
                              </%@>",TYWJRequestGetTicketPrice,TYWJRequestService,self.routeListInfo.routeNum,self.routeListInfo.startingStop ,self.routeListInfo.stopStop ,TYWJRequestGetTicketPrice];
    
    [TYWJSoapTool SOAPDataWithSoapBody:soapBodyStr success:^(id responseObject) {
        NSString *ticketPrice = responseObject[0][@"NS1:piaojiaResponse"];
        
        weakSelf.ticketPrice = ticketPrice.doubleValue;
        NSInteger num = self.cusCalendar.selectedDates.count;
        if (weakSelf.ticketPrice < 0) {
            [MBProgressHUD zl_showError:@"选择了错误的出发站或终点站，请重新选择"];
        }
        if (weakSelf.isSingleTicket) {
            NSString *priceStr = [NSString stringWithFormat:@"%.02f",weakSelf.ticketPrice*num];
            [weakSelf.bottomView setPrice:priceStr];
            [weakSelf.bottomView setTipsWithNum:num];
        }else {
            int days = [TYWJCommonTool sharedTool].nextMonthDays;
            NSString *priceStr = [NSString stringWithFormat:@"%.02f",weakSelf.ticketPrice*days];
            [weakSelf.bottomView setPrice:priceStr];
            NSArray *paths = @[[NSIndexPath indexPathForRow:3 inSection:0],[NSIndexPath indexPathForRow:1 inSection:0]];
            [weakSelf.tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
        }
        
    } failure:nil];
}

- (void)canBuySingleTicketWithDate:(NSDate *)date cell:(ZLCalendarCell *)cell {
    WeakSelf;
    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:self.view];
    self.dateFormatter.dateFormat = @"yyyy.MM.dd";
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    NSString * soapBodyStr = [NSString stringWithFormat:
                              @"<%@ xmlns=\"%@\">\
                              <ccrq>%@</ccrq>\
                              <xl>%@</xl>\
                              <qsz>%@</qsz>\
                              <zdz>%@</zdz>\
                              </%@>",TYWJRequestCanBuySingleTicket,TYWJRequestService,dateString,self.routeListInfo.routeNum ,self.routeListInfo.startStopId ,self.routeListInfo.stopStopId,TYWJRequestCanBuySingleTicket];
    [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:soapBodyStr success:^(id responseObject) {
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        if ([responseObject[0][@"NS1:checkgoupiaoResponse"] isEqualToString:@"false"]) {
            [MBProgressHUD zl_showAlert:@"当天不支持购买" afterDelay:1.5f];
            [weakSelf.cusCalendar deSelectWithCell:cell date:date];
        }else {
            [weakSelf requestLastSeatsWithDatestring:dateString cell:cell date:date];

        }
    } failure:^(NSError *error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:self.view];
        [weakSelf.cusCalendar deSelectWithCell:cell date:date];
    }];

}

- (void)requestLastSeatsWithDatestring:(NSString *)dateString cell:(ZLCalendarCell *)cell date:(NSDate *)date {
    WeakSelf;
    NSString * soapBodyStr = [NSString stringWithFormat:
                              @"<%@ xmlns=\"%@\">\
                              <ccrq>%@</ccrq>\
                              <xl>%@</xl>\
                              <qsz>%@</qsz>\
                              <zdz>%@</zdz>\
                              </%@>",TYWJRequestGetLastSeats,TYWJRequestService,dateString,self.routeListInfo.routeNum ,self.routeListInfo.startStopId ,self.routeListInfo.stopStopId,TYWJRequestGetLastSeats];
    [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:soapBodyStr success:^(id responseObject) {
        [MBProgressHUD zl_hideHUDForView:self.view];
        NSString *num = responseObject[0][@"NS1:getkucunResponse"];
        if (!num) {
            [weakSelf.cusCalendar deSelectWithCell:cell date:date];
            return;
        }
        if (num.intValue < 1) {
            [weakSelf.cusCalendar deSelectWithCell:cell date:date];
            [MBProgressHUD zl_showError:@"已售罄" toView:weakSelf.view];
            return;
        }
        [weakSelf setPriceAndNums];
    } failure:^(NSError *error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:weakSelf.view];
        [weakSelf.cusCalendar deSelectWithCell:cell date:date];
    }];
    
}

/**
 获取剩余座位
 */
- (void)requestLastSeats {
    
    WeakSelf;
    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"yhm"] = [TYWJLoginTool sharedInstance].phoneNum;
    params[@"xlbh"] = self.routeListInfo.routeNum;
    [[ZLHTTPSessionManager manager] POST:[TYWJJsonRequestUrls sharedRequest].lastSeats parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        if ([responseObject[@"reCode"] intValue] == 201) {
            weakSelf.lastSeats = [TYWJCalendarList mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            ZLLog(@"");
            [weakSelf.cusCalendar reloadCalendar];
        }else {
            [MBProgressHUD zl_showError:responseObject[@"codeTxt"] toView:weakSelf.view];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:weakSelf.view];
    }];
}

- (void)requestMonthTicketInfo {
    WeakSelf;
//    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"xlbh"] = self.routeListInfo.routeNum;
    [[ZLHTTPSessionManager manager] POST:[TYWJJsonRequestUrls sharedRequest].detailRoute parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZLLog(@"response---%@",responseObject);
        if ([responseObject[@"reCode"] intValue] == 201) {
            weakSelf.monthInfo = [TYWJMonthTicketDetailInfo mj_objectWithKeyValues:responseObject[@"data"]];
            if (weakSelf.monthInfo.sfyp && weakSelf.monthInfo.ypOpenTime) {
//                weakSelf.singleTicket = NO;
                [weakSelf.tableView reloadData];
            }
//            ZLLog(@"");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:weakSelf.view];
    }];
}

#pragma mark - 按钮点击

- (void)purchaseClicked {
    ZLFuncLog;
    ZLLog(@"selectedDates---%@",self.cusCalendar.selectedDates);
    if (self.isSingleTicket && self.cusCalendar.selectedDates.count == 0) {
        [MBProgressHUD zl_showAlert:@"请选择乘车日期" afterDelay:1.5f];
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    TYWJChooseStopsCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        
        TYWJPayController *payVc = [[TYWJPayController alloc] init];
        payVc.startStation = [self.routeLists[0] valueForKeyPath:@"station"];
        payVc.desStation = [self.routeLists.lastObject valueForKeyPath:@"station"];
        payVc.routeListInfo = self.routeListInfo;
        payVc.singleTicket = self.isSingleTicket;
        if (!self.isSingleTicket) {
            NSInteger days = self.monthInfo.ypDays;
            payVc.totalFee = [NSString stringWithFormat:@"¥%.02f",days*self.monthInfo.ypjg.floatValue];
        }else {
            payVc.routeListInfo = self.routeListInfo;
            payVc.ticketDates = self.cusCalendar.selectedDates;
            payVc.totalFee = [NSString stringWithFormat:@"¥%.02f",self.cusCalendar.selectedDates.count*self.ticketPrice*self.ticketNums];
            payVc.ticketNums = self.ticketNums;
        }
        [self.navigationController pushViewController:payVc animated:YES];
    }
}

/**
 购票说明点击
 */
- (void)purchaseDescriptionClicked {
    TYWJCarProtocolController *vc = [[TYWJCarProtocolController alloc] init];
    vc.type = TYWJCarProtocolControllerTypeTicketingInformation;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)statusClicked:(UIButton *)btn {
    if ([btn isEqual:self.selectedBtn]) return;
    
    btn.selected = YES;
    self.selectedBtn.selected = NO;
    self.selectedBtn = btn;

    
    NSArray *paths = @[[NSIndexPath indexPathForRow:1 inSection:0],[NSIndexPath indexPathForRow:3 inSection:0]];
    [self.tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationMiddle];
    
    [self setPriceAndNums];
}


- (void)setRouteListInfo:(TYWJRouteListInfo *)routeListInfo {
    //如果属性是copy修饰符的话，必须得这样做才会生效，不然和strong是一样的
    _routeListInfo = [routeListInfo copy];
    
    
    [self loadTicketPriceData];
}

- (void)setResult:(TYWJSearchReult *)result {
    _result = result;
    
    _routeListInfo = [[TYWJRouteListInfo alloc] init];
    _routeListInfo.startingStop = result.beginStation.station;
    _routeListInfo.startingTime = result.beginStation.time;
    _routeListInfo.stopStop = result.endStation.station;
    _routeListInfo.stopTime = result.endStation.time;
    _routeListInfo.isFullPrice = result.routeInfo.isFullPrice;
    _routeListInfo.cityID = result.routeInfo.cityID;
    _routeListInfo.type = result.routeInfo.type;
    _routeListInfo.price = result.routeInfo.price;
    _routeListInfo.oriPrice = result.routeInfo.oriPrice;
    _routeListInfo.routeNum = result.routeInfo.routeNum;
    _routeListInfo.startStopId = result.routeInfo.startStopId;
    _routeListInfo.stopStopId = result.routeInfo.stopStopId;
    
    [self loadTicketPriceData];
}


- (void)getupClickedWithCell:(TYWJChooseStopsCell *)cell {
    ZLFuncLog;
}

- (void)getdownClickedWithCell:(TYWJChooseStopsCell *)cell {
    ZLFuncLog;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.monthInfo.sfyp && self.monthInfo.ypOpenTime) {
        return 5;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self configSingleCellWithTableview:tableView indexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.monthInfo.sfyp && self.monthInfo.ypOpenTime) {
        switch (indexPath.row) {
            case 2:
            {
                return 120.f;
            }
                
                break;
            case 1:
            {
                if (self.isSingleTicket) {
                    return 266.f;
                }
                return 0;
            }
                break;
            case 0:
            {
                return 45.f;
                
            }
                break;
            case 3:
            {
                if (self.isSingleTicket) {
                    return 0;
                }
                return 135.0f;
            }
                break;
            case 4:
                return 150.f;
            default:
                return 10.f;
        }
    }else {
        switch (indexPath.row) {
            case 2:
            {
                return 120.f;
                
            }
                break;
            case 1:
            {
                if (self.isSingleTicket) {
                    return 266.f;
                }
                return 0;
            }
                break;
            case 0:
            {
                return 150.f;
            }
                
                break;
            
            default:
                return 10.f;
        }
    }
    
}

- (UITableViewCell *)configSingleCellWithTableview:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {

        case 0:
        {
            WeakSelf;
            
            TYWJChooseStopsCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJChooseStopsCellID forIndexPath:indexPath];
            [cell setGetupStation:self.routeListInfo.startingStop];
            [cell setGetdownStation:self.routeListInfo.stopStop];
            __weak typeof(cell) weakCell = cell;
            cell.getupStatonClicked = ^{
                //上车点击
                if (weakSelf.routeLists) {
                    [[ZLPopoverView sharedInstance] showPopSelectViewWithDataArray:weakSelf.routeLists andProertyName:@"routeNum" confirmClicked:^(id model) {
                        TYWJSubRouteListInfo *route = (TYWJSubRouteListInfo *)model;
                        [weakCell setGetupStation: route.routeNum];
                    }];
                }else {
                    [MBProgressHUD zl_showError:@"网络差，请稍后再试"];
                    [weakSelf loadData];
                }
            };
            cell.gedownStatonClicked = ^{
                //下车点击
                if (weakSelf.routeLists) {
                    [[ZLPopoverView sharedInstance] showPopSelectViewWithDataArray:weakSelf.routeLists andProertyName:@"routeNum" confirmClicked:^(id model) {
                        TYWJSubRouteListInfo *route = (TYWJSubRouteListInfo *)model;
                        [weakCell setGetdownStation: route.routeNum];
                    }];
                }else {
                    [MBProgressHUD zl_showError:@"网络差，请稍后再试"];
                    [weakSelf loadData];
                }
            };
            return cell;
        }
            break;

            case 1:
            {
                
                TYWJCalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJCalendarCellID forIndexPath:indexPath];
                cell.dlg = self;
                [cell addTarget:self action:@selector(purchaseDescriptionClicked)];
                if (!self.isSingleTicket) {
                    cell.hidden = YES;
                }else {
                    cell.hidden = NO;
                }
                self.cusCalendar = cell.calendarView;
                cell.backgroundColor = [UIColor clearColor];
                return cell;
            }
                break;
            case 2:
            {
                TYWJBuyTicketChooseTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:TYWJBuyTicketChooseTypeCellID forIndexPath:indexPath];
                cell.backgroundColor = [UIColor clearColor];
                __weak typeof(cell) weakCell = cell;

                cell.buttonSeleted = ^(NSInteger index){
                    NSInteger selectedTime = indexPath.row == 2 ? 9 : 18;


                    [[ZLPopoverView sharedInstance] showPopSelecteTimeViewWithSelectedTime:selectedTime ConfirmClicked:^(NSString *time) {
                        weakCell.timeLabel.text = time;
                    }];
                };
                return cell;
            }
                break;
        
        default:
            return nil;
    }
}

#pragma mark - dlg

- (void)setPriceAndNums {
    if (self.ticketPrice < 0) {
        [MBProgressHUD zl_showError:@"选择了错误的出发站或终点站，请重新选择"];
        return;
    }
    if (self.isSingleTicket) {
        self.bottomView.showTips = YES;
        
        NSInteger num = self.cusCalendar.selectedDates.count * self.ticketNums;
        CGFloat price = self.ticketPrice*num;
        [self.bottomView setTipsWithNum:num];
        [self.bottomView setPrice: [NSString stringWithFormat:@"%.02f",price]];
        [self.bottomView setTFText: [NSString stringWithFormat:@"%d",self.ticketNums]];
        

        return;
    }
    
    self.bottomView.showTips = NO;
    [self.bottomView setPrice: [NSString stringWithFormat:@"%.2f",self.monthInfo.ypjg.floatValue*self.monthInfo.ypDays]];
    
}


- (void)calendarViewCellDidSelected:(NSDate *)selectedDate cell:(ZLCalendarCell *)cell indexPath:(NSIndexPath *)indexPath {
    self.dateFormatter.dateFormat = @"yyyy.MM.dd";
    NSString *today = [self.dateFormatter stringFromDate:[NSDate date]];
    NSString *selectedDay = [self.dateFormatter stringFromDate:selectedDate];
    if ([selectedDay isEqualToString:today]) {
        //判断是否是今天
        self.dateFormatter.dateFormat = @"HH:mm";
        NSTimeInterval ticketTime = [[self.dateFormatter dateFromString:self.routeListInfo.startingTime] timeIntervalSince1970];
        NSTimeInterval nowTime = [[self.dateFormatter dateFromString: [self.dateFormatter stringFromDate: [NSDate date]]] timeIntervalSince1970];
        if (ticketTime - nowTime < 0) {
            //判断是否是发车前5分钟
            NSString *msg = nil;
//            if (ticketTime - nowTime <= 0) {
                msg = @"当前车次已发车,是否继续购买?";
//            }
            [MBProgressHUD zl_hideHUDForView:self.view];
            WeakSelf;
            [self canBuySingleTicketWithDate:selectedDate cell:cell];
            [[ZLPopoverView sharedInstance] showTipsViewWithTips:msg leftTitle:@"是的" rightTitle:@"算了" RegisterClicked:^{
                [weakSelf.cusCalendar deSelectWithCell:cell date:selectedDate];
                [weakSelf setPriceAndNums];
            }];
            
            return;
        }
    }
    
   [self canBuySingleTicketWithDate:selectedDate cell:cell];
}

- (void)calendarViewCellWillDisplayWithSelectedDate:(NSDate *)date selectedCell:(ZLCalendarCell *)cell indexPath:(NSIndexPath *)indexPath {
    TYWJCalendarList *cl = self.lastSeats[indexPath.row];
    if (!cl.status) {
        [cell disableCell];
        return;
    }
    //判断是否已发车
    if ([self isLaunchedCarWithTakeupDate:cl.riqi]) {
        [cell disableCell];
        return;
    }
    
    if (cl.buy) {
        cell.boughtLabel.hidden = NO;
    }else {
        cell.boughtLabel.hidden = YES;
    }
    
    if (cl.sellOut) {
        cell.subTitleLabel.text = @"已售罄";
        cell.subTitleLabel.textColor = [UIColor lightGrayColor];
    }else {
        NSString *text = [NSString stringWithFormat:@"¥%.01f",self.ticketPrice];
        if (cl.ticketNum < 15) {
            text = @"少量";
        }
//#ifdef DEBUG
//        text = [NSString stringWithFormat:@"余:%ld",(long)cl.ticketNum];
//#endif
        cell.subTitleLabel.text = text;
    }
    
    
}

- (void)calendarViewCellDidDeSelected:(NSDate *)selectedDate cell:(ZLCalendarCell *)cell indexPath:(NSIndexPath *)indexPath {
    [self setPriceAndNums];
}


- (BOOL)calendarViewCellShouldSelected:(NSDate *)selectedDate indexPath:(NSIndexPath *)indexPath {
    
    TYWJCalendarList *cl = self.lastSeats[indexPath.row];
    if (!cl.status) {
        return NO;
    }
    
    
    //判断是否已发车
    if ([self isLaunchedCarWithTakeupDate:cl.riqi]) {
        return NO;
    }
    
    if (cl.sellOut) {
        return NO;
    }else {
        return YES;
    }
}



#pragma mark - 判断是否是今天已收车

- (BOOL)isLaunchedCarWithTakeupDate:(NSString *)takeupDate {
    self.dateFormatter.dateFormat = @"yyyy.MM.dd";
    NSTimeInterval todateTime = [[self.dateFormatter dateFromString:[self.dateFormatter stringFromDate:[NSDate date]]] timeIntervalSince1970];
    NSTimeInterval ticketDateTime = [[self.dateFormatter dateFromString:takeupDate] timeIntervalSince1970];
    self.dateFormatter.dateFormat = @"HH.mm";
    NSTimeInterval ticketTime = [[self.dateFormatter dateFromString:self.routeListInfo.stopTime] timeIntervalSince1970];
    NSTimeInterval nowTime = [[self.dateFormatter dateFromString: [self.dateFormatter stringFromDate:[NSDate date]]] timeIntervalSince1970];
    if (todateTime == ticketDateTime && nowTime > ticketTime) {
        return YES;
    }
    return NO;
}


@end
