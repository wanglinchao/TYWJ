//
//  TYWJLaunchedController.m
//  TYWJBus
//
//  Created by Harley He on 2018/8/1.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJLaunchedController.h"
#import "TYWJMapNaviController.h"
#import "TYWJSingleLocation.h"
#import "MANaviRoute.h"
#import "CommonUtility.h"
#import <MJExtension.h>

#import "TYWJDriverRouteList.h"
#import "TYWJSoapTool.h"
#import "TYWJSubRouteList.h"
#import "CustomAnnotationView.h"
#import "TYWJDriverLaunchedHeaderView.h"
#import "SpeechSynthesizer.h"

static CGFloat kHeaderHeight = 125.f;
static NSString  *const RoutePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
static const NSInteger RoutePlanningPaddingEdge                    = 20;


@interface TYWJLaunchedController()<MAMapViewDelegate,AMapSearchDelegate>

/* mapView */
@property (strong, nonatomic) MAMapView *mapView;
/* routeLists */
@property (strong, nonatomic) NSArray *routeLists;
/* 起始点info */
@property (strong, nonatomic) TYWJSubRouteListInfo *startStationInfo;
/* 结束点info */
@property (strong, nonatomic) TYWJSubRouteListInfo *endStationInfo;
/* mapSearch */
@property (strong, nonatomic) AMapSearchAPI *mapSearch;
/* 用于显示当前路线方案. */
@property (nonatomic,strong) MANaviRoute *naviRoute;
@property (nonatomic, strong) AMapRoute *route;

/* MAAnimatedAnnotation */
@property (strong, nonatomic) MAAnimatedAnnotation *carAnnotation;

/* headerView */
@property (strong, nonatomic) TYWJDriverLaunchedHeaderView *headerView;
/* 导航去下一站 */
@property (strong, nonatomic) UIButton *nextStationBtn;
/* 下一站view */
@property (strong, nonatomic) UIView *nextStationView;

/* 当前站index */
@property (assign, nonatomic) NSInteger currentStationIndex;
/* 当前站点数组中的index */
@property (assign, nonatomic) NSInteger currentIndex;
/* 当前位置 */
@property (strong, nonatomic) CLLocation *currLocation;

/* timer */
//@property (strong, nonatomic) NSTimer *timer;
/* 是否经过第一站 */
@property (assign, nonatomic) BOOL isDrivenPassFirstStation;

@end

@implementation TYWJLaunchedController
- (UIView *)nextStationView {
    if (!_nextStationView) {
        _nextStationView = [[UIView alloc] init];
        _nextStationView.frame = CGRectMake(self.view.zl_width - 120.f, kHeaderHeight + kNavBarH, 120.f, 60.f);
        _nextStationView.backgroundColor = [UIColor clearColor];
        [_nextStationView setBorderWithColor: ZLNavTextColor];
        [_nextStationView setRoundView];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.alpha = 0.85;
        effectView.frame = _nextStationView.bounds;
        [_nextStationView addSubview:effectView];
    }
    return _nextStationView;
}
- (UIButton *)nextStationBtn {
    if (!_nextStationBtn) {
        _nextStationBtn = [[UIButton alloc] init];
        _nextStationBtn.frame = self.nextStationView.bounds;
        [_nextStationBtn setTitle:@"导航下一站" forState:UIControlStateNormal];
        [_nextStationBtn setTitleColor:ZLNavTextColor forState:UIControlStateNormal];
        [_nextStationBtn setRoundView];
        [_nextStationBtn addTarget:self action:@selector(nextStationClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextStationBtn;
}
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
        [AMapServices sharedServices].enableHTTPS = YES;
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, kNavBarH, ZLScreenWidth, self.view.zl_height - kNavBarH)];
        
        ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
//        _mapView.showsUserLocation = YES;
//        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        
        [_mapView setZoomLevel:15 animated:YES];
        _mapView.showsCompass = NO;
        _mapView.rotateEnabled = NO;
        //关闭3D旋转
        _mapView.rotateCameraEnabled = NO;
        _mapView.delegate = self;
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_mapView setMaxZoomLevel:20];
    }
    return _mapView;
}

- (TYWJDriverLaunchedHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"TYWJDriverLaunchedHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, kNavBarH, self.view.zl_width, kHeaderHeight);
        WeakSelf;
        __weak TYWJDriverLaunchedHeaderView *weakHeader = _headerView;
        _headerView.lastStationClicked = ^{
            //上一站点击
            weakHeader.listInfo = [weakSelf getLastStation];
            weakHeader.isTheLastStation = NO;
        };
        _headerView.nextStationClicked = ^{
            //下一站点击
            if (weakSelf.currentStationIndex == weakSelf.routeLists.count - 1) {
                //收车点击
                [weakSelf requestCloseRoute];
                return;
            }
            weakHeader.listInfo = [weakSelf getNextStation];
            weakHeader.isTheLastStation = weakSelf.currentStationIndex == weakSelf.routeLists.count - 1;
            
        };
    }
    return _headerView;
}

#pragma mark - set up view
- (void)dealloc {
    ZLFuncLog;
    
    [[TYWJSingleLocation stantardLocation] stopUpdatingLocation];
    [ZLNotiCenter postNotificationName:TYWJCloseRouteNoti object:nil];
    [TYWJCommonTool sharedTool].listInfo = self.listInfo;
    [TYWJCommonTool sharedTool].currentStationIndex = self.currentStationIndex;
    [TYWJCommonTool sharedTool].currentIndex = self.currentIndex;
    //关闭屏幕常亮
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self loadRouteData];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if ([SpeechSynthesizer sharedSpeechSynthesizer].isSpeaking) {
        [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    }
    
}


- (void)setupView {
    //保持屏幕常亮
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.isDrivenPassFirstStation = NO;
    self.navigationItem.title = @"已发车";
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.nextStationView];
    [self.nextStationView addSubview:self.nextStationBtn];
    
    if ([self.listInfo.carStatus isEqualToString:@"已发车"] && [[TYWJCommonTool sharedTool] isSameRouteWithListInfo:self.listInfo]) {
        self.currentStationIndex = [TYWJCommonTool sharedTool].currentStationIndex;
        self.currentIndex = [TYWJCommonTool sharedTool].currentIndex;
    }else {
        self.currentStationIndex = 0;
        self.currentIndex = 0;
    }
    
    //设置静音模式下开启声音
    [TYWJCommonTool settingPlaySoundUnderMuteMode];
    
    if ([[TYWJCommonTool sharedTool] getSystemVolume] < 0.45f) {
        [MBProgressHUD zl_showAlert:@"音量过低,请调高音量" afterDelay:2.f];
    }
}

#pragma mark - 按钮点击

