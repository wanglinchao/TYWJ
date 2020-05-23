//
//  TYWJPeopleNum.m
//  TYWJBus
//
//  Created by Harley He on 2018/8/2.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJPeopleNum.h"
#import "ZLExtension.h"


@implementation TYWJPeopleNumInfo

- (id)copyWithZone:(NSZone *)zone {
    TYWJPeopleNumInfo *copy = [[[self class] allocWithZone:zone] init];
    [copy zl_setPropertiesWithObject:self];
    return copy;
}

@end

@implementation TYWJPeopleNum

- (TYWJPeopleNumInfo *)numInfo {
    if (!_numInfo) {
        if (_text && ![_text isEqualToString:@""]) {
            NSMutableArray *arr = (NSMutableArray *)[TYWJCommonTool decodeCommaStringWithString:_text];
            [arr removeObjectAtIndex:0];
            _numInfo = [TYWJPeopleNumInfo zl_objectWithArray:arr];
        }
    }
    return _numInfo;
}

@end
