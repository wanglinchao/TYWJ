//
//  TYWJUsableCitiesController.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/28.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBaseController.h"

@interface TYWJUsableCitiesController : TYWJBaseController

/* cellSelected */
@property (copy, nonatomic) void(^cellSelected)(NSString *city);
/* 城市列表 */
@property (strong, nonatomic) NSArray *cityList;
@end
