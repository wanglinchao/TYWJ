//
//  TYWJApplyRouteController.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/25.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBaseController.h"

@class AMapPOI;


@interface TYWJApplyRouteController : TYWJBaseController

/* getupPoi */
@property (copy, nonatomic) AMapPOI *getupPoi;
/* getdownPoi */
@property (copy, nonatomic) AMapPOI *getdownPoi;

@end
