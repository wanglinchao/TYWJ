//
//  TYWJActivityCenter.m
//  TYWJBus
//
//  Created by MacBook on 2018/8/29.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJActivityCenter.h"
#import "ZLExtension.h"

@implementation TYWJActivityCenterInfo



@end


@implementation TYWJActivityCenter


- (TYWJActivityCenterInfo *)info {
    if (_text && ![_text isEqualToString:@""]) {
        NSMutableArray *arr = (NSMutableArray *)[TYWJCommonTool decodeCommaStringWithString:_text];
        [arr removeObjectAtIndex:0];
        _info = [TYWJActivityCenterInfo zl_objectWithArray:arr];
    }
    return _info;
}

@end