- (void)nextStationClicked {
    ZLFuncLog;
    if (!self.currLocation) {
        [MBProgressHUD zl_showError:@"暂未获取到当前定位点,请稍后重试"];
        return;
    }
    if ([SpeechSynthesizer sharedSpeechSynthesizer].isSpeaking) {
        [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    }
    TYWJSubRouteListInfo *nextInfo = [self getNextLocationStation];
    TYWJMapNaviController *mapNaviVc = [[TYWJMapNaviController alloc] init];
    mapNaviVc.startCoord = self.currLocation.coordinate;
    mapNaviVc.endCoord = CLLocationCoordinate2DMake(nextInfo.latitude.doubleValue, nextInfo.longitude.doubleValue);
    [self.navigationController pushViewController:mapNaviVc animated:YES];
}

#pragma mark - 获取上一站下一站

- (TYWJSubRouteListInfo *)getLastStation {
    if (self.currentStationIndex == 0) {
        TYWJSubRouteList *lastStation = self.routeLists[0];
        return lastStation.routeListInfo;
    }
    TYWJSubRouteList *lastStation = self.routeLists[--self.currentStationIndex];
    return lastStation.routeListInfo;
}


- (TYWJSubRouteListInfo *)getNextStation {
    if (self.currentStationIndex == self.routeLists.count - 1) {
        TYWJSubRouteList *lastStation = self.routeLists[self.currentStationIndex];
        return lastStation.routeListInfo;
    }
    TYWJSubRouteList *lastStation = self.routeLists[++self.currentStationIndex];
    return lastStation.routeListInfo;
}

- (TYWJSubRouteListInfo *)getNextLocationStation {
    if (self.currentIndex == self.routeLists.count - 1) {
        TYWJSubRouteList *lastStation = self.routeLists[self.currentIndex];
        return lastStation.routeListInfo;
    }
    TYWJSubRouteList *lastStation = self.routeLists[self.currentIndex + 1];
    return lastStation.routeListInfo;
}

- (TYWJSubRouteListInfo *)getCurrentLocationStationWithIndex:(NSInteger)index {
    if (index >= 0 && index < self.routeLists.count) {
        TYWJSubRouteList *lastStation = self.routeLists[index];
        return lastStation.routeListInfo;
    }
    return nil;
    
}

#pragma mark - 加载数据
- (void)loadRouteData {
    WeakSelf;
    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:self.view];
    NSString * soapBodyStr = [NSString stringWithFormat:
                              @"<%@ xmlns=\"%@\">\
                              <xlbh>%@</xlbh>\
                              </%@>",TYWJRequesrSubRouteList,TYWJRequestService,self.listInfo.routeNum,TYWJRequesrSubRouteList];
    [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:soapBodyStr success:^(id responseObject) {
        [MBProgressHUD zl_hideHUDForView:self.view];
        if (responseObject) {
            ZLFuncLog;
            NSArray *dataArr = responseObject[0][@"NS1:xianlubiaozibiaoResponse"][@"xianlubiaozibiaoList"][@"xianlubiaozibiao"];
            if (dataArr) {
                weakSelf.routeLists = [TYWJSubRouteList mj_objectArrayWithKeyValuesArray:dataArr];
                [weakSelf configureCustomRoute];
                [weakSelf configureRoute];
                weakSelf.headerView.listInfo = [weakSelf getCurrentLocationStationWithIndex:weakSelf.currentStationIndex];
                
                weakSelf.headerView.isTheLastStation = weakSelf.currentStationIndex == weakSelf.routeLists.count - 1;
            }else {
                [MBProgressHUD zl_showError:@"线路加载失败" toView:weakSelf.view];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD zl_hideHUDForView:self.view];
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:weakSelf.view];
    }];
    
}

- (void)requestUploadDriverLocationWithCoord:(CLLocationCoordinate2D)coord {
    //TYWJRequestUploadDiverLocation
    NSString *soapBodyStr = [NSString stringWithFormat:
                              @"<%@ xmlns=\"%@\">\
                              <xl>%@</xl>\
                              <jingdu>%@</jingdu>\
                              <weidu>%@</weidu>\
                              <chengshi>%@</chengshi>\
                              </%@>",TYWJRequestUploadDiverLocation,TYWJRequestService,self.listInfo.routeNum,@(coord.longitude),@(coord.latitude),[TYWJCommonTool sharedTool].selectedCity.cityID,TYWJRequestUploadDiverLocation];
    [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:soapBodyStr success:^(id responseObject) {
        if ([responseObject[0][@"NS1:weizhiinsertResponse"] isEqualToString:@"ok"]) {
            ZLLog(@"上传司机位置成功");
        }else {
            ZLLog(@"上传司机位置失败");
        }
    } failure:^(NSError *error) {
        ZLLog(@"上传司机位置失败---网络差");
    }];
}

