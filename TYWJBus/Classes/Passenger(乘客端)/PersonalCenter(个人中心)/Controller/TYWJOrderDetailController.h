//
//  TYWJOrderDetailController.h
//  TYWJBus
//
//  Created by tywj on 2020/6/5.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJBaseController.h"
#import "TYWJOrderList.h"
NS_ASSUME_NONNULL_BEGIN

@interface TYWJOrderDetailController : TYWJBaseController
@property (strong, nonatomic) TYWJOrderList *model;
@end

NS_ASSUME_NONNULL_END
