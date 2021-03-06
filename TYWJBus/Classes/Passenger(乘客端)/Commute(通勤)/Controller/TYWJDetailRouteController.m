//
//  TYWJDetailRouteController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/29.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJDetailRouteController.h"
#import "TYWJBuyTicketController.h"
#import "TYWJSchedulingDetailStateView.h"
#import "TYWJDetailRouteView.h"
#import "TYWJStartToDestinationView.h"
#import "TYWJBottomPurchaseView.h"
#import "TYWJDetailStationCell.h"
#import "CustomAnnotationView.h"
#import "ZLPopoverView.h"


#import "TYWJRouteList.h"
#import "TYWJSubRouteList.h"
#import "TYWJApplyRoute.h"
#import "TYWJCarLocation.h"
//#import "TYWJDriverRouteList.h"

#import "MANaviRoute.h"
#import "CommonUtility.h"
#import <MJExtension.h>
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>
#import "TYWJScanQRcodeViewController.h"
#import "TYWJShowAlertViewController.h"
#import "TYWJRongCloudTool.h"
static CGFloat const kBottomViewH = 44.f;
static CGFloat const kTimeInterval = 0.25f;
static CGFloat const kRouteViewH = 126.f;
static CGFloat const kTableViewRowH = 46.f;
static CGFloat const kRowH = 46.f;


static NSString  * const RoutePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
static NSString * const MAAnimationAnnotationViewID = @"MAAnimationAnnotationViewID";
static const NSInteger RoutePlanningPaddingEdge                    = 20;

@interface TYWJDetailRouteController()<MAMapViewDelegate,UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate>
{
    NSInteger _selectedIndex;
    NSInteger _startStationIndex;
    NSInteger _endStationIndex;
    NSString *_line_time;
    
}
@property (strong, nonatomic) NSMutableDictionary *dataDic;
@property (strong, nonatomic) CustomAnnotationView *poiAnnotationView;
@property (strong, nonatomic) id<MAAnnotation> annonation;
@property (strong, nonatomic) NSMutableArray *poiAnnotationViews;
@property (strong, nonatomic) NSMutableArray *annonations;
@property (strong, nonatomic) NSMutableArray *carLocationArr;


/* mapView */
@property (strong, nonatomic) MAMapView *mapView;
/* routeView */
@property (strong, nonatomic) TYWJDetailRouteView *routeView;
/* bottomView */
@property (strong, nonatomic) TYWJBottomPurchaseView *bottomView;
/* routeTableView */
@property (strong, nonatomic) UITableView *routeTableView;
/* routeLists */
@property (strong, nonatomic) NSArray *routeLists;
/* bubbleLists */
@property (strong, nonatomic) NSArray *bubbleLists;
/* arrowBtn */
@property (strong, nonatomic) UIButton *arrowBtn;
/* trafficBtn */
@property (strong, nonatomic) UIButton *trafficBtn;
/* 显示当前位置按钮 */
@property (strong, nonatomic) UIButton *currentLocationBtn;
/* 是否是展开的view */
@property (assign, nonatomic) BOOL isExpansionView;
/* 展开view之后要加的高度 */
@property (assign, nonatomic) CGFloat expansionViewDeltaH;
/* 起始点info */
@property (strong, nonatomic) TYWJSubRouteListInfo *startStationInfo;
/* 结束点info */
@property (strong, nonatomic) TYWJSubRouteListInfo *endStationInfo;
/* mapSearch */
@property (strong, nonatomic) AMapSearchAPI *mapSearch;
/* 用于显示当前路线方案. */
@property (nonatomic,strong) MANaviRoute *naviRoute;
@property (nonatomic, strong) AMapRoute *route;
/* carLocation */
@property (strong, nonatomic) TYWJCarLocation *carLocation;
/* MAAnimatedAnnotation */
@property (strong, nonatomic) MAAnimatedAnnotation *carAnnotation;
///记录的上次经纬度
@property (nonatomic, assign) CLLocationCoordinate2D lastCoordinate;
//当前位置
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;
@property (strong, nonatomic) NSMutableArray *timeArr;
/* timer */
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation TYWJDetailRouteController

#pragma mark - lazy loading
- (AMapSearchAPI *)mapSearch {
    if (!_mapSearch) {
        _mapSearch = [[AMapSearchAPI alloc] init];
        _mapSearch.delegate = self;
    }
    return _mapSearch;
}
- (MAMapView *)mapView {
    if (!_mapView) {
        ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
        CGFloat tabbarH = kTabBarH;
        CGFloat bottomViewH = kBottomViewH;
        
        [AMapServices sharedServices].enableHTTPS = YES;
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, kNavBarH, ZLScreenWidth, self.view.zl_height - tabbarH - kNavBarH)];
        
        ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
        _mapView.showsUserLocation = YES;
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        
        [_mapView setZoomLevel:15 animated:YES];
        _mapView.showsCompass = NO;
        _mapView.rotateEnabled = NO;
        //关闭3D旋转
        _mapView.rotateCameraEnabled = NO;
        _mapView.delegate = self;
        [_mapView setMaxZoomLevel:19];
    }
    return _mapView;
}

