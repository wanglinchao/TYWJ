//
//  TYWJDetailRouteController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/29.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJDetailRouteController.h"
#import "TYWJBuyTicketController.h"
#import "TYWJMyTicketController.h"
#import "TYWJComplaintController.h"

#import "TYWJDetailRouteView.h"
#import "TYWJStartToDestinationView.h"
#import "TYWJBottomPurchaseView.h"
#import "TYWJDetailStationCell.h"
#import "CustomAnnotationView.h"
#import "TYWJBottom2BtnsView.h"
#import "ZLPopoverView.h"
#import "TYWJMyTicketTableCell.h"


#import "TYWJSoapTool.h"
#import "TYWJRouteList.h"
#import "TYWJSubRouteList.h"
#import "TYWJTicketList.h"
#import "TYWJApplyRoute.h"
#import "TYWJCarLocation.h"
//#import "TYWJDriverRouteList.h"
#import "TYWJMonthTicket.h"

#import "MANaviRoute.h"
#import "CommonUtility.h"
#import <MJExtension.h>
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>


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
}
@property (strong, nonatomic) NSDictionary *dataDic;

/* mapView */
@property (strong, nonatomic) MAMapView *mapView;
/* routeView */
@property (strong, nonatomic) TYWJDetailRouteView *routeView;
/* bottomView */
@property (strong, nonatomic) TYWJBottomPurchaseView *bottomView;
/* bottom2btnsView */
@property (strong, nonatomic) TYWJBottom2BtnsView *bottom2BtnsView;
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

/* timer */
@property (strong, nonatomic) NSTimer *timer;
/* carLocation */
@property (strong, nonatomic) TYWJCarLocation *carLocation;
/* MAAnimatedAnnotation */
@property (strong, nonatomic) MAAnimatedAnnotation *carAnnotation;
///记录的上次经纬度
@property (nonatomic, assign) CLLocationCoordinate2D lastCoordinate;
//当前位置
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

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
        if (self.driverListInfo) {
            tabbarH = 0;
            bottomViewH = 0;
        }
        [AMapServices sharedServices].enableHTTPS = YES;
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, kNavBarH, ZLScreenWidth, self.view.zl_height - tabbarH - bottomViewH - kNavBarH)];
        
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
        
        NSString *startStop = nil;
        NSString *stopStop = nil;
        if (self.isDetailRoute) {
            startStop = self.routeListInfo.startingStop;
            stopStop = self.routeListInfo.stopStop;
        }else {
            startStop = self.ticket.startStation;
            stopStop = self.ticket.desStation;
            if (self.monthTicket) {
                startStop = self.monthTicket.gmqsz;
                stopStop = self.monthTicket.gmzdz;
            }
        }
    }
    return _routeView;
}

- (TYWJBottomPurchaseView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[TYWJBottomPurchaseView alloc] initWithFrame:CGRectMake(0, self.view.zl_height - kTabBarH - kBottomViewH, ZLScreenWidth, kTabBarH + kBottomViewH)];
        [_bottomView addTarget:self action:@selector(purchaseClicked)];
        _bottomView.showTips = NO;
        [_bottomView setPrice: self.routeListInfo.price];
    }
    return _bottomView;
}

- (TYWJBottom2BtnsView *)bottom2BtnsView {
    if (!_bottom2BtnsView) {
        _bottom2BtnsView = [[[NSBundle mainBundle] loadNibNamed:@"TYWJBottom2BtnsView" owner:nil options:nil] lastObject];
        _bottom2BtnsView.frame = CGRectMake(0, self.view.zl_height - kTabBarH - kBottomViewH, ZLScreenWidth, kTabBarH + kBottomViewH);
        _bottom2BtnsView.userInteractionEnabled = NO;
        
        UIButton *shareBtn = [[UIButton alloc] init];
        shareBtn.frame = _bottom2BtnsView.frame;
        shareBtn.zl_width = self.view.zl_width/2.f;
        shareBtn.zl_x = shareBtn.zl_width;
        [shareBtn addTarget:self action:@selector(shareClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shareBtn];
        
        UIButton *ticketBtn = [[UIButton alloc] init];
        ticketBtn.frame = _bottom2BtnsView.frame;
        ticketBtn.zl_width = shareBtn.zl_width;
        [ticketBtn addTarget:self action:@selector(bottomTicketClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:ticketBtn];
        
    }
    return _bottom2BtnsView;
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
        [_arrowBtn setImage:[UIImage imageNamed:@"icon_up_11x5_"] forState:UIControlStateNormal];
        [_arrowBtn setImage:[UIImage imageNamed:@"icon_down_11x5_"] forState:UIControlStateSelected];
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
    _selectedIndex = 999;
    // Do any additional setup after loading the view.
    [self setupView];
    [self loadData];
}

- (void)setupView {
    
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.routeView];
    
//    [self.view addSubview:self.trafficBtn];
//    [self.view addSubview:self.currentLocationBtn];
    
    [self.routeView addSubview:self.arrowBtn];
    
    [self.routeView.stopsView addSubview:self.routeTableView];
    
//    if (self.driverListInfo) {
//        self.navigationItem.title = self.driverListInfo.routeName;
//        return;
//    }
    
    if (self.isDetailRoute) {
//        self.navigationItem.title = self.routeListInfo.routeName;
        self.navigationItem.title = @"线路详情";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareClicked)];
        [self.view addSubview:self.bottomView];
    }else {
        self.navigationItem.title = @"查看路线";
//        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_more_22x22_" highImage:@"icon_more_22x22_" target:self action:@selector(moreClicked)];
        [self.view addSubview:self.bottom2BtnsView];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self invalidateTimer];
    [MBProgressHUD zl_hideHUD];
}

