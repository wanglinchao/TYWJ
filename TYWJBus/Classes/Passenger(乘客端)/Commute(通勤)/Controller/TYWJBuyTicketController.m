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

#import "TYWJPayDetailController.h"
#import "TYWJCarProtocolController.h"
#import "TYWJCalendarCell.h"
#import "ZLCalendarView.h"
#import "TYWJLoginTool.h"
#import "TYWJJsonRequestUrls.h"
#import "ZLHTTPSessionManager.h"
#import "TYWJCalendarList.h"
#import <MJExtension.h>

static CGFloat const kBottomViewH = 56.f;

@interface TYWJBuyTicketController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* bottomView */
@property (strong, nonatomic) TYWJBottomPurchaseView *bottomView;
/* selectedBtn */
@property (weak, nonatomic) UIButton *selectedBtn;
/* 票价 */
@property (assign, nonatomic) CGFloat ticketPrice;
/* ZLCalendarView */
@property (weak, nonatomic) ZLCalendarView *cusCalendar;
/* dateFormatter */
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
/* 车票nums */
@property (assign, nonatomic) int ticketNums;

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
}

- (void)setupView {
    NSString *navTitle = self.routeListInfo.routeName;
    if (self.result) {
        navTitle = self.result.routeInfo.routeName;
    }
    self.navigationItem.title = navTitle;//@"购票";
    self.title = @"胖哒自由行";
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
/**
 购票说明点击
 */
- (void)purchaseDescriptionClicked {
    TYWJCarProtocolController *vc = [[TYWJCarProtocolController alloc] init];
    vc.type = TYWJCarProtocolControllerTypeTicketingInformation;
    [self.navigationController pushViewController:vc animated:YES];
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


    NSString *ticketPrice = self.routeListInfo.price;
    
    self.ticketPrice = ticketPrice.doubleValue;
    NSInteger num = self.cusCalendar.selectedDates.count;
    
        NSString *priceStr = [NSString stringWithFormat:@"%.02f",self.ticketPrice*num];
        [self.bottomView setPrice:priceStr];
        [self.bottomView setTipsWithNum:num];
   
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
            NSString *priceStr = [NSString stringWithFormat:@"%.02f",weakSelf.ticketPrice*num];
            [weakSelf.bottomView setPrice:priceStr];
            [weakSelf.bottomView setTipsWithNum:num];

        
    } failure:nil];
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
//        [weakSelf setPriceAndNums];
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


#pragma mark - 按钮点击

- (void)purchaseClicked {
    TYWJPayDetailController *payVc = [[TYWJPayDetailController alloc] init];
    [TYWJCommonTool pushToVc:payVc];
    
    return;
    ZLFuncLog;
    ZLLog(@"selectedDates---%@",self.cusCalendar.selectedDates);
    if (self.cusCalendar.selectedDates.count == 0) {
        [MBProgressHUD zl_showAlert:@"请选择乘车日期" afterDelay:1.5f];
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    TYWJChooseStopsCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        
//        TYWJPayController *payVc = [[TYWJPayController alloc] init];
//        payVc.startStation = [self.routeLists[0] valueForKeyPath:@"station"];
//        payVc.desStation = [self.routeLists.lastObject valueForKeyPath:@"station"];
//        payVc.routeListInfo = self.routeListInfo;
//
//            payVc.routeListInfo = self.routeListInfo;
//            payVc.ticketDates = self.cusCalendar.selectedDates;
//            payVc.totalFee = [NSString stringWithFormat:@"¥%.02f",self.cusCalendar.selectedDates.count*self.ticketPrice*self.ticketNums];
//            payVc.ticketNums = self.ticketNums;
//        
//        [self.navigationController pushViewController:payVc animated:YES];
    }
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

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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


                        
                        [[ZLPopoverView sharedInstance] showPopSelectViewWithDataArray:@[@{@"routeNum":@"1"},@{@"routeNum":@"2"}] andProertyName:@"routeNum" confirmClicked:^(id model) {
                            NSDictionary *dic = (NSDictionary *)model;
                                weakCell.timeLabel.text = [dic objectForKey:@"routeNum"];
                           }];
                        
                        
                        
                    };
                    return cell;
                }
                    break;
            
            default:
                return nil;
        }
    }


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        switch (indexPath.row) {

  
            case 0:
            {
                return 150.f;
            }
                
                break;
                case 1:
                  {
                          return 426.f;
                
                  }
                      break;
            case 2:
            {
                return 120.f;
                
            }
                break;
            default:
                return 10.f;
        }
    
    
}




@end
