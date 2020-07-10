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
#import "TYWJRouteList.h"
#import "TYWJSubRouteList.h"
#import "TYWJSearchReult.h"

#import "TYWJPayController.h"
#import "TYWJCarProtocolController.h"
#import "TYWJCalendarCell.h"
#import "TYWJLoginTool.h"
#import <MJExtension.h>
#import "TYWJCalendarModel.h"
static CGFloat const kBottomViewH = 56.f;

@interface TYWJBuyTicketController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_peopleNum;
    NSInteger _moneyNum;
}
/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* bottomView */
@property (strong, nonatomic) TYWJBottomPurchaseView *bottomView;
@property (strong, nonatomic) TYWJCalendarCell *calendarCell;
@property (strong, nonatomic) NSMutableArray *lastSeatsArr;
@property (strong, nonatomic) NSMutableArray *selectedDatesArr;
@property (strong, nonatomic) TYWJSubRouteListInfo *startModel;
@property (strong, nonatomic) TYWJSubRouteListInfo *endModel;
@end

@implementation TYWJBuyTicketController
#pragma mark - 懒加载

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
        [_tableView registerClass:[TYWJChooseStopsCell class] forCellReuseIdentifier:TYWJChooseStopsCellID];
        [_tableView registerClass:[TYWJCalendarCell class] forCellReuseIdentifier:TYWJCalendarCellID];
    }
    return _tableView;
}

#pragma mark - set up view
- (void)dealloc {
    ZLFuncLog;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showUIRectEdgeNone];
    self.startModel = [[TYWJSubRouteListInfo alloc] init];
    self.endModel = [[TYWJSubRouteListInfo alloc] init];
    self.lastSeatsArr = [NSMutableArray array];
    self.selectedDatesArr = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [self setupView];
    if (!(self.routeLists.count > 0)) {
        [self loadData];
    }
    if (!(self.timeArr.count > 0)) {
        self.timeArr = [NSMutableArray array];
        [self loadTicketLineTime];


    }else{
        [self requestLastSeats];
    }
    
    

    
    
    
    [self addNotis];
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
    NSArray *dateArr = [self.calendarCell.calendarView getSelectedDates];
    NSInteger price = 0;
    [self.selectedDatesArr removeAllObjects];
    if (self.lastSeatsArr.count && dateArr.count) {
        for (NSDate *calendarDate in dateArr) {
            for (TYWJCalendarModel *model in self.self.lastSeatsArr) {
                NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
                [outputFormatter setDateFormat:@"yyyy-MM-dd"];
                if ([[outputFormatter stringFromDate:calendarDate] isEqualToString:model.line_date]) {
                    price += model.prime_price.integerValue;
                    _moneyNum = price*_peopleNum.intValue;
                    NSDictionary *dic = @{@"goods_no":model.store_no,@"date":model.line_date,@"price":@(model.sell_price.intValue)};
                    [self.selectedDatesArr addObject:dic];
                }
            }
        }
    }
    [self.bottomView setPrice:[NSString stringWithFormat:@"%ld",(long)price*_peopleNum.intValue]];
}


- (void)loadTicketLineTime {
    NSDictionary *param = @{
        @"line_code":self.line_info_id,
    };
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.91:9005/ticket/line/date/time" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        NSMutableArray *data = [dic objectForKey:@"data"];
        if (data.count > 0) {
            self.timeArr = data;
            if (!self.line_time) {
                self->_line_time = [self.timeArr.firstObject objectForKey:@"line_time"];
            }
            [self setEstimatedTime];

            [self requestLastSeats];
        }
    } WithFailurBlock:^(NSError *error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork];
    }];
}

- (void)loadTicketPriceData {
    
}

/**
 获取剩余座位
 */
- (void)requestLastSeats {
    NSDictionary *param = @{
        @"line_code":self.line_info_id,
        @"line_time":_line_time
    };
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.91:9005/ticket/store/list/time" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        NSMutableArray *data = [dic objectForKey:@"data"];
        if (data.count > 0) {
            self.lastSeatsArr = [TYWJCalendarModel mj_objectArrayWithKeyValuesArray:data];
            [ZLNotiCenter postNotificationName:TYWJTicketNumsDidChangeNoti object:nil];
        }
        [self.tableView reloadData];
    } WithFailurBlock:^(NSError *error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork];
    }];
}
- (void)setupView {
    self.title = @"胖哒自由行";
    _peopleNum = @"1";
    _moneyNum = 0;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"购买说明" forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    [button setTitleColor:ZLNavTextColor forState:UIControlStateNormal];
    button.zl_size = CGSizeMake(80, 30);
    button.titleEdgeInsets = UIEdgeInsetsMake(0,0, 0, -15);
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
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.91:9003/trip/detail" WithParams:@{@"line_info_id":self.line_info_id} WithSuccessBlock:^(NSDictionary *dic) {
        NSDictionary *data = [dic objectForKey:@"data"];
        if (data.allKeys.count > 0) {
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:[data objectForKey:@"start"]];
            [arr addObjectsFromArray:[data objectForKey:@"ways"]];
            [arr addObject:[data objectForKey:@"end"]];
            NSInteger count = arr.count;
            NSMutableArray *listarr = [NSMutableArray array];
            for (NSInteger i = 0; i < count; i++) {
                NSDictionary *dic = arr[i];
                NSArray *locarr = [dic objectForKey:@"loc"];
                NSString *name = [dic objectForKey:@"name"];
                NSString *time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"time"]];
                TYWJSubRouteListInfo *info = [[TYWJSubRouteListInfo alloc] init];
                info.latitude = locarr[1];
                info.longitude = locarr[0];
                info.routeNum = name;
                info.time = time;
                if (i == 0 ) {
                    info.isStartStation = YES;
                }
                if (i == count - 1 ) {
                    info.isEndStation = YES;
                }
                [listarr addObject:info];
            }
            self.routeLists = listarr;
            [self setEstimatedTime];
            [self.tableView reloadData];
        }else {
            [MBProgressHUD zl_showError:@"线路加载失败" toView:self.view];
        }
    } WithFailurBlock:^(NSError *error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:self.view];
    }];
}