- (TYWJDetailRouteView *)routeView {
    if (!_routeView) {
        _routeView = [TYWJDetailRouteView detailRouteViewWithFrame:CGRectMake(15.f, ZLScreenHeight - kNavBarH - kRouteViewH + 20, self.view.zl_width - 30.f, kRouteViewH)];
        WeakSelf;
        _routeView.buttonSeleted = ^{
            //showtimeLabel
            [[ZLPopoverView sharedInstance] showPopSelectViewWithDataArray:weakSelf.timeArr andProertyName:@"line_time" confirmClicked:^(id model) {
                NSDictionary *dic = (NSDictionary *)model;
                NSString *line_time = [dic objectForKey:@"line_time"];
                self->_line_time = line_time;
                [weakSelf.routeTableView reloadData];
                //                for (int i = 0; i< weakSelf.routeLists.count; i++) {
                //                    self->_poiAnnotationView = [self.poiAnnotationViews objectAtIndex:i];
                //                    self->_poiAnnotationView.routeListInfo = [self getStataionInfoWithAnnonations:self.annonations];
                //
                //                }
                self->_poiAnnotationView.routeListInfo = [self getStataionInfoWithAnnonation:_annonation];
                [weakSelf.mapView reloadMap];
            }];
        };
        
        NSString *startStop = nil;
        NSString *stopStop = nil;
        if (!self.isDetailRoute) {
            startStop = self.routeListInfo.startingStop;
            stopStop = self.routeListInfo.stopStop;
        }else {
            //            startStop = self.ticket.startStation;
            //            stopStop = self.ticket.desStation;
            
        }
    }
    return _routeView;
}



- (TYWJBottomPurchaseView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[TYWJBottomPurchaseView alloc] initWithFrame:CGRectMake(0, self.view.zl_height - kTabBarH - kBottomViewH, ZLScreenWidth, kTabBarH + kBottomViewH)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView addTarget:self action:@selector(purchaseClicked)];
        _bottomView.showTips = NO;
        [_bottomView setPrice: self.routeListInfo.price];
    }
    return _bottomView;
}



- (UITableView *)routeTableView {
    if (!_routeTableView) {
        _routeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.routeView.stopsView.zl_width, 0) style:UITableViewStylePlain];
        _routeTableView.delegate = self;
        _routeTableView.dataSource = self;
        _routeTableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        _routeTableView.showsVerticalScrollIndicator = NO;
        //        _routeTableView.bounces = NO;
        _routeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _routeTableView.alpha = 0;
        _routeTableView.rowHeight = kRowH;
        [_routeTableView registerClass:[TYWJDetailStationCell class] forCellReuseIdentifier:TYWJDetailStationCellID];
    }
    return _routeTableView;
}