//- (void)setDriverListInfo:(TYWJDriverRouteListInfo *)driverListInfo {
//    _driverListInfo = [driverListInfo copy];
//    
//    TYWJRouteListInfo *info = [[TYWJRouteListInfo alloc] init];
//    info.startingStop = driverListInfo.startStation;
//    info.startingTime = driverListInfo.startTime;
//    info.stopStop = driverListInfo.endStation;
//    info.stopTime = driverListInfo.endTime;
//    info.routeNum = driverListInfo.routeNum;
//    info.routeName = driverListInfo.routeName;
//    self.routeListInfo = info;
//}

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
    [self loadCarLocationData];
}
#pragma mark - button clicked

/**
 底部车票按钮点击
 */
- (void)bottomTicketClicked {
    ZLFuncLog;
    TYWJMyTicketController *vc = [[TYWJMyTicketController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
- (void)purchaseClicked {
    ZLFuncLog;
    TYWJBuyTicketController *buyTicketVc = [[TYWJBuyTicketController alloc] init];
    buyTicketVc.routeListInfo = self.routeListInfo;
    buyTicketVc.routeLists = self.routeLists;
    buyTicketVc.lastSeats = self.lastSeats;
    [self.navigationController pushViewController:buyTicketVc animated:YES];
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
    WeakSelf;
      [[TYWJNetWorkTolo sharedManager] requestWithMethod:GET WithPath:@"/trip/detail" WithParams:@{@"line_info_id":self.routeListInfo.line_info_id} WithSuccessBlock:^(NSDictionary *dic) {
          NSDictionary *data = [dic objectForKey:@"data"];
          if (data.allKeys.count > 0) {
              self.dataDic = data;
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
                  }
                  if (count - 1 == i) {
                 
                      self.endStationInfo = info ;
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

- (void)loadCarLocationData {
    
    NSString *ID = nil;
    if (self.isDetailRoute) {
        ID = self.routeListInfo.routeNum;
    }else {
        ID = self.ticket.routeID;
        if (self.monthTicket) {
            ID = self.monthTicket.ch;
        }
    }
    WeakSelf;
    NSString * soapBodyStr = [NSString stringWithFormat:
                              @"<%@ xmlns=\"%@\">\
                              <xl>%@</xl>\
                              <chegnshi>%@</chegnshi>\
                              </%@>",TYWJRequestGetCarLocation,TYWJRequestService,ID,[TYWJCommonTool sharedTool].selectedCity.cityID,TYWJRequestGetCarLocation];
    
    [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:soapBodyStr success:^(id responseObject) {
        [MBProgressHUD zl_hideHUD];
        if (responseObject) {
            if (weakSelf.lastCoordinate.latitude == 0){
                weakSelf.carLocation = [TYWJCarLocation mj_objectWithKeyValues:responseObject[0][@"NS1:getweizhiResponse"][@"weizhiList"][@"weizhi"]];
                CLLocationCoordinate2D locations[1] = {CLLocationCoordinate2DMake(weakSelf.carLocation.info.latitude.doubleValue, weakSelf.carLocation.info.longitude.doubleValue)};
//                CLLocationCoordinate2D locations[1] = {CLLocationCoordinate2DMake(30.658952, 104.093445)};
                weakSelf.lastCoordinate = locations[0];
                [weakSelf.carAnnotation addMoveAnimationWithKeyCoordinates:locations count:sizeof(locations)/sizeof(locations[0]) withDuration:0.1f withName:nil completeCallback:^(BOOL isFinished) {

                }];
//                [weakSelf.mapView setCenterCoordinate:locations[0] animated:YES];
            }else {
                weakSelf.carLocation = [TYWJCarLocation mj_objectWithKeyValues:responseObject[0][@"NS1:getweizhiResponse"][@"weizhiList"][@"weizhi"]];
                CLLocationCoordinate2D locations[1] = {CLLocationCoordinate2DMake(weakSelf.carLocation.info.latitude.doubleValue, weakSelf.carLocation.info.longitude.doubleValue)};
//                            CLLocationCoordinate2D locations[1] = {CLLocationCoordinate2DMake(30.658952, 104.093445)};
//                [weakSelf.mapView setCenterCoordinate:locations[0] animated:YES];
                [weakSelf.carAnnotation addMoveAnimationWithKeyCoordinates:locations count:sizeof(locations)/sizeof(locations[0]) withDuration:6.f withName:nil completeCallback:^(BOOL isFinished) {
                    
                }];
            }
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD zl_hideHUD];
    }];
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
    cell.buttonSeleted = ^(NSInteger index) {
            if (index == 200) {
                [MBProgressHUD zl_showSuccess:@"设置为起点" toView:self.view];
            } else {
                [MBProgressHUD zl_showSuccess:@"设置为终点" toView:self.view];

            }
    };
    if (_selectedIndex == indexPath.row) {
        cell.nameL.textColor = kMainYellowColor;
        cell.timeL.textColor = kMainYellowColor;
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
    for (int i = 0; i < arr.count/2; i++) {
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
    NSMutableArray *routeAnno = [NSMutableArray array];
#ifdef DEBUG
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH.mm";
    NSTimeInterval nowTime = [[formatter dateFromString: [formatter stringFromDate: [NSDate date]]] timeIntervalSince1970];
    NSTimeInterval startingTime = [[formatter dateFromString:self.routeListInfo.startingTime] timeIntervalSince1970];
    NSTimeInterval stopTime = [[formatter dateFromString:self.routeListInfo.stopTime] timeIntervalSince1970];
    if ((nowTime >= startingTime && nowTime <= stopTime) || [self.routeListInfo.carStatus isEqualToString: @"已发车"]) {
        self.carAnnotation = [[MAAnimatedAnnotation alloc] init];
        self.carAnnotation.coordinate = coords[0];
        [routeAnno addObject:self.carAnnotation];
        [self validateTimer];
    }
#else
    if (self.isDetailRoute == NO) {
        self.carAnnotation = [[MAAnimatedAnnotation alloc] init];
        self.carAnnotation.coordinate = coords[0];
        [routeAnno addObject:self.carAnnotation];
        [self validateTimer];
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
            view.image = [UIImage imageNamed:@"icon_car_feiniu_180c_13x23_"];
            //设置当前位置annotation的image
            if ([annotation isKindOfClass: [MAUserLocation class]]) {
                view.image = [UIImage imageNamed:@"userPosition"];
                self.userLocationAnnotationView = view;
            }
            return view;
        }
        CustomAnnotationView *poiAnnotationView = (CustomAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:RoutePlanningCellIdentifier];
        if (!poiAnnotationView)
        {
            poiAnnotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:RoutePlanningCellIdentifier];
        }
        poiAnnotationView.canShowCallout = NO;
        poiAnnotationView.image = [UIImage imageNamed:@"icon_get_on2_18x18_"];
        if (self.startStationInfo.latitude.doubleValue == annotation.coordinate.latitude) {
            //起始点
            poiAnnotationView.image = [UIImage imageNamed:@"icon_ride-start_16x16_"];
        }
        if (self.endStationInfo.latitude.doubleValue == annotation.coordinate.latitude) {
            //结束点
            poiAnnotationView.image = [UIImage imageNamed:@"icon_ride-end_16x16_"];
        }
        if ([annotation isKindOfClass:[MAUserLocation class]]) {
            poiAnnotationView.image = [UIImage imageNamed:@"icon_get_on_pre_18x18_"];
        }
        
        if ([self getStataionInfoWithAnnonation:annotation]) {
            poiAnnotationView.routeListInfo = [self getStataionInfoWithAnnonation:annotation];
        }
        return poiAnnotationView;
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

- (TYWJSubRouteListInfo *)getStataionInfoWithAnnonation:(id<MAAnnotation>)annonation {
    for (TYWJSubRouteListInfo *list in self.routeLists) {
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
    messageObject.text = @"快快加入胖哒直通车吧~~";
    
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
    //显示分享面板
    WeakSelf;
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        switch (platformType) {
            case UMSocialPlatformType_WechatTimeLine:
            case UMSocialPlatformType_WechatSession:
//            case UMSocialPlatformType_WechatFavorite:
//            case UMSocialPlatformType_AlipaySession:
            {
                [weakSelf shareTextToPlatformType:platformType];
            }
                break;
                
            default:
                break;
        }
    }];
}
@end
