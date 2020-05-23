//
//  TYWJTripsModel.m
//  TYWJBus
//
//  Created by MacBook on 2018/12/12.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJTripsModel.h"
#import <MJExtension.h>

@implementation TYWJTripsLine

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end

@implementation TYWJTripsArriveStation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

- (NSString *)longitude {
    if (!_longitude) {
        NSArray *ll = [_lngLat componentsSeparatedByString:@","];
        if (ll.count) {
            _longitude = ll.firstObject;
        }
    }
    return _longitude;
}

- (NSString *)latitude {
    if (!_latitude) {
        NSArray *ll = [_lngLat componentsSeparatedByString:@","];
        if (ll.count) {
            _latitude = ll.lastObject;
        }
    }
    return _latitude;
}

@end

@implementation TYWJTripsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

- (NSString *)instructorName {
    if ([_instructorName containsString:@"讲解"]) {
        _instructorName = [_instructorName stringByReplacingOccurrencesOfString:@"讲解" withString:@""];
    }
    return _instructorName;
}

- (NSString *)backupStations {
    if (!_backupStations) {
        _backupStations = @"无";
    }
    return _backupStations;
}

@end
