//
//  TYWJLastSeats.m
//  TYWJBus
//
//  Created by MacBook on 2018/11/20.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJLastSeats.h"
#import "ZLExtension.h"



@implementation TYWJLastSeatsInfo

@end

@implementation TYWJLastSeats


- (TYWJLastSeatsInfo *)seatsInfo {
    if (self.text) {
        NSMutableArray *arr = (NSMutableArray *)[TYWJCommonTool decodeCommaStringWithString:_text];
        [arr removeObjectAtIndex:0];
        _seatsInfo = [TYWJLastSeatsInfo zl_objectWithArray:arr];
    }
    return _seatsInfo;
}

@end
