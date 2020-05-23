//
//  TYWJSearchPOICell.h
//  TYWJBus
//
//  Created by Harllan He on 2018/5/31.
//  Copyright © 2018 Harllan He. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AMapPOI;

UIKIT_EXTERN NSString * const TYWJSearchPOICellID;

@interface TYWJSearchPOICell : UITableViewCell

/* poi */
@property (strong, nonatomic) AMapPOI *poi;

@end
