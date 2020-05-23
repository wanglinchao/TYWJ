//
//  TYWJSubRouteList.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/7.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJSubRouteList.h"
#import "ZLExtension.h"


@implementation TYWJSubRouteListInfo


@end

@implementation TYWJSubRouteList

- (TYWJSubRouteListInfo *)routeListInfo {
    if (!_routeListInfo) {
        if (_text && ![_text isEqualToString:@""]) {
            NSMutableArray *arr = (NSMutableArray *)[TYWJCommonTool decodeCommaStringWithString:_text];
            [arr removeObjectAtIndex:0];
            _routeListInfo = [TYWJSubRouteListInfo zl_objectWithArray:arr];
        }
    }
    return _routeListInfo;
}

- (NSString *)station {
    if (!_station) {
        _station = self.routeListInfo.station;
    }
    return _station;
}

@end
