//
//  TYWJApplyList.m
//  TYWJBus
//
//  Created by tywj on 2020/3/12.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJApplyList.h"
#import "ZLExtension.h"

@interface TYWJApplyListInfo()<NSCopying>


@end

@implementation TYWJApplyListInfo

- (id)copyWithZone:(NSZone *)zone {
    TYWJApplyListInfo *copy = [[[self class] allocWithZone:zone] init];
    [copy zl_setPropertiesWithObject:self];
    return copy;
}

@end


@implementation TYWJApplyList
-(TYWJApplyListInfo *)applyListInfo
{
    if (!_applyListInfo) {
        if (_text && ![_text isEqualToString:@""]) {
            NSMutableArray *arr = (NSMutableArray *)[TYWJCommonTool decodeCommaStringWithString:_text];
            [arr removeObjectAtIndex:0];
            _applyListInfo = [TYWJApplyListInfo zl_objectWithArray:arr];
        }
    }
    return _applyListInfo;
}

@end
