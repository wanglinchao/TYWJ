//
//  TYWJMyTicketsLayout.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/15.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJMyTicketsLayout.h"

@implementation TYWJMyTicketsLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {

    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *newAttArr = [NSMutableArray array];
    NSInteger count = arr.count;
    CGFloat x = 0,y = 0;
    CGFloat w = 0,h = 0;
    for (NSInteger i = 0; i < count; i++) {
        UICollectionViewLayoutAttributes *att = arr[i];
        w = att.frame.size.width;
        h = att.frame.size.height;
        x = w*att.indexPath.item;
        att.frame = CGRectMake(x, y, w, h);
        [newAttArr addObject:att];
    }
    return newAttArr;
}

@end