- (UIButton *)arrowBtn {
    if (!_arrowBtn) {
        _arrowBtn = [[UIButton alloc] init];
        [_arrowBtn setImage:[UIImage imageNamed:@"路线_箭头收起"] forState:UIControlStateNormal];
        [_arrowBtn setImage:[UIImage imageNamed:@"路线_箭头展开"] forState:UIControlStateSelected];
        [_arrowBtn addTarget:self action:@selector(arrowBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _arrowBtn.zl_size = CGSizeMake(30, 30);
        _arrowBtn.backgroundColor = [UIColor clearColor];
        _arrowBtn.zl_centerX = self.routeView.stopsView.zl_width/2.f;
        _arrowBtn.zl_y = 0;
        
    }
    return _arrowBtn;
}
- (UIButton *)trafficBtn {
    if (!_trafficBtn) {
        _trafficBtn = [[UIButton alloc] init];
        _trafficBtn.frame = CGRectMake(20.f, self.view.zl_height - self.bottomView.zl_height - 20.f - 30.f, 30.f, 30.f);
        [_trafficBtn setImage:[UIImage imageNamed:@"icon_traffic_30x30_"] forState:UIControlStateNormal];
        [_trafficBtn setImage:[UIImage imageNamed:@"icon_traffic_pre_30x30_"] forState:UIControlStateSelected];
        [_trafficBtn addTarget:self action:@selector(trafficClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _trafficBtn;
}

- (UIButton *)currentLocationBtn {
    if (!_currentLocationBtn) {
        _currentLocationBtn = [[UIButton alloc] init];
        _currentLocationBtn.frame = CGRectMake(20.f, CGRectGetMinY(self.trafficBtn.frame) - 10.f - 30.f, 30.f, 30.f);
        _currentLocationBtn.backgroundColor = [UIColor whiteColor];
        [_currentLocationBtn setRoundViewWithCornerRaidus:6.f];
        [_currentLocationBtn setImage:[UIImage imageNamed:@"icon_map_location"] forState:UIControlStateNormal];
        [_currentLocationBtn addTarget:self action:@selector(currentLocationClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _currentLocationBtn;
}

#pragma mark - set up view
- (void)dealloc {
    ZLFuncLog;
    [self invalidateTimer];
    [self clearMemory];
}
- (void)clearMemory {
    
    self.mapView = nil;
    self.carLocation = nil;
    self.carAnnotation = nil;
    self.route = nil;
    self.naviRoute = nil;
    self.mapSearch = nil;
    self.startStationInfo = nil;
    self.endStationInfo = nil;
    self.routeLists = nil;
    self.bubbleLists = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataDic = [[NSMutableDictionary alloc] init];
    self.timeArr = [NSMutableArray array];
    self.poiAnnotationViews = [NSMutableArray array];
    self.annonations = [NSMutableArray array];
    self.carLocationArr = [NSMutableArray array];
    
    
    //    self.view.backgroundColor = [UIColor whiteColor];
    _selectedIndex = 999;
    // Do any additional setup after loading the view.
    [self setupView];
    
    [self loadTicketLineTime];
}


- (void)loadTicketLineTime {
    NSDictionary *param = @{
        @"line_code":self.routeListInfo.line_info_id,
    };
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.91:9005/ticket/line/date/time" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        NSMutableArray *data = [dic objectForKey:@"data"];
        if (data.count > 0) {
            self.timeArr = data;
            self->_line_time = [self.timeArr.firstObject objectForKey:@"line_time"];
            [self loadData];
        }
    } WithFailurBlock:^(NSError *error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork];
    }];
}
- (void)inspect:(NSString *)driver_code{
    NSDictionary *param = @{
        @"driver_code": driver_code,
        @"number": @(self.tripListInfo.number),
        @"ticket_code": self.tripListInfo.ticket_code,
        @"goods_no": self.tripListInfo.goods_no,
    };
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:POST WithPath:@"http://192.168.2.91:9005/ticket/inspect/done" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        TYWJShowAlertViewController *vc = [TYWJShowAlertViewController new];
        [vc showCheckTicketSuccessWithDic:@{@"people":[NSString stringWithFormat:@"%d",self.tripListInfo.number],@"vehicle_no":self.tripListInfo.vehicle_no}];
        vc.buttonSeleted = ^(NSInteger index){
            [ZLNotiCenter postNotificationName:@"TYWJRefreshScheduleList" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD hideAllHUDsForView:CURRENTVIEW animated:YES];
        };
        [TYWJCommonTool presentToVcNoanimated:vc];
    } WithFailurBlock:^(NSError *error) {
        [MBProgressHUD zl_showError:[error.userInfo objectForKey:@"msg"]];
    }];
    
}
- (void)refundTicket:(NSString *) num{
    TYWJTripList *_model = self.tripListInfo;
    NSString *timerStr = [NSString stringWithFormat:@"%@ %@",_model.line_date,_model.line_time];
    long value = [TYWJCommonTool getIntervallWithNow:timerStr];
    int percentage = 0;
    if (value < 1000*60*60*8) {
        percentage = 10;
    }
    int refundFee = _model.price*num.intValue/percentage;
    int refundAmountFee = _model.price*num.intValue - refundFee;
    
    NSDictionary *param = @{
        @"num": @(num.intValue),
        @"remark": @"111",
        @"ticke_no": self.tripListInfo.ticket_code,
        @"refund_fee":@(refundAmountFee),
        @"svr_fee":@(refundFee)
    };
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:POST WithPath:@"http://192.168.2.91:9005/ticket/refund/ticket" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        NSDictionary *userDic = [dic objectForKey:@"data"];
        TYWJShowAlertViewController *vc = [TYWJShowAlertViewController new];
        [vc showRefundsStatusWithDic:@{@"success":@(1)}];
        vc.buttonSeleted = ^(NSInteger index){
            [ZLNotiCenter postNotificationName:@"TYWJRefreshScheduleList" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD hideAllHUDsForView:CURRENTVIEW animated:YES];
            
            
        };
        [TYWJCommonTool presentToVcNoanimated:vc];
        
    } WithFailurBlock:^(NSError *error) {
        TYWJShowAlertViewController *vc = [TYWJShowAlertViewController new];
        [vc showRefundsStatusWithDic:@{@"success":@(0)}];
        vc.buttonSeleted = ^(NSInteger index){
            
            //             [self.navigationController popViewControllerAnimated:YES];
            
        };
        [TYWJCommonTool presentToVcNoanimated:vc];
    }];
    
}
- (void)setupView {
    
    [self.view addSubview:self.mapView];
    
    //    [self.view addSubview:self.trafficBtn];
    //    [self.view addSubview:self.currentLocationBtn];
    if (self.isDetailRoute) {
        [self.routeView.stopsView addSubview:self.routeTableView];
        [self.routeView addSubview:self.arrowBtn];
        [self.view addSubview:self.routeView];
        self.navigationItem.title = @"线路详情";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"导航栏_图标_分享"] style:UIBarButtonItemStylePlain target:self action:@selector(shareClicked)];
        self.navigationItem.rightBarButtonItem.tintColor = kMainBlackColor;
        [self.view addSubview:self.bottomView];
    }else {
        self.navigationItem.title = @"详情";
        TYWJSchedulingDetailStateView *detailStateView = [[[NSBundle mainBundle] loadNibNamed:@"TYWJSchedulingDetailStateView" owner:self options:nil] lastObject];
        [detailStateView confirgViewWithModel:self.tripListInfo];
        detailStateView.zl_width = ZLScreenWidth;
        WeakSelf;
        detailStateView.buttonSeleted = ^(NSInteger index) {
            switch (index -200) {
                case 0:
                {
                    TYWJScanQRcodeViewController *vc = [[TYWJScanQRcodeViewController alloc] init];
                    vc.getScanResult = ^(NSString * _Nonnull url) {
                        NSLog(@"url");
                        if (url.length > 0) {
                            [weakSelf inspect:url];
                            
                        } else {
                            
                            //                            [weakSelf inspect:url];
                            
                        }
                    };
                    [TYWJCommonTool pushToVc:vc];
                }
                    
                    
                    break;
                case 1:
                {
                }
                    break;
                case 2:
                {
                    TYWJShowAlertViewController *vc = [TYWJShowAlertViewController new];
                    [vc showRefundsWithDic:self.tripListInfo];
                    vc.buttonSeleted = ^(NSInteger index){
                        
                        
                    };
                    vc.getData = ^(id  _Nonnull date) {
                        NSString *num = (NSString *)date;
                        [weakSelf refundTicket:num];
                        
                    };
                    [TYWJCommonTool presentToVcNoanimated:vc];
                }
                    break;
                default:
                    break;
            }
        };
        [self.view addSubview:detailStateView];
        //        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_more_22x22_" highImage:@"icon_more_22x22_" target:self action:@selector(moreClicked)];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[TYWJRongCloudTool sharedTool] joinChatRoom:self.routeListInfo.line_info_id];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[TYWJRongCloudTool sharedTool] quitChatRoom:self.routeListInfo.line_info_id];
    [self invalidateTimer];
    [MBProgressHUD zl_hideHUD];
}

