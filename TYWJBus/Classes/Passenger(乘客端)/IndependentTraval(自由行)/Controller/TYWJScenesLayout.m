//
//  TYWJScenesLayout.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/25.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJScenesLayout.h"

@implementation TYWJScenesLayout

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
    CGFloat secH = 45.f;
    UICollectionViewLayoutAttributes *lastAtt = nil;
    for (NSInteger i = 0; i < count; i++) {
        UICollectionViewLayoutAttributes *att = arr[i];
        if (att.frame.size.width == ZLScreenWidth) {
            [newAttArr addObject:att];
            continue;
        }
        
        if (x + w + att.frame.size.width > rect.size.width) {
            row++;
            x = 10.f;
        }else {
            x += w + self.minimumInteritemSpacing;
            if (w == 0) {
                x = 10.f;
            }
        }
        if (att.indexPath.section > lastAtt.indexPath.section) {
            x = 10.f;
            
        }
        w = att.frame.size.width;
        h = att.frame.size.height;
        y = row*(self.minimumLineSpacing + h) + (att.indexPath.section + 1)*secH;
        att.frame = CGRectMake(x, y, w, h);
        [newAttArr addObject:att];
        lastAtt = [att copy];
    }
    return newAttArr;
}

@end
