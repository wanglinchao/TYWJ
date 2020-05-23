//
//  TYWJDetailStationCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/6.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJSubRouteListInfo;


UIKIT_EXTERN NSString * const TYWJDetailStationCellID;

@interface TYWJDetailStationCell : UITableViewCell

/* 是否隐藏上面的虚线 */
@property (assign, nonatomic) BOOL isHideTopDashLine;
/* 是否隐藏下面的虚线 */
@property (assign, nonatomic) BOOL isHideBottomDashLine;
/* 是否有实心 */
@property (assign, nonatomic) BOOL isRealHeart;
/* 是否是起始站 */
@property (assign, nonatomic) BOOL isStartStation;

/* time */
@property (copy, nonatomic) NSString *time;
/* station */
@property (copy, nonatomic) NSString *station;

/* 是否有上面的虚线 */
@property (assign, nonatomic) BOOL hasUpDash;
/* 是否有下面的虚线 */
@property (assign, nonatomic) BOOL hasDownDash;

/* listInfo */
@property (strong, nonatomic) TYWJSubRouteListInfo *listInfo;

@end
