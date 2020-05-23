//
//  TYWJBoughtTicket.m
//  TYWJBus
//
//  Created by MacBook on 2018/11/27.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJBoughtTicket.h"
#import "ZLExtension.h"

@implementation TYWJBoughtTicketInfo

@end

@implementation TYWJBoughtTicket

- (TYWJBoughtTicketInfo *)info {
    if (self.text) {
        NSMutableArray *arr = (NSMutableArray *)[TYWJCommonTool decodeCommaStringWithString:_text];
        [arr removeObjectAtIndex:0];
        _info = [TYWJBoughtTicketInfo zl_objectWithArray:arr];
        _info.bought = @"1";
    }
    return _info;
}

@end
