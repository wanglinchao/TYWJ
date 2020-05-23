//
//  TYWJSingleLocation.h
//  TYWJBus
//
//  Created by Harllan He on 2018/5/31.
//  Copyright © 2018 Harllan He. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface TYWJSingleLocation : NSObject


+ (instancetype)stantardLocation;
- (void)startBasicLocation;
- (void)startAccuracyBestLocation;
- (void)reLocate;
//持续定位
- (void)startUpdatingLocationWithDelegate:(id)dlg;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;
/* 持续定位回调 */
@property (copy, nonatomic) void(^updatingLocationCallback)(CLLocation *location,AMapLocationReGeocode *reGeocode);

/* AMapLocationReGeocode */
@property (strong, nonatomic) AMapLocationReGeocode *reGeocode;
/* location */
@property (strong, nonatomic) CLLocation *location;
/* 定位发生变化 */
@property (copy, nonatomic) void(^locationDataDidChange)(AMapLocationReGeocode *reGeocode,CLLocation *location);
/* 定位成功与否 */
@property (assign, nonatomic) BOOL locationStatus;

- (void)checkLocationServiceEnable;

@end
