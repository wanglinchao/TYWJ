//
//  TYWJDriverSelectCarController.h
//  TYWJBus
//
//  Created by MacBook on 2018/12/14.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJBasePopController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYWJDriverSelectCarController : TYWJBasePopController

/* viewClicked */
@property (copy, nonatomic) void(^cellSeleted)(NSString *cl);
/* viewClicked */
@property (copy, nonatomic) void(^viewClicked)(void);
/* carLicneses */
@property (strong, nonatomic) NSArray *carLicenses;


@end

NS_ASSUME_NONNULL_END
