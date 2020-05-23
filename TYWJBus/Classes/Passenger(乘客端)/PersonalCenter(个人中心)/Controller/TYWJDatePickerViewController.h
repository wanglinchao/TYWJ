//
//  TYWJDatePickerViewController.h
//  TYWJBus
//
//  Created by tywj on 2019/11/28.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYWJBasePopController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYWJDatePickerViewController : TYWJBasePopController
/* viewClicked */
@property (copy, nonatomic) void(^viewClicked)(void);
/* confirmClicked */
@property (copy, nonatomic) void(^confirmClicked)(NSString *time);
@end

NS_ASSUME_NONNULL_END