#pragma mark - button clicked

/**
 底部车票按钮点击
 */
- (void)bottomTicketClicked {
    ZLFuncLog;
    
}
/**
 分享按钮点击
 */
- (void)shareClicked {
    ZLFuncLog;
    [self showShareUI];
}



/**
 购买按钮点击
 */
- (void)buyAction{
    ZLFuncLog;
    TYWJBuyTicketController *buyTicketVc = [[TYWJBuyTicketController alloc] init];
    buyTicketVc.line_time = _line_time;
    buyTicketVc.line_name = [self.dataDic objectForKey:@"name"];
    buyTicketVc.line_info_id = [self.dataDic objectForKey:@"id"];
    buyTicketVc.routeLists = [[NSMutableArray alloc] initWithArray:self.routeLists];
    for (TYWJSubRouteListInfo *info in self.routeLists) {
        info.isStartStation = NO;
        info.isEndStation = NO;
    }
    buyTicketVc.timeArr = self.timeArr;
    TYWJSubRouteListInfo * start = self.routeLists[_startStationIndex];
    TYWJSubRouteListInfo * end = self.routeLists[_endStationIndex];
    start.isStartStation = YES;
    start.isEndStation = NO;
    end.isEndStation = YES;
    end.isStartStation = NO;
    //终点站大于始发站
    if (_startStationIndex > _endStationIndex) {
        start.isStartStation = NO;
        start.isEndStation = YES;
        end.isStartStation = YES;
        end.isEndStation = NO;
    }
    
    
    
    
    
    
    
    [self.navigationController pushViewController:buyTicketVc animated:YES];
}
- (void)purchaseClicked {
    [TYWJGetCurrentController showLoginViewWithSuccessBlock:^{
        [self buyAction];
        
    }];
    
}

/**
 监听点击
 */
- (void)arrowBtnClicked:(UIButton *)btn {
    if (btn.selected) {
        //收缩
        [self shrinkView];
    }else {
        //放大
        [self expandView];
    }
}


- (void)s2dClicked {
    ZLFuncLog;
    [self expandView];
}

/**
 定位到当前位置点击
 */
- (void)currentLocationClicked {
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    [_mapView setZoomLevel:15 animated:YES];
}
/**
 显示交通状况按钮点击
 */
- (void)trafficClicked:(UIButton *)btn {
    if (btn.selected) {
        self.mapView.showTraffic = NO;
    }else {
        self.mapView.showTraffic = YES;
    }
    btn.selected = !btn.selected;
}
#pragma mark - 展开/收缩 view

/**
 展开视图
 */
