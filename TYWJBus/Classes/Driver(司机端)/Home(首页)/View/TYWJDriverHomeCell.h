//
//  TYWJDriverHomeCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/7/30.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJDriverRouteListInfo;

UIKIT_EXTERN NSString * const TYWJDriverHomeCellID;

@interface TYWJDriverHomeCell : UITableViewCell

/* TYWJDriverRouteList */
@property (copy, nonatomic) TYWJDriverRouteListInfo *listInfo;
/* 司机发车按钮点击 */
@property (copy, nonatomic) void(^launchBtnClicked)(void);

@end
