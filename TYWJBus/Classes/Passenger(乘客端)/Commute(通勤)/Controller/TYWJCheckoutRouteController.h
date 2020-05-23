//
//  TYWJCheckoutRouteController.h
//  TYWJBus
//
//  Created by Harllan He on 2018/5/30.
//  Copyright © 2018 Harllan He. All rights reserved.
//

#import "TYWJBaseController.h"


@class AMapPOI;


@interface TYWJCheckoutRouteController : TYWJBaseController

/* getupPoi */
@property (strong, nonatomic) AMapPOI *getupPoi;
/* getdownPoi */
@property (strong, nonatomic) AMapPOI *getdownPoi;

@end
