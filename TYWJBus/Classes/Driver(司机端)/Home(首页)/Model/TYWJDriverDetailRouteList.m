//
//  TYWJDriverDetailRouteList.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/31.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJDriverDetailRouteList.h"
#import "ZLExtension.h"

@interface TYWJDriverDetailRouteListInfo()


@end

@implementation TYWJDriverDetailRouteListInfo

- (id)copyWithZone:(NSZone *)zone {
    TYWJDriverDetailRouteListInfo *copy = [[[self class] allocWithZone:zone] init];
    [copy zl_setPropertiesWithObject:self];
    return copy;
}

@end

@implementation TYWJDriverDetailRouteList

- (TYWJDriverDetailRouteListInfo *)listInfo {
    if (!_listInfo) {
        if (_text && ![_text isEqualToString:@""]) {
            NSMutableArray *arr = (NSMutableArray *)[TYWJCommonTool decodeCommaStringWithString:_text];
            [arr removeObjectAtIndex:0];
            _listInfo = [TYWJDriverDetailRouteListInfo zl_objectWithArray:arr];
        }
    }
    return _listInfo;
}


@end
