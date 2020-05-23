//
//  TYWJHelpModel.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/19.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJHelpModel.h"


@implementation TYWJHelpModel

- (NSString *)answer {
    if (!_answer && _text) {
        NSRange range1 = [_text rangeOfString:@","];
        _text = [_text substringFromIndex:range1.location + 1];
        NSRange range2 = [_text rangeOfString:@","];
        _answer = [_text substringFromIndex:range2.location + 1];
        _answer = [NSString stringWithFormat:@"答:%@",_answer];
    }
    return _answer;
}

- (CGFloat)cellH {
    if (_cellH == 0) {
        CGFloat h = [self.answer sizeWithMaxSize:CGSizeMake(ZLScreenWidth - 20.f, MAXFLOAT) font:12.f].height;
        _cellH = h + 56.f;
    }
    return _cellH;
}
@end
