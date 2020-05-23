//
//  TYWJDriverMapController.m
//  TYWJBus
//
//  Created by MacBook on 2018/12/12.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJDriverMapController.h"
#import "TYWJTripsModel.h"
#import "TYWJDriverMapTipsView.h"
#import "CommonUtility.h"

#import "MANaviRoute.h"


static NSString  * const RoutePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
static const NSInteger RoutePlanningPaddingEdge = 20;

@interface TYWJDriverMapController ()<MAMapViewDelegate,AMapSearchDelegate>

/* mapView */
@property (strong, nonatomic) MAMapView *mapView;
//当前位置
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;
/* TYWJDriverMapTipsView */
@property (strong, nonatomic) TYWJDriverMapTipsView *mapTipsView;
/* clockInBtn */
@property (strong, nonatomic) UIButton *clockInBtn;
/* currentLocationBtn */
@property (strong, nonatomic) UIButton *currentLocationBtn;
/* mapSearch */
@property (strong, nonatomic) AMapSearchAPI *mapSearch;

/* 用于显示当前路线方案. */
@property (nonatomic,strong) MANaviRoute *naviRoute;
@property (nonatomic, strong) AMapRoute *route;

@end

@implementation TYWJDriverMapController

- (MAMapView *)mapView {
    if (!_mapView) {
        ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
        [AMapServices sharedServices].enableHTTPS = YES;
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, kNavBarH, ZLScreenWidth, self.view.zl_height - kNavBarH)];
        
        ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
        _mapView.showsUserLocation = YES;
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        
        [_mapView setZoomLevel:15 animated:YES];
        _mapView.showsCompass = YES;
        _mapView.rotateEnabled = NO;
        //关闭3D旋转
        _mapView.rotateCameraEnabled = NO;
        _mapView.delegate = self;
        [_mapView setMaxZoomLevel:19];
    }
    return _mapView;
}


- (TYWJDriverMapTipsView *)mapTipsView {
    if (!_mapTipsView) {
        CGFloat mapTipsViewH = 150.f;
        _mapTipsView = [[NSBundle mainBundle] loadNibNamed:@"TYWJDriverMapTipsView" owner:nil options:nil].firstObject;
        _mapTipsView.frame = CGRectMake(20.f, self.view.zl_height - mapTipsViewH - 40.f, ZLScreenWidth - 40.f, mapTipsViewH);
        _mapTipsView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85f];
        _mapTipsView.trip = self.trip;
        [_mapTipsView setRoundViewWithCornerRaidus:8.f];
    }
    return _mapTipsView;
}

