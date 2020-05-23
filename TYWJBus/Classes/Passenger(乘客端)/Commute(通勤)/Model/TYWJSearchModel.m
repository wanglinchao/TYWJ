//
//  TYWJSearchModel.m
//  TYWJBus
//
//  Created by Harllan He on 2018/5/31.
//  Copyright © 2018 Harllan He. All rights reserved.
//

#import "TYWJSearchModel.h"

CGFloat const TYWJSearchLabelFont = 13.0f;

@implementation TYWJSearchModel

- (CGFloat)itemW {
    CGFloat w = [self.title sizeWithMaxSize:CGSizeMake(MAXFLOAT, 0) font:TYWJSearchLabelFont].width + 25.0f;
    return w;
}

@end