- (void)expandView {
    //展开的话，则直接返回
    if (self.isExpansionView) return;
    if (self.routeLists.count == 0) return;
    
    WeakSelf;
    [UIView animateWithDuration:kTimeInterval delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.routeTableView.alpha = 1;
        
        weakSelf.routeView.zl_height += weakSelf.expansionViewDeltaH;
        weakSelf.routeView.stopsView.zl_height += weakSelf.expansionViewDeltaH;
        weakSelf.routeTableView.zl_height = weakSelf.routeView.stopsView.zl_height - 10;
        weakSelf.routeView.zl_y -= weakSelf.expansionViewDeltaH;
        
    } completion:^(BOOL finished) {
        self.arrowBtn.selected = YES;
        self.isExpansionView = YES;
    }];
}

/**
 收缩视图
 */
- (void)shrinkView {
    //收缩的话，直接返回
    if (!self.isExpansionView) return;
    
    CGRect newF = self.routeView.frame;
    newF.size.height = kRouteViewH;
    
    WeakSelf;
    [UIView animateWithDuration:kTimeInterval delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.routeView.zl_height -= weakSelf.expansionViewDeltaH;
        weakSelf.routeView.stopsView.zl_height -= weakSelf.expansionViewDeltaH;
        weakSelf.routeTableView.zl_height = weakSelf.routeView.stopsView.zl_height + 10;
        weakSelf.routeView.zl_y += weakSelf.expansionViewDeltaH;
        
        weakSelf.routeTableView.alpha = 0;
    } completion:^(BOOL finished) {
        weakSelf.arrowBtn.selected = NO;
        weakSelf.isExpansionView = NO;
    }];
}
#pragma mark - 加载数据

- (void)loadData {
    if (!self.routeListInfo) {
        return;
    }
    WeakSelf;
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.91:9003/trip/detail" WithParams:@{@"line_info_id":self.routeListInfo.line_info_id} WithSuccessBlock:^(NSDictionary *dic) {
        NSDictionary *data = [dic objectForKey:@"data"];
        if (data.allKeys.count > 0) {
            self.dataDic = [NSMutableDictionary dictionaryWithDictionary:data];
            [self.dataDic setValue:self.timeArr forKey:@"timeList"];
            [self.routeView configView:self.dataDic];
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:[self.dataDic objectForKey:@"start"]];
            [arr addObjectsFromArray:[self.dataDic objectForKey:@"ways"]];
            [arr addObject:[self.dataDic objectForKey:@"end"]];
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
                if (0 == i) {
                    
                    self.startStationInfo = info;
                    _startStationIndex = i;
                    info.isStartStation = YES;
                    
                }
                if (count - 1 == i) {
                    
                    self.endStationInfo = info ;
                    _endStationIndex = i;
                    info.isStartStation = YES;
                    
                }
                [listarr addObject:info];
            }
            weakSelf.routeLists = listarr;
            weakSelf.expansionViewDeltaH = kTableViewRowH*(self.routeLists.count);
            if (weakSelf.expansionViewDeltaH > ZLScreenHeight/2) {
                weakSelf.expansionViewDeltaH = ZLScreenHeight/2;
            }
            [weakSelf.routeTableView reloadData];
            [weakSelf configureCustomRoute];
            [weakSelf configureRoute];
        }else {
            [MBProgressHUD zl_showError:@"线路加载失败" toView:self.view];
        }
        
    } WithFailurBlock:^(NSError *error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:self.view];
    }];
}
- (NSArray *)arrWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return arr;
}
- (void)loadCarLocation {
    //清楚所有车位置重新绘制新的
    if (self.carLocationArr.count > 0) {
        [self.mapView removeOverlays:self.carLocationArr];
        [self.carLocationArr removeAllObjects];
    }
    NSDictionary *param = @{
        @"line_code":self.routeListInfo.line_info_id,
    };
    [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"http://192.168.2.91:9003/gps/find/route" WithParams:param WithSuccessBlock:^(NSDictionary *dic) {
        NSArray *arr = [dic objectForKey:@"data"];
        if (!(arr.count > 0)) {
            return;
        }
        NSMutableArray *items = [NSMutableArray array];
        
        for (NSDictionary *dic in arr) {
            NSArray *loc = [dic objectForKey:@"loc"];
            MAMultiPointItem *item = [[MAMultiPointItem alloc] init];
            NSString *lon = loc.firstObject;
            NSString *lat = loc.lastObject;
            item.coordinate = CLLocationCoordinate2DMake(lat.doubleValue, lon.doubleValue);
            
            [items addObject:item];
            
        }
        ///根据items创建海量点Overlay MultiPointOverlay
        MAMultiPointOverlay *_overlay = [[MAMultiPointOverlay alloc] initWithMultiPointItems:items];
        [self.carLocationArr addObject:_overlay];
        ///把Overlay添加进mapView
        [self.mapView addOverlay:_overlay];
    } WithFailurBlock:^(NSError *error) {
        
    } showLoad:NO];
}

