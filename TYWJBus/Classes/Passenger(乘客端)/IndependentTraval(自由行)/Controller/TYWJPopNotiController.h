//
//  TYWJPopNotiController.h
//  TYWJBus
//
//  Created by Harley He on 2018/7/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBasePopController.h"

@interface TYWJPopNotiController : TYWJBasePopController

/* viewClicked */
@property (copy, nonatomic) void(^viewClicked)(void);

@end
