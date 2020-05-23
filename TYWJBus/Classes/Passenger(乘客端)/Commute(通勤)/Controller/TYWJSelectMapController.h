//
//  TYWJSelectMapController.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/21.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBasePopController.h"

@interface TYWJSelectMapController : TYWJBasePopController

/* viewClicked */
@property (copy, nonatomic) void(^viewClicked)(void);

/* 经纬度 */
@property (assign, nonatomic) CGPoint location;

@end
