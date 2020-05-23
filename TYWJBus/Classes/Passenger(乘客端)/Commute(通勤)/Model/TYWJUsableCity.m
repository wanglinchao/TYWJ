//
//  TYWJUsableCity.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/28.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJUsableCity.h"
#import "ZLExtension.h"


@implementation TYWJUsableCityInfo

@end

@implementation TYWJUsableCity

- (TYWJUsableCityInfo *)cityInfo {
    if (self.text) {
        NSMutableArray *arr = (NSMutableArray *)[TYWJCommonTool decodeCommaStringWithString:_text];
        [arr removeObjectAtIndex:0];
        _cityInfo = [TYWJUsableCityInfo zl_objectWithArray:arr];
    }
    return _cityInfo;
}

@end
