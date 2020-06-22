//
//  TYWJMeController.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBaseController.h"

@interface TYWJDriveMeController : TYWJBaseController

/* viewC点击 */
@property (copy, nonatomic) void(^viewClicked)(void);

@end
