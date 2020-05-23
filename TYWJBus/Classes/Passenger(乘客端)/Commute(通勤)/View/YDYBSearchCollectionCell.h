//
//  YDYBSearchCollectionCell.h
//  YunDuoYouBao
//
//  Created by GY on 2017/11/27.
//  Copyright © 2017年 GY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJSearchModel;

UIKIT_EXTERN NSString * const YDYBSearchCollectionCellID;

@interface YDYBSearchCollectionCell : UICollectionViewCell

/* model */
@property (strong, nonatomic) TYWJSearchModel *model;
/* text */
@property (copy, nonatomic) NSString *text;

@end
