//
//  TYWJChangeAvatarController.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/11.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBaseController.h"
#import "HXPhotoPicker.h"

@interface TYWJChangeAvatarController : TYWJBaseController

/* viewClicked */
@property (copy, nonatomic) void(^viewClicked)(void);
@end
