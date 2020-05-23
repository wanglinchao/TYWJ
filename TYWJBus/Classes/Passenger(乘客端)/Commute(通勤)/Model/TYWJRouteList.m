//
//  TYWJRouteList.m
//  TYWJBus
//
//  Created by Harllan He on 2018/6/1.
//  Copyright © 2018 Harllan He. All rights reserved.
//

#import "TYWJRouteList.h"
#import "ZLExtension.h"

@interface TYWJRouteListInfo()<NSCopying>


@end

@implementation TYWJRouteListInfo

- (id)copyWithZone:(NSZone *)zone {
    TYWJRouteListInfo *copy = [[[self class] allocWithZone:zone] init];
    [copy zl_setPropertiesWithObject:self];
    return copy;
}

@end


@implementation TYWJRouteList

- (TYWJRouteListInfo *)routeListInfo {
    if (!_routeListInfo) {
        if (_text && ![_text isEqualToString:@""]) {
            NSMutableArray *arr = (NSMutableArray *)[TYWJCommonTool decodeCommaStringWithString:_text];
            [arr removeObjectAtIndex:0];
            _routeListInfo = [TYWJRouteListInfo zl_objectWithArray:arr];
        }
    }
    return _routeListInfo;
}

@end
