//
//  TYWJDriverSignUpRouteHeaderView.h
//  TYWJBus
//
//  Created by MacBook on 2018/12/24.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJDriverSignUpRouteHeaderView : UIView

@property (weak, nonatomic, readonly) IBOutlet UILabel *realMileageLabel;
@property (weak, nonatomic, readonly) IBOutlet UILabel *allRoutesLabel;
@property (weak, nonatomic, readonly) IBOutlet UILabel *estimateMileageLabel;

@end

NS_ASSUME_NONNULL_END
