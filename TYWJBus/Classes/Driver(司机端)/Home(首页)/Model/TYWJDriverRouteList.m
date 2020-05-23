//
//  TYWJDriverRouteList.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/31.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJDriverRouteList.h"
#import "ZLExtension.h"

@interface TYWJDriverRouteListInfo()

@end

@implementation TYWJDriverRouteListInfo

- (id)copyWithZone:(NSZone *)zone {
    TYWJDriverRouteListInfo *copy = [[[self class] allocWithZone:zone] init];
    [copy zl_setPropertiesWithObject:self];
    return copy;
}


@end

@implementation TYWJDriverRouteList

- (TYWJDriverRouteListInfo *)listInfo {
    if (!_listInfo) {
        if (_text && ![_text isEqualToString:@""]) {
            NSMutableArray *arr = (NSMutableArray *)[TYWJCommonTool decodeCommaStringWithString:_text];
            [arr removeObjectAtIndex:0];
            _listInfo = [TYWJDriverRouteListInfo zl_objectWithArray:arr];
        }
    }
    return _listInfo;
}

@end
