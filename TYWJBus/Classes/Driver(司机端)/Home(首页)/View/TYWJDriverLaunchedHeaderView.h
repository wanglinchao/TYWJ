//
//  TYWJDriverLaunchedHeaderView.h
//  TYWJBus
//
//  Created by Harley He on 2018/8/2.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJSubRouteListInfo;

@interface TYWJDriverLaunchedHeaderView : UIView

/* TYWJSubRouteListInfo */
@property (strong, nonatomic) TYWJSubRouteListInfo *listInfo;
/* 是否是最后一站 */
@property (assign, nonatomic) BOOL isTheLastStation;

/* 上一站点击 */
@property (copy, nonatomic) void(^lastStationClicked)(void);
/* 下一站点击 */
@property (copy, nonatomic) void(^nextStationClicked)(void);

@end
