//
//  TYWJPeirodTicket.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/2.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJPeirodTicket.h"
#import "ZLExtension.h"


@implementation TYWJPeriodTicketInfo


@end

@implementation TYWJPeriodDetailTicket


@end

@implementation TYWJPeriodTicket

- (TYWJPeriodTicketInfo *)ticketInfo {
    if (!_ticketInfo) {
        if (_text && ![_text isEqualToString:@""]) {
            NSMutableArray *arr = (NSMutableArray *)[TYWJCommonTool decodeCommaStringWithString:_text];
            [arr removeObjectAtIndex:0];
            _ticketInfo = [TYWJPeriodTicketInfo zl_objectWithArray:arr];
        }
    }
    return _ticketInfo;
}

- (TYWJPeriodDetailTicket *)detailTicket {
    if (!_detailTicket) {
        if (_text && ![_text isEqualToString:@""]) {
            NSMutableArray *arr = (NSMutableArray *)[TYWJCommonTool decodeCommaStringWithString:_text];
            [arr removeObjectAtIndex:0];
            _detailTicket = [TYWJPeriodDetailTicket zl_objectWithArray:arr];
        }
    }
    return _detailTicket;
}
@end
