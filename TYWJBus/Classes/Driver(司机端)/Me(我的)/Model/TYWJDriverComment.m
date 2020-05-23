//
//  TYWJDriverComment.m
//  TYWJBus
//
//  Created by MacBook on 2019/1/4.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import "TYWJDriverComment.h"
#import "ZLExtension.h"
@implementation TYWJDriverCommentInfo

- (CGFloat)rowH {
    if (_rowH <= 0) {
        _rowH = 40.f + [_content sizeWithMaxSize:CGSizeMake(ZLScreenWidth - 30.f, MAXFLOAT) font:15.f].height;
    }
    return _rowH;
}



@end

@implementation TYWJDriverComment


- (TYWJDriverCommentInfo *)commentInfo {
    if (!_commentInfo) {
        if (_text && ![_text isEqualToString:@""]) {
            NSMutableArray *arr = (NSMutableArray *)[TYWJCommonTool decodeCommaStringWithString:_text];
            [arr removeObjectAtIndex:0];
            _commentInfo = [TYWJDriverCommentInfo zl_objectWithArray:arr];
        }
    }
    return _commentInfo;
}


@end
