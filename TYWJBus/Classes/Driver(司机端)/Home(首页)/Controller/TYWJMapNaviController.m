//
//  TYWJMapNaviController.m
//  TYWJBus
//
//  Created by Harley He on 2018/8/2.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJMapNaviController.h"
#import "GPSEmulator.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import "SpeechSynthesizer.h"

@interface TYWJMapNaviController ()<AMapNaviDriveManagerDelegate, AMapNaviDriveViewDelegate>

@property (nonatomic, strong) AMapNaviDriveView *driveView;
@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;
/* AMapNaviDriveManager *mgr */
@property (strong, nonatomic) AMapNaviDriveManager *naviMgr;
@property (nonatomic, strong) GPSEmulator *gpsEmulator;

@end

@implementation TYWJMapNaviController

- (AMapNaviDriveView *)driveView {
    if (!_driveView) {
        _driveView = [[AMapNaviDriveView alloc] initWithFrame:self.view.bounds];
        _driveView.zl_height -= kNavBarH;
        _driveView.zl_y = kNavBarH;
        _driveView.mapZoomLevel = 18;
        _driveView.delegate = self;
        _driveView.showMoreButton = NO;
    }
    return _driveView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    self.navigationItem.title = @"导航";
    
    //设置导航的起点和终点
    self.startPoint = [AMapNaviPoint locationWithLatitude:self.startCoord.latitude longitude:self.startCoord.longitude];
    self.endPoint   = [AMapNaviPoint locationWithLatitude:self.endCoord.latitude longitude:self.endCoord.longitude];
    
    //将AMapNaviManager与AMapNaviDriveView关联起来
    _naviMgr = [AMapNaviDriveManager sharedInstance];
    _naviMgr.delegate = self;
    [_naviMgr addDataRepresentative:self.driveView];
    
    [self.view addSubview:self.driveView];
    
}

- (void)dealloc {
    ZLFuncLog;
    [self.naviMgr stopNavi];
    [self.naviMgr removeDataRepresentative:self.driveView];
    [self.naviMgr setDelegate:nil];
    self.naviMgr = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //关闭屏幕常亮
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MBProgressHUD zl_showMessage:@"正在规划线路,请稍等" toView:self.view];
    //保持屏幕常亮
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    //路径规划
    [_naviMgr calculateDriveRouteWithStartPoints:@[self.startPoint]
                                                                    endPoints:@[self.endPoint]
                                                                    wayPoints:nil
                                                              drivingStrategy:AMapNaviDrivingStrategySingleDefault];
}

- (void)startGPSEmulator
{
    
    //设置采用外部传入定位信息
    self.gpsEmulator = [[GPSEmulator alloc] init];
    [self.naviMgr setEnableExternalLocation:YES];
    
    [self.naviMgr startGPSNavi];
    
    WeakSelf;
    [self.gpsEmulator startEmulatorUsingLocationBlock:^(CLLocation *location, NSUInteger index, NSDate *addedTime, BOOL *stop) {
        
        //注意：需要使用当前时间作为时间戳
        CLLocation *newLocation = [[CLLocation alloc] initWithCoordinate:location.coordinate
                                                                altitude:location.altitude
                                                      horizontalAccuracy:location.horizontalAccuracy
                                                        verticalAccuracy:location.verticalAccuracy
                                                                  course:location.course
                                                                   speed:location.speed
                                                               timestamp:[NSDate dateWithTimeIntervalSinceNow:0]];
        
        //外部传入定位信息(enableExternalLocation为YES时有效)
        [weakSelf.naviMgr setExternalLocation:newLocation isAMapCoordinate:NO];
        
    }];
}
#pragma mark - 代理
/**
 * @brief 导航界面关闭按钮点击时的回调函数
 * @param driveView 驾车导航界面
 */
- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView {
    ZLFuncLog;
    [self backToPreView];
}
//路径规划成功后，开始模拟导航
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    [MBProgressHUD zl_hideHUDForView:self.view];
    [self startGPSEmulator];
}

/**
 * @brief 模拟导航到达目的地停止导航后的回调函数
 * @param driveManager 驾车导航管理类
 */
- (void)driveManagerDidEndEmulatorNavi:(AMapNaviDriveManager *)driveManager {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * @brief 导航到达目的地后的回调函数
 * @param driveManager 驾车导航管理类
 */
- (void)driveManagerOnArrivedDestination:(AMapNaviDriveManager *)driveManager {
    [self backToPreView];
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    ZLLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}

- (BOOL)driveManagerIsNaviSoundPlaying:(AMapNaviDriveManager *)driveManager
{
    return [[SpeechSynthesizer sharedSpeechSynthesizer] isSpeaking];
}
#pragma mark - 返回上个界面

- (void)backToPreView {
    //停止导航
    [self.naviMgr stopNavi];
    [self.naviMgr removeDataRepresentative:self.driveView];
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
