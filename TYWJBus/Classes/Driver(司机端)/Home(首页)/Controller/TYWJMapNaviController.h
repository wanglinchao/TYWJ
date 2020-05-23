//
//  TYWJMapNaviController.h
//  TYWJBus
//
//  Created by Harley He on 2018/8/2.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface TYWJMapNaviController : UIViewController

@property (nonatomic, assign) CLLocationCoordinate2D startCoord;
@property (nonatomic, assign) CLLocationCoordinate2D endCoord;

@end
