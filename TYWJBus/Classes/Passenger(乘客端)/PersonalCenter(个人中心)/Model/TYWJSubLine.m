//
//  TYWJSubLine.m
//  TYWJBus
//
//  Created by tywj on 2020/3/14.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJSubLine.h"
#import "ZLExtension.h"

@implementation TYWJLineInfo


@end

@implementation TYWJSubLine


- (TYWJLineInfo *)lineInfo
{
    if (!_lineInfo) {
        if (_text && ![_text isEqualToString:@""]) {
            NSMutableArray *arr = (NSMutableArray *)[TYWJCommonTool decodeCommaStringWithString:_text];
            [arr removeObjectAtIndex:0];
            _lineInfo = [TYWJLineInfo zl_objectWithArray:arr];
        }
    }
    return _lineInfo;
}

@end
