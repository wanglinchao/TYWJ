//
//  TYWJPopSelectTimeController.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/16.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBasePopController.h"

@interface TYWJPopSelectTimeController : TYWJBasePopController

/* viewClicked */
@property (copy, nonatomic) void(^viewClicked)(void);
/* confirmClicked */
@property (copy, nonatomic) void(^confirmClicked)(NSString *time);
/* 默认选择时间 */
@property (assign, nonatomic) NSInteger defaultTime;
@end
