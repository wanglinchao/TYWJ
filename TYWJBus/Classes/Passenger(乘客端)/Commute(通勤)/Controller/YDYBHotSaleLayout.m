//
//  YDYBHotSaleLayout.m
//  YunDuoYouBao
//
//  Created by GY on 2017/11/17.
//  Copyright © 2017年 YDYB. All rights reserved.
//

#import "YDYBHotSaleLayout.h"

@implementation YDYBHotSaleLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    self.minimumLineSpacing = 8.f;
    self.minimumInteritemSpacing = 5.f;
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}


- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *newAttArr = [NSMutableArray array];
    NSInteger count = arr.count;
    int row = 0;
    CGFloat x = 0,y = 0;
    CGFloat w = 0,h = 0;
    for (NSInteger i = 0; i < count; i++) {
        UICollectionViewLayoutAttributes *att = arr[i];
        if (x + w + att.frame.size.width > rect.size.width) {
            row++;
            x = 0;
        }else {
            x += w + self.minimumInteritemSpacing;
            if (w == 0) {
                x = 0;
            }
        }
        w = att.frame.size.width;
        h = att.frame.size.height;
        y = row*(self.minimumLineSpacing + h);
        att.frame = CGRectMake(x, y, w, h);
        [newAttArr addObject:att];
    }
    return newAttArr;
}
@end
