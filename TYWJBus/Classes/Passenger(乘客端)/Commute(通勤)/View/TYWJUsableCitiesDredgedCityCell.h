//
//  TYWJUsableCitiesDredgedCityCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/28.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJUsableCity;

UIKIT_EXTERN NSString * const TYWJUsableCitiesDredgedCityCellID;

@interface TYWJUsableCitiesDredgedCityCell : UITableViewCell

/* 城市 */
@property (strong, nonatomic) TYWJUsableCity *city;

@end