- (void)requestCloseRoute {
    //TYWJRequestUploadDiverLocation
    WeakSelf;
    [MBProgressHUD zl_showMessage:@"正在收车" toView:self.view];
    NSString * soapBodyStr = [NSString stringWithFormat:
                              @"<%@ xmlns=\"%@\">\
                              <xlbh>%@</xlbh>\
                              </%@>",TYWJRequsetCloseRoute,TYWJRequestService,self.listInfo.routeNum,TYWJRequsetCloseRoute];
    [TYWJSoapTool SOAPDataWithoutLoadingWithSoapBody:soapBodyStr success:^(id responseObject) {
        if ([responseObject[0][@"NS1:sijishoucheResponse"] isEqualToString:@"ok"]) {
            [MBProgressHUD zl_showSuccess:@"收车成功"];
            [ZLNotiCenter postNotificationName:TYWJCloseRouteNoti object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [[TYWJSingleLocation stantardLocation] stopUpdatingLocation];
        }else {
            [MBProgressHUD zl_showSuccess:@"收车失败,请重试" toView:weakSelf.view];
        }
    } failure:^(NSError *error) {
        ZLLog(@"上传司机位置失败---网络差");
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:weakSelf.view];
    }];
}

#pragma mark - 线路配置
- (void)configureRoute {
    
    NSMutableArray *wayPoints = [NSMutableArray array];
    for (TYWJSubRouteList *list in self.routeLists) {
        if ([list isEqual:self.routeLists.firstObject] || [list isEqual:self.routeLists.lastObject]) {
            continue;
        }
        AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:list.routeListInfo.latitude.doubleValue
                                                       longitude:list.routeListInfo.longitude.doubleValue];
        [wayPoints addObject:point];
    }
    
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    navi.strategy = 5;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startStationInfo.latitude.doubleValue
                                           longitude:self.startStationInfo.longitude.doubleValue];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.endStationInfo.latitude.doubleValue
                                                longitude:self.endStationInfo.longitude.doubleValue];
    navi.waypoints = wayPoints;
    [self.mapSearch AMapDrivingRouteSearch:navi];
}

- (void)configureCustomRoute {
    
    NSInteger count = self.routeLists.count;
    CLLocationCoordinate2D commonPolylineCoords[count];
    for (NSInteger i = 0; i < count; i++) {
        TYWJSubRouteList *list = self.routeLists[i];
        commonPolylineCoords[i].latitude = list.routeListInfo.latitude.doubleValue;
        commonPolylineCoords[i].longitude = list.routeListInfo.longitude.doubleValue;
        if (0 == i) {
            self.startStationInfo = list.routeListInfo;
        }
        if (count - 1 == i) {
            self.endStationInfo = list.routeListInfo;
        }
    }
    //构造折线对象
    //参数一：多个点组成的类似数组的经纬度数据
    //参数二：构成折线总共涉及到几个点
    [self showRouteForCoords:commonPolylineCoords count:count];
    
}

/**
 这个主要用于将自定义的点添加到路线上
 */
- (void)showRouteForCoords:(CLLocationCoordinate2D *)coords count:(NSUInteger)count
{
    self.carAnnotation = [[MAAnimatedAnnotation alloc] init];
    self.carAnnotation.coordinate = coords[0];
    self.carAnnotation.title = @"animation";
    [self.mapView addAnnotation:self.carAnnotation];
    
    NSMutableArray *routeAnno = [NSMutableArray array];
    
    for (int i = 0 ; i < count; i++)
    {
        MAPointAnnotation *a = [[MAPointAnnotation alloc] init];
        a.coordinate = coords[i];
        a.title = @"route";
        [routeAnno addObject:a];
    }
    [self.mapView addAnnotations:routeAnno];
    [self.mapView showAnnotations:routeAnno animated:YES];
    
    
    
    [self performSelector:@selector(delayUpdatingLocation) withObject:nil afterDelay:3];
    
}