#pragma mark - 传入的参数

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _selectedIndex) {
        return kRowH + 40;
    }
    return kRowH;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.routeTableView) {
        return self.routeLists.count;
    }
    return self.bubbleLists.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYWJDetailStationCell *cell = [TYWJDetailStationCell cellForTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TYWJSubRouteListInfo *list = self.routeLists[indexPath.row];
    NSInteger totalTime = 0;
    for (int i = 0; i< indexPath.row + 1; i++) {
        TYWJSubRouteListInfo *model = self.routeLists[i];
        totalTime += model.time.intValue;
    }
    list.estimatedTime = [TYWJCommonTool getTimeWithTimeStr:list.startTime intervalStr:[NSString stringWithFormat:@"%ld",(long)totalTime]];
    list.startTime = _line_time;
    
    if (indexPath.row == _selectedIndex) {
        cell.startBtn.hidden = NO;
        cell.endBtn.hidden = NO;
    }
    
    if (_selectedIndex == indexPath.row) {
        cell.nameL.textColor = kMainYellowColor;
        cell.timeL.textColor = kMainYellowColor;
    }
    if (indexPath.row == 0) {
        cell.showTopView.hidden = NO;
        cell.stationImage.image = [UIImage imageNamed:@"线路详情_路线图_起终点椭圆形"];
    }
    if (indexPath.row == self.routeLists.count -1) {
        cell.showBottomView.hidden = NO;
        cell.stationImage.image = [UIImage imageNamed:@"线路详情_路线图_起终点椭圆形"];
    }
    cell.buttonSeleted = ^(NSInteger index) {
        if (index == 200) {
            [MBProgressHUD zl_showSuccess:@"设置为起点" toView:self.view];
        } else {
            [MBProgressHUD zl_showSuccess:@"设置为终点" toView:self.view];
            
        }
        if (index - 200) {
            if (self->_startStationIndex > self->_endStationIndex) {
                self->_startStationIndex=self->_startStationIndex^self->_endStationIndex;
                self->_endStationIndex=self->_startStationIndex^self->_endStationIndex;
                self->_startStationIndex=self->_startStationIndex^self->_endStationIndex;
            } else {
                self->_startStationIndex = indexPath.row;
            }
        }else{
            if (self->_startStationIndex > self->_endStationIndex) {
                self->_startStationIndex=self->_startStationIndex^self->_endStationIndex;
                self->_endStationIndex=self->_startStationIndex^self->_endStationIndex;
                self->_startStationIndex=self->_startStationIndex^self->_endStationIndex;
            } else {
                self->_endStationIndex = indexPath.row;
            }
        }
        [tableView reloadData];
    };
    if (indexPath.row == _endStationIndex || indexPath.row == _startStationIndex ) {
        cell.stationImage.image = [UIImage imageNamed:@"线路详情_路线图_选择起点"];
        
    }
    [cell configCellWithData:list];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_selectedIndex == indexPath.row) {
        _selectedIndex = 999;
    } else {
        _selectedIndex = indexPath.row;
    }
    [tableView reloadData];
    TYWJSubRouteListInfo *list = self.routeLists[indexPath.row];
    [self showSelectedRegionWithListInfo:list];
    for (MAPointAnnotation *pointAnn in self.mapView.annotations) {
        if (list.latitude.doubleValue == pointAnn.coordinate.latitude) {
            [self.mapView selectAnnotation:pointAnn animated:YES];
            [self.mapView setCenterCoordinate:pointAnn.coordinate animated:YES];
            break;
        }
    }
    
    //因为用的strong，所以可以直接修改自己的info属性二改变s2dView的info属性内容
    self.routeListInfo.stopStop = list.station;
    self.routeListInfo.stopTime = list.time;
    self.routeListInfo.stopStopId = list.stationID;
}
#pragma mark - 地图相关
#pragma mark - AMapSearchDelegate
/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    if (response.route == nil)
    {
        return;
    }
    
    self.route = response.route;
    
    if (response.count > 0)
    {
        [self presentCurrentCourse];
    }
}

#pragma mark - MAMapViewDelegate

/**
 更新当前位置的方向
 */
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (!updatingLocation && self.userLocationAnnotationView != nil) {
        [UIView animateWithDuration:0.1 animations:^{
            double degree = userLocation.heading.trueHeading - self.mapView.rotationDegree;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
        }];
    }
}
/**
 * @brief 单击地图回调，返回经纬度
 * @param mapView 地图View
 * @param coordinate 经纬度
 */
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    //点击点图
    //收缩view
    [self shrinkView];
}


#pragma mark -


- (void)showSelectedRegionWithListInfo:(TYWJSubRouteListInfo *)info {
    CGFloat longtitude = info.longitude.doubleValue;
    CGFloat latitude = info.latitude.doubleValue;
    
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(latitude, longtitude) animated:YES];
    [self.mapView setZoomLevel:15 animated:YES];
}

- (void)configureRoute {
    NSArray *arr = [self.dataDic objectForKey:@"route"];
    NSMutableArray *wayPoints = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        NSString *longitude = arr[i][0];
        NSString *latitude = arr[i][1];
        AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:latitude.doubleValue
                                                       longitude:longitude.doubleValue];
        [wayPoints addObject:point];
    }
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    navi.strategy = 5;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startStationInfo.latitude.floatValue
                                           longitude:self.startStationInfo.longitude.floatValue];
    
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.endStationInfo.latitude.floatValue
                                                longitude:self.endStationInfo.longitude.floatValue];
    navi.waypoints = wayPoints;
    [self.mapSearch AMapDrivingRouteSearch:navi];
}

