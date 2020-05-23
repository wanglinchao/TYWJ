//
//  TYWJTicketList.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/15.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJTicketList.h"
#import "ZLExtension.h"


@implementation TYWJTicketListInfo

@end

@implementation TYWJTicketListMonthInfo

@end

@implementation TYWJTicketList

- (TYWJTicketListInfo *)listInfo {
    if (_text && ![_text isEqualToString:@""]) {
        NSMutableArray *arr = (NSMutableArray *)[TYWJCommonTool decodeCommaStringWithString:_text];
        [arr removeObjectAtIndex:0];
        _listInfo = [TYWJTicketListInfo zl_objectWithArray:arr];
    }
    return _listInfo;
}

@end
