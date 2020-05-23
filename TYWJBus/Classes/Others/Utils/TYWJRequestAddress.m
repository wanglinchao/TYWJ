//
//  TYWJRequestAddress.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/24.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJRequestAddress.h"

static id _instance = nil;


@implementation TYWJRequestAddress
#pragma mark - 单例实现
+ (instancetype)stantardRequest {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[TYWJRequestAddress alloc] init];
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

#pragma mark -
- (NSString *)passengerLoginUrl {
    if (!_passengerLoginUrl) {
        _passengerLoginUrl = [NSString stringWithFormat:@"%@%@",TYWJRequestService,@"ck_user"];
    }
    return _passengerLoginUrl;
}

@end