-(void)setEstimatedTime{
    NSInteger totalTime = 0;
    for (TYWJSubRouteListInfo *list in self.routeLists) {
        totalTime += list.time.intValue;
        list.estimatedTime = [TYWJCommonTool getTimeWithTimeStr:self.line_time intervalStr:[NSString stringWithFormat:@"%ld",(long)totalTime]];
    }
}

#pragma mark - 按钮点击
- (void)purchaseClicked {
    if (!(self.selectedDatesArr.count > 0)) {
        [MBProgressHUD zl_showError:@"请选择购票日期" toView:self.view];
        return;
    }

    NSDictionary *param =@{
        @"app_type": @"IOS_CC",
        @"city_name": [TYWJCommonTool sharedTool].selectedCity.city_name,
        @"getoff_loc": self.endModel.routeNum,
        @"geton_loc": self.startModel.routeNum,
        @"geton_time": self.startModel.estimatedTime,
        @"getoff_time": self.endModel.estimatedTime,
        @"goods": self.selectedDatesArr,
        @"line_code": self.line_info_id,
        @"line_time": _line_time,
        @"money": @(_moneyNum),
        @"number": @(_peopleNum.intValue),
        @"line_name":self.line_name
    };
    TYWJPayController *payVc = [[TYWJPayController alloc] init];
    payVc.paramDic = [NSMutableDictionary dictionaryWithDictionary:param];
    [TYWJCommonTool pushToVc:payVc];
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
            for (TYWJSubRouteListInfo *list in self.routeLists) {
                if (list.isStartStation) {
                    self.startModel = list;
                }
                if (list.isEndStation) {
                    self.endModel = list;
                }
            }
            [cell setGetupStation:self.startModel.routeNum];
            [cell setGetupTime:[NSString stringWithFormat:@"预计%@到达",self.startModel.estimatedTime]];
            [cell setGetdownStation:self.endModel.routeNum];
            [cell setGetdownTime:[NSString stringWithFormat:@"预计%@到达",self.endModel.estimatedTime]];

            __weak typeof(cell) weakCell = cell;
            cell.getupStatonClicked = ^{
                //上车点击
                if (weakSelf.routeLists) {
                    [[ZLPopoverView sharedInstance] showPopSelectViewWithDataArray:weakSelf.routeLists andProertyName:@"routeNum" confirmClicked:^(id model) {
                        TYWJSubRouteListInfo *route = (TYWJSubRouteListInfo *)model;
                        for (TYWJSubRouteListInfo *list in self.routeLists) {
                            list.isStartStation = NO;
                        }
                        route.isStartStation = YES;

                        self.startModel = route;
                        [weakCell setGetupStation: route.routeNum];
                        [weakCell setGetupTime:[NSString stringWithFormat:@"预计%@到达",route.estimatedTime]];
                    }];
                }else {
                    [weakSelf loadData];
                }
            };
            cell.gedownStatonClicked = ^{
                //下车点击
                if (weakSelf.routeLists) {
                    [[ZLPopoverView sharedInstance] showPopSelectViewWithDataArray:weakSelf.routeLists andProertyName:@"routeNum" confirmClicked:^(id model) {
                        TYWJSubRouteListInfo *route = (TYWJSubRouteListInfo *)model;
                                       for (TYWJSubRouteListInfo *list in self.routeLists) {
                              list.isEndStation = NO;
                          }
                          route.isEndStation = YES;
                        self.endModel = route;

                        [weakCell setGetdownStation: route.routeNum];
                        [weakCell setGetdownTime:[NSString stringWithFormat:@"预计%@到达",route.estimatedTime]];

                    }];
                }else {
                    [weakSelf loadData];
                }
            };
            return cell;
        }
            break;
        case 1:
        {
            self.calendarCell = [tableView dequeueReusableCellWithIdentifier:TYWJCalendarCellID forIndexPath:indexPath];
            
            if (self.lastSeatsArr.count) {
                [self.calendarCell confirgCellWithModel:self.lastSeatsArr];
                
            }
            self.calendarCell.backgroundColor = [UIColor clearColor];
            return self.calendarCell;
        }
            break;
        case 2:
        {
            TYWJBuyTicketChooseTypeCell *cell = [TYWJBuyTicketChooseTypeCell cellForTableView:tableView];
            cell.backgroundColor = [UIColor clearColor];
            cell.timeLabel.text = _line_time;
            cell.numLabel.text = _peopleNum;
            __weak typeof(cell) weakCell = cell;
            cell.buttonSeleted = ^(NSInteger index){
                switch (index) {
                    case 0:
                    {
                        [self setEstimatedTime];
                        [[ZLPopoverView sharedInstance] showPopSelectViewWithDataArray:self.timeArr andProertyName:@"line_time" confirmClicked:^(id model) {
                            NSDictionary *dic = (NSDictionary *)model;
                            NSString *line_time = [dic objectForKey:@"line_time"];
                            weakCell.timeLabel.text = line_time;
                            self->_line_time = line_time;
                            [self setEstimatedTime];
                            [self requestLastSeats];
                        }];
                    }
                        break;
                    case 1:
                    {
                        self->_peopleNum = cell.numLabel.text;
                    }
                        break;
                    default:
                        break;
                }
                
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
            return 426.f - 46.f;
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
