//
//  TYWJSingleLocation.m
//  TYWJBus
//
//  Created by Harllan He on 2018/5/31.
//  Copyright © 2018 Harllan He. All rights reserved.
//

#import "TYWJSingleLocation.h"


@interface TYWJSingleLocation()<AMapLocationManagerDelegate>

/* locationMgr */
@property (strong, nonatomic) AMapLocationManager *locationMgr;
/* locationMgr */
@property (strong, nonatomic) AMapLocationManager *updatingLocationMgr;
/* 持续定位中上次定位点 */
@property (strong, nonatomic) CLLocation *lastUpdatingLocation;

@end

static id _instance = nil;

@implementation TYWJSingleLocation

#pragma mark - 单例实现
+ (instancetype)stantardLocation {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[TYWJSingleLocation alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

#pragma mark - 内部方法

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)startLocating {
    [self checkLocationServiceEnable];
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationMgr requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            ZLLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                self.locationStatus = NO;
                return;
            }
        }
        
        ZLLog(@"location:%@", location);
        
        if (regeocode)
        {
            self.locationStatus = YES;
            ZLLog(@"reGeocode:%@", regeocode);
            self.reGeocode = regeocode;
            self.location = location;
            
            if (self.locationDataDidChange) {
                self.locationDataDidChange(regeocode,location);
            }
        }
    }];
}

#pragma mark - 外部方法

/**
 开始快速点位，这种方式很快，但是获取的信息少，还有可能定位不是很准
 */
- (void)startBasicLocation {
    [self checkLocationServiceEnable];
    self.locationMgr = nil;
    self.locationMgr = [[AMapLocationManager alloc] init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationMgr setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationMgr.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationMgr.reGeocodeTimeout = 2;
    
    [self startLocating];
}

/**
 开始精准定位，这种方式获取的信息多，但是定位慢，不过定位很准
 */
- (void)startAccuracyBestLocation {
    [self checkLocationServiceEnable];
    self.locationMgr = nil;
    self.locationMgr = [[AMapLocationManager alloc] init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationMgr setDesiredAccuracy:kCLLocationAccuracyBest];
    //   定位超时时间，最低2s，此处设置为10s
    self.locationMgr.locationTimeout =10;
    //   逆地理请求超时时间，最低2s，此处设置为10s
    self.locationMgr.reGeocodeTimeout = 10;
    
    [self startLocating];
}

/**
 重新定位
 */
- (void)reLocate {
    [self startLocating];
}

- (void)startUpdatingLocation {
    [self startUpdatingLocationWithDelegate:self];
}

- (void)startUpdatingLocationWithDelegate:(id)dlg {
    [self checkLocationServiceEnable];
    self.updatingLocationMgr = nil;
    self.updatingLocationMgr = [[AMapLocationManager alloc] init];
    self.updatingLocationMgr.delegate = dlg;
    //多少米更新定位一次
    self.updatingLocationMgr.desiredAccuracy = kCLLocationAccuracyBest;
    //此时应用程序设置中选择“使用应用程序期间”的时候就会出现蓝条，选择“始终”的时候蓝条就不会出现
    self.updatingLocationMgr.allowsBackgroundLocationUpdates = YES;
    self.updatingLocationMgr.distanceFilter = 15.0;
    self.updatingLocationMgr.pausesLocationUpdatesAutomatically = YES;
    
    [self.updatingLocationMgr setLocatingWithReGeocode:YES];
    //定位可用
    [self.updatingLocationMgr startUpdatingLocation];
}

- (void)stopUpdatingLocation {
    self.lastUpdatingLocation = nil;
    [self.updatingLocationMgr stopUpdatingLocation];
}

- (void)checkLocationServiceEnable {
    if ([CLLocationManager locationServicesEnabled]) {
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusNotDetermined:
                ZLLog(@"用户尚未进行选择");
                break;
            case kCLAuthorizationStatusRestricted:
                ZLLog(@"定位权限被限制");
                [MBProgressHUD zl_showAlert:@"请打开定位允许" afterDelay:2.5f];
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                ZLLog(@"用户允许定位");
                break;
            case kCLAuthorizationStatusDenied:
                ZLLog(@"用户不允许定位");
                [MBProgressHUD zl_showAlert:@"请打开定位允许" afterDelay:2.5f];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark -

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
//    [MBProgressHUD zl_showSuccess:[NSString stringWithFormat:@"location:{lat:%f; lon:%f; accuracy:%f}",location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy]];
    ZLLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (reGeocode)
    {
        ZLLog(@"reGeocode:%@", reGeocode);
    }
    
    if ([[TYWJCommonTool sharedTool] checkPlaceIsAssignedPlaceWithCoord:location.coordinate coord2:self.lastUpdatingLocation.coordinate meters:10]) {
        self.lastUpdatingLocation = location;
        return;
    }
    if (self.updatingLocationCallback) {
        self.updatingLocationCallback(location, reGeocode);
        self.lastUpdatingLocation = location;
    }
}
@end