- (void)configureCustomRoute {
    NSInteger count = self.routeLists.count;
    CLLocationCoordinate2D commonPolylineCoords[count];
    for (NSInteger i = 0; i < count; i++) {
        TYWJSubRouteListInfo *info = self.routeLists[i];
        commonPolylineCoords[i].latitude = info.latitude.doubleValue;
        commonPolylineCoords[i].longitude = info.longitude.doubleValue;
    }
    [self showRouteForCoords:commonPolylineCoords count:count];
    self.routeListInfo.startStopId = self.startStationInfo.stationID;
    self.routeListInfo.stopStopId = self.endStationInfo.stationID;
}

/**
 这个主要用于将自定义的点添加到路线上
 */
- (void)showRouteForCoords:(CLLocationCoordinate2D *)coords count:(NSUInteger)count
{
    [self validateTimer];
    NSMutableArray *routeAnno = [NSMutableArray array];
#ifdef DEBUG
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH.mm";
    NSTimeInterval nowTime = [[formatter dateFromString: [formatter stringFromDate: [NSDate date]]] timeIntervalSince1970];
    NSTimeInterval startingTime = [[formatter dateFromString:self.routeListInfo.startingTime] timeIntervalSince1970];
    NSTimeInterval stopTime = [[formatter dateFromString:self.routeListInfo.stopTime] timeIntervalSince1970];
    self.carAnnotation = [[MAAnimatedAnnotation alloc] init];
    self.carAnnotation.coordinate = coords[0];
    [routeAnno addObject:self.carAnnotation];
    if ((nowTime >= startingTime && nowTime <= stopTime) || [self.routeListInfo.carStatus isEqualToString: @"已发车"]) {
        self.carAnnotation = [[MAAnimatedAnnotation alloc] init];
        self.carAnnotation.coordinate = coords[0];
        [routeAnno addObject:self.carAnnotation];
    }
#else
    if (self.isDetailRoute == YES) {
        self.carAnnotation = [[MAAnimatedAnnotation alloc] init];
        self.carAnnotation.coordinate = coords[0];
        [routeAnno addObject:self.carAnnotation];
    }
#endif
    
    
    for (int i = 0 ; i < count; i++)
    {
        MAPointAnnotation *a = [[MAPointAnnotation alloc] init];
        a.coordinate = coords[i];
        a.title = @"route";
        [routeAnno addObject:a];
    }
    [self.mapView addAnnotations:routeAnno];
    [self.mapView showAnnotations:routeAnno animated:YES];
}


//根据导航类型绘制覆盖物
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    _annonation = annotation;
    [self.annonations addObject:annotation];
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        if (![self isGivenStationWithAnnotation:annotation]) {
            return nil;
        }
        if ([annotation isKindOfClass:[MAAnimatedAnnotation class]]) {
            MAAnnotationView *view = (MAAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:MAAnimationAnnotationViewID];
            if (!view) {
                view = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:MAAnimationAnnotationViewID];
            }
            //            view.image = [UIImage imageNamed:@"icon_car_feiniu_180c_13x23_"];
            //设置当前位置annotation的image
            if ([annotation isKindOfClass: [MAUserLocation class]]) {
                view.image = [UIImage imageNamed:@"userPosition"];
                self.userLocationAnnotationView = view;
            }
            return view;
        }
        _poiAnnotationView = (CustomAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:RoutePlanningCellIdentifier];
        if (!_poiAnnotationView)
        {
            _poiAnnotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation
                                                                  reuseIdentifier:RoutePlanningCellIdentifier];
        }
        
        _poiAnnotationView.canShowCallout = NO;
        _poiAnnotationView.image = [UIImage imageNamed:@"icon_get_on2_18x18_"];
        if (self.startStationInfo.latitude.doubleValue == annotation.coordinate.latitude) {
            //起始点
            _poiAnnotationView.image = [UIImage imageNamed:@"icon_ride-start_16x16_"];
        }
        if (self.endStationInfo.latitude.doubleValue == annotation.coordinate.latitude) {
            //结束点
            _poiAnnotationView.image = [UIImage imageNamed:@"icon_ride-end_16x16_"];
        }
        if ([annotation isKindOfClass:[MAUserLocation class]]) {
            _poiAnnotationView.image = [UIImage imageNamed:@"icon_get_on_pre_18x18_"];
        }
        
        if ([self getStataionInfoWithAnnonation:annotation]) {
            _poiAnnotationView.routeListInfo = [self getStataionInfoWithAnnonation:annotation];
        }
        [self.poiAnnotationViews addObject:_poiAnnotationView];
        return _poiAnnotationView;
    }
    return nil;
}

