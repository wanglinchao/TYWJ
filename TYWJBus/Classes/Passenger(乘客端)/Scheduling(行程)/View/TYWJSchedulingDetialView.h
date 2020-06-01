//
//  TYWJSchedulingDetialView.h
//  TYWJBus
//
//  Created by tywj on 2020/5/29.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYWJSchedulingStationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYWJSchedulingDetialView : UIView
@property (weak, nonatomic) IBOutlet UIView *stationView;
@property (assign, nonatomic) NSInteger stateValue;
@end

NS_ASSUME_NONNULL_END
