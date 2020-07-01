//
//  TYWJDetailRouteController.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/29.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJDriveDetailRouteController.h"
#import "TYWJStartToDestinationView.h"
#import "TYWJBottomPurchaseView.h"
#import "CustomAnnotationView.h"
#import "ZLPopoverView.h"
#import "TYWJRouteList.h"
#import "TYWJSubRouteList.h"
#import "TYWJApplyRoute.h"
#import "TYWJCarLocation.h"
#import "MANaviRoute.h"
#import "CommonUtility.h"
#import <MJExtension.h>
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>
#import "TYWJScanQRcodeViewController.h"
#import "TYWJShowAlertViewController.h"
#import "TYWJDriveRouteInfoView.h"

static NSString  * const RoutePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
static NSString * const MAAnimationAnnotationViewID = @"MAAnimationAnnotationViewID";
static const NSInteger RoutePlanningPaddingEdge                    = 20;
@interface TYWJDriveDetailRouteController()<MAMapViewDelegate,UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate>
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


/* mapView */
@property (strong, nonatomic) MAMapView *mapView;

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
@property (nonatomic, strong) TYWJDriveRouteInfoView *driveRouteInfoView;



@property (strong, nonatomic) NSMutableArray *timeArr;

@end

@implementation TYWJDriveDetailRouteController

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
        
        [AMapServices sharedServices].enableHTTPS = YES;
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth, ZLScreenHeight)];
        
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





- (UIButton *)trafficBtn {
    if (!_trafficBtn) {
        _trafficBtn = [[UIButton alloc] init];
        _trafficBtn.frame = CGRectMake(20.f, ZLScreenHeight - kNavBarH - 260, 56.f, 56.f);
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
    self.annonations = [NSMutableArray array];;
    //    self.view.backgroundColor = [UIColor whiteColor];
    _selectedIndex = 999;
    _startStationIndex = 999;
    _endStationIndex = 999;
    // Do any additional setup after loading the view.
    [self setupView];
    
    [self loadData];
}

- (void)setupView {
    
    [self.view addSubview:self.mapView];
    self.driveRouteInfoView = [[TYWJDriveRouteInfoView alloc] initWithFrame:CGRectMake(16, ZLScreenHeight - kNavBarH - 210, ZLScreenWidth - 32, 152)];
    [self.view addSubview:self.driveRouteInfoView];
//    [self.view addSubview:self.trafficBtn];
    [self.view addSubview:self.currentLocationBtn];
    
}
- (void)setStateValue:(NSInteger)stateValue{
    _stateValue = stateValue;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MBProgressHUD zl_hideHUD];
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
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:[self.dataDic objectForKey:@"start"]];
            [arr addObjectsFromArray:[self.dataDic objectForKey:@"ways"]];
            [arr addObject:[self.dataDic objectForKey:@"end"]];
            NSInteger count = arr.count;
            NSMutableArray *listarr = [NSMutableArray array];
            int totalTime = 0;
            for (NSInteger i = 0; i < count; i++) {
                NSDictionary *dic = arr[i];
                NSArray *locarr = [dic objectForKey:@"loc"];
                NSString *name = [dic objectForKey:@"name"];
                
                NSString *time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"time"]];
                totalTime += time.intValue;
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
            
            [self.dataDic setValue:[NSString stringWithFormat:@"%d",totalTime] forKey:@"totalTime"];
            [self.driveRouteInfoView confirgCellWithParam:self.dataDic];

            weakSelf.routeLists = listarr;
  
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
    
}

#pragma mark - 传入的参数
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
    }
#else
    if (self.isDetailRoute == YES) {
        self.carAnnotation = [[MAAnimatedAnnotation alloc] init];
        self.carAnnotation.coordinate = coords[0];
        [routeAnno addObject:self.carAnnotation];
//        [self validateTimer];
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
            view.image = [UIImage imageNamed:@"icon_car_feiniu_180c_13x23_"];
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

@end
