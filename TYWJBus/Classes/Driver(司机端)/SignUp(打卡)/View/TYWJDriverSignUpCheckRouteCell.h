//
//  TYWJDriverSignUpCheckRouteCell.h
//  TYWJBus
//
//  Created by MacBook on 2018/12/24.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJTripsModel;


NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * const TYWJDriverSignUpCheckRouteCellID;

@interface TYWJDriverSignUpCheckRouteCell : UITableViewCell

/* trips */
@property (strong, nonatomic) TYWJTripsModel *trips;

@end

NS_ASSUME_NONNULL_END
