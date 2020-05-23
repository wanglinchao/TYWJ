//
//  TYWJCarLocation.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/3.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJCarLocation.h"
#import "ZLExtension.h"

@implementation TYWJCarLocationInfo

@end

@implementation TYWJCarLocation

- (TYWJCarLocationInfo *)info {
    if (!_info) {
        if (_text && ![_text isEqualToString:@""] && ![_text isEqualToString:@""]) {
            NSMutableArray *arr = (NSMutableArray *)[TYWJCommonTool decodeCommaStringWithString:_text];
            [arr removeObjectAtIndex:0];
            _info = [TYWJCarLocationInfo zl_objectWithArray:arr];
        }
    }
    return _info;
}

@end
