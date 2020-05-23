//
//  TYWJJsonRequestUrls.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/26.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJJsonRequestUrls.h"

static TYWJJsonRequestUrls *_instance = nil;

@interface TYWJJsonRequestUrls()<NSCopying>



@end

@implementation TYWJJsonRequestUrls
#pragma mark - 单例
+ (instancetype)sharedRequest {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[TYWJJsonRequestUrls alloc] init];
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

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}
#pragma mark - urls

- (NSString *)detailRoute {
    if (!_detailRoute) {
        ///line/listPage
        _detailRoute = [TYWJRequestJsonService stringByAppendingString:@"/line/getStation"];
    }
    return _detailRoute;
}

- (NSString *)purchaseSingleTicket {
    if (!_purchaseSingleTicket) {
        _purchaseSingleTicket = [TYWJRequestJsonService stringByAppendingString:@"/order/chepiaoinsert"];
    }
    return _purchaseSingleTicket;
}

- (NSString *)purchaseMonthTicket {
    if (!_purchaseMonthTicket) {
        _purchaseMonthTicket = [TYWJRequestJsonService stringByAppendingString:@"/order/addMonthTicket"];
    }
    return _purchaseMonthTicket;
}

- (NSString *)quitTicket {
    if (!_quitTicket) {
        _quitTicket = [TYWJRequestJsonService stringByAppendingString:@"/order/cancelOrder"];
    }
    return _quitTicket;
}

- (NSString *)toPay {
    if (!_toPay) {
        _toPay = [TYWJRequestJsonService stringByAppendingString:@"/order/toPay"];
    }
    return _toPay;
}

- (NSString *)monthTicketToPay {
    if (!_monthTicketToPay) {
        _monthTicketToPay = [TYWJRequestJsonService stringByAppendingString:@"/order/addMonthTicket"];
    }
    return _monthTicketToPay;
}

- (NSString *)periodTicketToPay {
    if (!_periodTicketToPay) {
        _periodTicketToPay = [TYWJRequestJsonService stringByAppendingString:@"/order/addCycleOrder"];
    }
    return _periodTicketToPay;
}

- (NSString *)isCheckingApp {
    if (!_isCheckingApp) {
        ///status/get
        _isCheckingApp = [TYWJRequestJsonService stringByAppendingString:@"/status/get"];
    }
    return _isCheckingApp;
}

- (NSString *)cancelOrder {
    if (!_cancelOrder) {
        _cancelOrder = [TYWJRequestJsonService stringByAppendingString:@"/order/cancelNopayOrder"];
    }
    return _cancelOrder;
}

- (NSString *)lastSeats {
    if (!_lastSeats) {
        _lastSeats = [TYWJRequestJsonService stringByAppendingString:@"/calender/list"];
    }
    return _lastSeats;
}

- (NSString *)monthTicket {
    if (!_monthTicket) {
        ///order/getMyMonthTicket
        _monthTicket = [TYWJRequestJsonService stringByAppendingString:@"/order/getMyMonthTicket"];
    }
    return _monthTicket;
}

- (NSString *)bannerImageInfo{
    if (!_bannerImageInfo) {
        //bonus
        _bannerImageInfo = [TYWJRequestJsonService stringByAppendingString:@"/banner/getBannerByType?type=2"];
    }
    return _bannerImageInfo;
}
- (NSString *)ADsImageInfo{
    if (!_ADsImageInfo) {
        //bonus
        _ADsImageInfo = [TYWJRequestJsonService stringByAppendingString:@"/banner/getBannerByType?type=1"];
    }
    return _ADsImageInfo;
}

#pragma mark - 司机打卡相关

- (NSString *)signUpLogin {
    if (!_signUpLogin) {
        _signUpLogin = [TYWJRequestSingUpService stringByAppendingString:@"/login"];
    }
    return _signUpLogin;
}

- (NSString *)trips {
    if (!_trips) {
        _trips = [TYWJRequestSingUpService stringByAppendingString:@"/todayTrips"];//todayTrips
    }
    return _trips;
}

- (NSString *)logMileage {
    if (!_logMileage) {//logMileage
        _logMileage = [TYWJRequestSingUpService stringByAppendingString:@"/logMileage"];
    }
    return _logMileage;
}

- (NSString *)carNumbers {
    if (!_carNumbers) {
        _carNumbers = [TYWJRequestSingUpService stringByAppendingString:@"/carNumbers"];
    }
    return _carNumbers;
}

- (NSString *)userTrips {
    if (!_userTrips) {
        _userTrips = [TYWJRequestSingUpService stringByAppendingString:@"/userTrips"];
    }
    return _userTrips;
}

- (NSString *)password {
    if (!_password) {
        _password = [TYWJRequestSingUpService stringByAppendingString:@"/password"];
    }
    return _password;
}

- (NSString *)driverClockIn {
    if (!_driverClockIn) {
        //sign
        _driverClockIn = [TYWJRequestSingUpService stringByAppendingString:@"/sign"];
    }
    return _driverClockIn;
}

- (NSString *)bonus {
    if (!_bonus) {
        //bonus
        _bonus = [TYWJRequestSingUpService stringByAppendingString:@"/bonus"];
    }
    return _bonus;
}

- (NSString *)uploadDriverGps {
    if (!_uploadDriverGps) {
        //bonus
        _uploadDriverGps = [TYWJRequestSingUpService stringByAppendingString:@"/uploadDriverGps"];
    }
    return _uploadDriverGps;
}

- (NSString *)batchUploadDriverGps {
    if (!_batchUploadDriverGps) {
        //bonus
        _batchUploadDriverGps = [TYWJRequestSingUpService stringByAppendingString:@"/batchUploadDriverGps"];
    }
    return _batchUploadDriverGps;
}



@end
