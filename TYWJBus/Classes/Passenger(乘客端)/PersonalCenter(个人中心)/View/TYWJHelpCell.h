//
//  TYWJHelpCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/19.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TYWJHelpModel;

UIKIT_EXTERN NSString * const TYWJHelpCellID;

@interface TYWJHelpCell : UITableViewCell

/* model */
@property (strong, nonatomic) TYWJHelpModel *model;

@end