- (void)delayUpdatingLocation {
    WeakSelf;
    [[TYWJSingleLocation stantardLocation] startUpdatingLocation];
    [TYWJSingleLocation stantardLocation].updatingLocationCallback = ^(CLLocation *location, AMapLocationReGeocode *reGeocode) {
        //持续定位回调
        weakSelf.currLocation = [location copy];
        CLLocationCoordinate2D locations[1] = {location.coordinate};
        [weakSelf requestUploadDriverLocationWithCoord:location.coordinate];
        [weakSelf.carAnnotation addMoveAnimationWithKeyCoordinates:locations count:sizeof(locations)/sizeof(locations[0]) withDuration:6.f withName:nil completeCallback:nil];
        [weakSelf updateLocationDataWithCurrentCoord:location.coordinate];
        TYWJSubRouteListInfo *stataion = [weakSelf getNextLocationStation];
        CLLocationCoordinate2D nextStationCoord = CLLocationCoordinate2DMake(stataion.latitude.doubleValue, stataion.longitude.doubleValue);
        //检测是否是在给定站点的位置范围内
        if ([[TYWJCommonTool sharedTool] checkPlaceIsAssignedPlaceWithCoord:location.coordinate coord2:nextStationCoord meters:98]) {
            if (weakSelf.currentIndex == 0 && weakSelf.isDrivenPassFirstStation == NO) {
                weakSelf.isDrivenPassFirstStation = YES;
            }
            weakSelf.currentIndex++;
            weakSelf.headerView.listInfo = [weakSelf getNextStation];
            weakSelf.headerView.isTheLastStation = weakSelf.currentStationIndex == weakSelf.routeLists.count - 1;
        }
    };
}

- (void)updateLocationDataWithCurrentCoord:(CLLocationCoordinate2D)currCoord {
    NSInteger count = self.routeLists.count;
    for (NSInteger i = 0; i < count; i++) {
        TYWJSubRouteList *list = self.routeLists[i];
        CLLocationCoordinate2D infoCoord = CLLocationCoordinate2DMake(list.routeListInfo.latitude.doubleValue, list.routeListInfo.longitude.doubleValue);
        if ([[TYWJCommonTool sharedTool] checkPlaceIsAssignedPlaceWithCoord:infoCoord coord2:currCoord meters:150]) {
            if (self.isDrivenPassFirstStation && i == 0) {
                self.currentIndex = count - 2;
                self.currentStationIndex = count - 2;
                break;
            }
            self.currentIndex = i - 1;
            self.currentStationIndex = i - 1;
            break;
        }
    }
}


#pragma mark - mapViewDelegate

//根据导航类型绘制覆盖物
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        if (![self isGivenStationWithAnnotation:annotation]) {
            return nil;
        }
        CustomAnnotationView *poiAnnotationView = (CustomAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:RoutePlanningCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation
                                                                 reuseIdentifier:RoutePlanningCellIdentifier];
        }
        poiAnnotationView.canShowCallout = NO;
        poiAnnotationView.draggable = NO;
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
        if ([annotation.title isEqualToString:@"animation"]) {
            poiAnnotationView.image = [UIImage imageNamed:@"icon_car_feiniu_180c_13x23_"];
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
 选中某个点
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    ZLFuncLog;
    [self.mapView setZoomLevel:16];
    [self.mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
}
/**
 判断是否在给定站内
 */
- (BOOL)isGivenStationWithAnnotation:(id<MAAnnotation>)annonation {
    for (TYWJSubRouteList *list in self.routeLists) {
        if (annonation.coordinate.latitude == list.routeListInfo.latitude.doubleValue) {
            return YES;
        }
        if ([annonation isKindOfClass:[MAUserLocation class]]) {
            return YES;
        }
    }
    return NO;
}

- (TYWJSubRouteListInfo *)getStataionInfoWithAnnonation:(id<MAAnnotation>)annonation {
    for (TYWJSubRouteList *list in self.routeLists) {
        if (list.routeListInfo.latitude.doubleValue == annonation.coordinate.latitude) {
            return list.routeListInfo;
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

@end
