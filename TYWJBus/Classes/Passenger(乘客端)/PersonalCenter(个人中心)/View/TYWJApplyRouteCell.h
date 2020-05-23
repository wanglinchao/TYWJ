//
//  TYWJApplyRouteCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/15.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJApplyRoute;

UIKIT_EXTERN NSString * const TYWJApplyRouteCellID;

@interface TYWJApplyRouteCell : UITableViewCell

/* TYWJApplyRoute */
@property (strong, nonatomic) TYWJApplyRoute *route;

@end
