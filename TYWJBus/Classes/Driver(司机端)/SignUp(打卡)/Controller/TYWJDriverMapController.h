//
//  TYWJDriverMapController.h
//  TYWJBus
//
//  Created by MacBook on 2018/12/12.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJTripsModel;

NS_ASSUME_NONNULL_BEGIN

@interface TYWJDriverMapController : UIViewController

/* trips */
@property (strong, nonatomic) TYWJTripsModel *trip;
/* 是否是查看班次 */
@property (assign, nonatomic) BOOL isCheckRoute;

@end

NS_ASSUME_NONNULL_END