- (UIButton *)clockInBtn {
    if (!_clockInBtn) {
        _clockInBtn = [[UIButton alloc] init];
        _clockInBtn.frame = CGRectMake(20.f, CGRectGetMinY(self.mapTipsView.frame) - 70.f, 50.f, 50.f);
        [_clockInBtn setBackgroundImage:[UIImage imageNamed:@"sign-done"] forState:UIControlStateDisabled];
        [_clockInBtn setBackgroundImage:[UIImage imageNamed:@"sign-willdone"] forState:UIControlStateNormal];
        _clockInBtn.alpha = 0.75f;
        _clockInBtn.enabled = NO;
        _clockInBtn.hidden = YES;
        [_clockInBtn addTarget:self action:@selector(clockInClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clockInBtn;
}

- (UIButton *)currentLocationBtn {
    if (!_currentLocationBtn) {
        _currentLocationBtn = [[UIButton alloc] init];
        _currentLocationBtn.zl_size = CGSizeMake(40.f, 40.f);
        _currentLocationBtn.zl_centerY = self.view.zl_height/2.f;
        _currentLocationBtn.zl_x = ZLScreenWidth - 60.f;
        [_currentLocationBtn setBackgroundImage:[UIImage imageNamed:@"myloc"] forState:UIControlStateNormal];
        [_currentLocationBtn addTarget:self action:@selector(locationClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _currentLocationBtn;
}

- (AMapSearchAPI *)mapSearch {
    if (!_mapSearch) {
        _mapSearch = [[AMapSearchAPI alloc] init];
        _mapSearch.delegate = self;
    }
    return _mapSearch;
}

#pragma mark - set up view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.mapTipsView];
    if (!self.isCheckRoute) {
        [self.view addSubview:self.clockInBtn];
    }
    
    [self.view addSubview:self.currentLocationBtn];
    
    self.navigationItem.title = @"线路详情";
    
    [self configureCustomRoute];
    [self configureRoute];
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
///**
// * @brief 单击地图回调，返回经纬度
// * @param mapView 地图View
// * @param coordinate 经纬度
// */
//- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
//    //点击点图
//    
//}


#pragma mark -


//根据导航类型绘制覆盖物
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        
        if ([annotation isKindOfClass:[MAAnimatedAnnotation class]]) {
            MAAnnotationView *view = (MAAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"MAAnimationAnnotationView"];
            if (!view) {
                view = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MAAnimationAnnotationView"];
            }
            //设置当前位置annotation的image
            if ([annotation isKindOfClass: [MAUserLocation class]]) {
                view.image = [UIImage imageNamed:@"userPosition"];
                self.userLocationAnnotationView = view;
            }
            return view;
        }
            //star_point
        MAAnnotationView *poiAnnotationView = (MAAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:RoutePlanningCellIdentifier];
        if (!poiAnnotationView)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                                 reuseIdentifier:RoutePlanningCellIdentifier];
        }
        poiAnnotationView.canShowCallout = NO;
        poiAnnotationView.image = [UIImage imageNamed:@"end_point"];
        if (annotation.coordinate.latitude == self.trip.departStation.latitude.doubleValue) {
            //起始点
            poiAnnotationView.image = [UIImage imageNamed:@"star_point"];
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
    //route_red
    return nil;
}


#pragma mark - 按钮点击

- (void)clockInClicked {
    ZLFuncLog;
}

- (void)locationClicked {
    ZLFuncLog;
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    [self.mapView setZoomLevel:15 animated:YES];
}

#pragma mark - 线路规划
- (void)configureCustomRoute {
    
    CLLocationCoordinate2D commonPolylineCoords[2];
    
    commonPolylineCoords[0].latitude = self.trip.departStation.latitude.doubleValue;
    commonPolylineCoords[0].longitude = self.trip.departStation.longitude.doubleValue;
    
    commonPolylineCoords[1].latitude = self.trip.arriveStation.latitude.doubleValue;
    commonPolylineCoords[1].longitude = self.trip.arriveStation.longitude.doubleValue;
    //构造折线对象
    //参数一：多个点组成的类似数组的经纬度数据
    //参数二：构成折线总共涉及到几个点
    [self showRouteForCoords:commonPolylineCoords count:2];
    
    
}

- (void)configureRoute {
    
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    navi.strategy = 5;
    /* 出发点. */
    
    navi.origin = [AMapGeoPoint locationWithLatitude:self.trip.departStation.latitude.doubleValue
                                           longitude:self.trip.departStation.longitude.doubleValue];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.trip.arriveStation.latitude.doubleValue
                                                longitude:self.trip.arriveStation.longitude.doubleValue];
    [self.mapSearch AMapDrivingRouteSearch:navi];
}

/**
 这个主要用于将自定义的点添加到路线上
 */
- (void)showRouteForCoords:(CLLocationCoordinate2D *)coords count:(NSUInteger)count
{
    NSMutableArray *routeAnno = [NSMutableArray array];
    
    
    MAPointAnnotation *a = [[MAPointAnnotation alloc] init];
    a.coordinate = CLLocationCoordinate2DMake(self.trip.departStation.latitude.doubleValue, self.trip.departStation.longitude.doubleValue);
    a.title = @"route";
    [routeAnno addObject:a];
    
    MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
    a1.coordinate = CLLocationCoordinate2DMake(self.trip.arriveStation.latitude.doubleValue, self.trip.arriveStation.longitude.doubleValue);
    a1.title = @"route";
    [routeAnno addObject:a1];
    
    [self.mapView addAnnotations:routeAnno];
    [self.mapView showAnnotations:routeAnno animated:YES];
}

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

/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    MANaviAnnotationType type = MANaviAnnotationTypeDrive;
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[0] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.trip.departStation.latitude.doubleValue longitude:self.trip.departStation.longitude.doubleValue] endPoint:[AMapGeoPoint locationWithLatitude:self.trip.arriveStation.latitude.doubleValue longitude:self.trip.arriveStation.longitude.doubleValue]];
    [self.naviRoute addToMapView:self.mapView];
    
    /* 缩放地图使其适应polylines的展示. */
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
                           animated:YES];
}

@end
