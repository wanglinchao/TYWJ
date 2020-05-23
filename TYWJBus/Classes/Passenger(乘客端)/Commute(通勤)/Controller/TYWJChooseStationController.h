//
//  TYWJChooseStationController.h
//  TYWJBus
//
//  Created by Harllan He on 2018/5/29.
//  Copyright © 2018 Harllan He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface TYWJChooseStationController : UIViewController

/* 是否是上车地点 */
@property (assign, nonatomic) BOOL isGetupStation;
/* 是否进行默认定位搜索 */
@property (assign, nonatomic) BOOL isDefaultSearch;
/* 上车/下车地点 */
@property (copy, nonatomic) void(^stationPoi)(AMapPOI *poi);
/* defaultStation */
@property (copy, nonatomic) NSString *defaultStation;

@end