-(MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    //旧版的返回值是MAOverLayView，新版的是MAOverlayRenderer
    //画折线
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineRenderer * polyLine = [[MAPolylineRenderer alloc] initWithPolyline:(MAPolyline *)overlay];
        polyLine.strokeImage = [UIImage imageNamed:@"route_32x32_"];
        //设置属性
        //设置线宽
        polyLine.lineWidth = 18.f;
        return polyLine;
    }
    if ([overlay isKindOfClass:[MAMultiPointOverlay class]])
    {
        MAMultiPointOverlayRenderer * renderer = [[MAMultiPointOverlayRenderer alloc] initWithMultiPointOverlay:overlay];
        
        ///设置图片
        renderer.icon = [UIImage imageNamed:@"icon_car_feiniu_180c_13x23_"];
        ///设置锚点
        renderer.anchor = CGPointMake(0.5, 1.0);
        renderer.delegate = self;
        return renderer;
    }
    return nil;
}

/**
 判断是否在给定站内
 */
- (BOOL)isGivenStationWithAnnotation:(id<MAAnnotation>)annonation {
    //    return YES;
    if ([annonation isKindOfClass: [MAAnimatedAnnotation class]]) {
        return YES;
    }
    for (TYWJSubRouteListInfo *list in self.routeLists) {
        if (annonation.coordinate.latitude == list.latitude.doubleValue) {
            return YES;
        }
        if ([annonation isKindOfClass:[MAUserLocation class]]) {
            return YES;
        }
    }
    return NO;
}
- (TYWJSubRouteListInfo *)getStataionInfoWithAnnonations:(NSArray *)annonations {
    NSInteger totalTime = 0;
    for (TYWJSubRouteListInfo *list in self.routeLists) {
        totalTime += list.time.intValue;
        list.estimatedTime = [TYWJCommonTool getTimeWithTimeStr:list.startTime intervalStr:[NSString stringWithFormat:@"%ld",(long)totalTime]];
        list.startTime = _line_time;
        for (id<MAAnnotation> annonation in annonations) {
            if (list.latitude.doubleValue == annonation.coordinate.latitude) {
                return list;
            }
        }
        
    }
    return nil;
}
- (TYWJSubRouteListInfo *)getStataionInfoWithAnnonation:(id<MAAnnotation>)annonation {
    NSInteger totalTime = 0;
    for (TYWJSubRouteListInfo *list in self.routeLists) {
        totalTime += list.time.intValue;
        list.estimatedTime = [TYWJCommonTool getTimeWithTimeStr:list.startTime intervalStr:[NSString stringWithFormat:@"%ld",(long)totalTime]];
        list.startTime = _line_time;
        if (list.latitude.doubleValue == annonation.coordinate.latitude) {
            return list;
        }
    }
    return nil;
}
/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    MANaviAnnotationType type = MANaviAnnotationTypeDrive;
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[0] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.startStationInfo.latitude.doubleValue longitude:self.startStationInfo.longitude.doubleValue] endPoint:[AMapGeoPoint locationWithLatitude:self.endStationInfo.latitude.doubleValue longitude:self.endStationInfo.longitude.doubleValue]];
    [self.naviRoute addToMapView:self.mapView];
    
    /* 缩放地图使其适应polylines的展示. */
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
                           animated:YES];
}



/* 清空地图上已有的路线. */
- (void)clear
{
    [self.naviRoute removeFromMapView];
}

#pragma mark - 分享
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = @"快快加入胖哒自由行吧~~";
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            ZLLog(@"************Share fail with error %@*********",error);
        }else{
            ZLLog(@"response data is %@",data);
        }
    }];
}

- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //设置文本
    messageObject.text = @"社会化组件UShare将各大社交平台接入您的应用，快速武装App。";
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    //    shareObject.thumbImage = [UIImage imageNamed:@"activity_empty_113x107_"];
    [shareObject setShareImage:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530089998641&di=54dc4e45c6aa29adc6a16052898d5996&imgtype=0&src=http%3A%2F%2Fp0.qhimgs4.com%2Ft01ae9d3a8e43253772.jpg"];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            ZLLog(@"************Share fail with error %@*********",error);
        }else{
            ZLLog(@"response data is %@",data);
        }
    }];
}

- (void)showShareUI {
    WeakSelf;
    
    TYWJShowAlertViewController *vc = [TYWJShowAlertViewController new];
    [vc showShareViewWithDic:@{}];
    vc.buttonSeleted = ^(NSInteger index){
        switch (index - 200) {
            case 1:
            {
                [weakSelf shareTextToPlatformType:UMSocialPlatformType_WechatSession];
                
            }
                break;
            case 2:
            {
                [weakSelf shareTextToPlatformType:UMSocialPlatformType_WechatTimeLine];
                
            }
                break;
            default:
                break;
        }        
    };
    [TYWJCommonTool presentToVcNoanimated:vc];
}


#pragma mark - 定时器相关

- (void)validateTimer {
    self.timer = [NSTimer timerWithTimeInterval:10.f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

- (void)invalidateTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)countDown {
    [self loadCarLocation];
}
@end
