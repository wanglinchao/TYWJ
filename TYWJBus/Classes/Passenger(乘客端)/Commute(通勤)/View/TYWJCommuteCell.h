//
//  TYWJCommuteCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/29.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJRouteListInfo;

UIKIT_EXTERN CGFloat const TYWJCommuteCellH;
UIKIT_EXTERN NSString * const TYWJCommuteCellID;

@interface TYWJCommuteCell : UITableViewCell

/* routeListInfo */
@property (strong, nonatomic) TYWJRouteListInfo *routeListInfo;
/* buyClicked */
@property (copy, nonatomic) void(^buyClicked)(TYWJRouteListInfo *routeListInfo);


@end
