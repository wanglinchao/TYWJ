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

/* tableView */
@property (strong, nonatomic) UITableView *tableView;
/* bottomView */
@property (strong, nonatomic) TYWJBottomPurchaseView *bottomView;


/* 车票nums */
@property (assign, nonatomic) int ticketNums;
/* routeListInfo */
@property (copy, nonatomic) TYWJRouteListInfo *routeListInfo;

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
//    [self loadData];
//    [self loadTicketPriceData];
//    [self requestLastSeats];
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

    
}

- (void)loadTicketPriceData {
    
}



/**
 获取剩余座位
 */
- (void)requestLastSeats {
    
}


#pragma mark - 按钮点击

- (void)purchaseClicked {
    TYWJPayDetailController *payVc = [[TYWJPayDetailController alloc] init];
    [TYWJCommonTool pushToVc:payVc];
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
