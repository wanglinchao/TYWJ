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

#import "TYWJPayDetailController.h"
#import "TYWJCarProtocolController.h"
#import "TYWJCalendarCell.h"
#import "TYWJLoginTool.h"
#import <MJExtension.h>

static CGFloat const kBottomViewH = 56.f;

@interface TYWJBuyTicketController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_line_time;
    NSString *_peopleNum;
}
/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* bottomView */
@property (strong, nonatomic) TYWJBottomPurchaseView *bottomView;
@property (strong, nonatomic) NSMutableArray *timeArr;
@property (strong, nonatomic) NSMutableArray *lastSeatsArr;

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
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TYWJBuyTicketChooseTypeCell class]) bundle:nil] forCellReuseIdentifier:TYWJBuyTicketChooseTypeCellID];
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
    self.timeArr = [NSMutableArray array];
    self.lastSeatsArr = [NSMutableArray array];
    if (![self.startAndEndStation isKindOfClass:[NSMutableDictionary class]]) {
        self.startAndEndStation = [[NSMutableDictionary alloc] init];
    }
    // Do any additional setup after loading the view.
    [self setupView];
    if (!(self.routeLists.count > 0)) {
        [self loadData];
    }
    [self loadTicketLineTime];
    //    [self loadTicketPriceData];
    //    [self requestLastSeats];
}
- (void)loadTicketLineTime {
    NSDictionary *param = @{
        @"lineCode":self.line_info_id,
    };
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.91:9005/ticket/line/time" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        NSMutableArray *data = [dic objectForKey:@"data"];
        if (data.count > 0) {
            self.timeArr = data;
            self->_line_time = [self.timeArr.firstObject objectForKey:@"line_time"];
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
            self.lastSeatsArr = data;
        }
    } WithFailurBlock:^(NSError *error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork];
    }];
}
- (void)setupView {
    self.title = @"胖哒自由行";
    _peopleNum = @"1";
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
                [listarr addObject:info];
            }
            self.routeLists = listarr;
            [self.tableView reloadData];
        }else {
            [MBProgressHUD zl_showError:@"线路加载失败" toView:self.view];
        }
    } WithFailurBlock:^(NSError *error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:self.view];
    }];
}


#pragma mark - 按钮点击
- (void)purchaseClicked {
    NSLog(@"时间%@-人数%@上下站%@",_line_time,_peopleNum,_startAndEndStation);
    TYWJPayDetailController *payVc = [[TYWJPayDetailController alloc] init];
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
            NSString *start = [self.startAndEndStation objectForKey:@"start"];
            NSString *end = [self.startAndEndStation objectForKey:@"end"];
            if (start.length > 0) {
                
            } else {
                TYWJSubRouteListInfo *info = [self.routeLists firstObject];
                start = info.routeNum;
                
                [self.startAndEndStation setValue:start forKey:@"start"];
            }
            if (end.length > 0) {
                
            } else {
                TYWJSubRouteListInfo *info = [self.routeLists lastObject];
                end = info.routeNum;
                [self.startAndEndStation setValue:end forKey:@"end"];
            }
            [cell setGetupStation:start];
            [cell setGetdownStation:end];
            __weak typeof(cell) weakCell = cell;
            cell.getupStatonClicked = ^{
                //上车点击
                if (weakSelf.routeLists) {
                    [[ZLPopoverView sharedInstance] showPopSelectViewWithDataArray:weakSelf.routeLists andProertyName:@"routeNum" confirmClicked:^(id model) {
                        TYWJSubRouteListInfo *route = (TYWJSubRouteListInfo *)model;
                        self->_line_time = route.routeNum;
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
            cell.timeLabel.text = _line_time;
            cell.numLabel.text = _peopleNum;
            __weak typeof(cell) weakCell = cell;
            cell.buttonSeleted = ^(NSInteger index){
                switch (index) {
                    case 0:
                    {
                        [[ZLPopoverView sharedInstance] showPopSelectViewWithDataArray:self.timeArr andProertyName:@"line_time" confirmClicked:^(id model) {
                            NSDictionary *dic = (NSDictionary *)model;
                            NSString *line_time = [dic objectForKey:@"line_time"];
                            weakCell.timeLabel.text = line_time;
                            self->_line_time = line_time;
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
