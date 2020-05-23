//
//  TYWJITFlowLayout.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/20.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJITFlowLayout.h"

@implementation TYWJITFlowLayout

//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
//    return YES;
//}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *newAttArr = [NSMutableArray array];
    NSInteger count = arr.count;
    CGFloat x = 0,y = 0;
    CGFloat w = 0,h = 0;
    for (NSInteger i = 0; i < count; i++) {
        UICollectionViewLayoutAttributes *att = arr[i];
        if (att.frame.origin.y == 0) {
            [newAttArr addObject:att];
            continue;
        }
        
        w = att.frame.size.width - 15.f;
        h = att.frame.size.height;
        y = att.frame.origin.y;
        if (att.frame.origin.x == 0) {
            x = 10.f;
        }else {
            x = w + 20.f;
        }
        att.frame = CGRectMake(x, y, w, h);
        [newAttArr addObject:att];
    }
    return newAttArr;
}

@end
