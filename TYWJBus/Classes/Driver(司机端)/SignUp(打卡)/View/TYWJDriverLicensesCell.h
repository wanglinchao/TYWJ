//
//  TYWJDriverLicensesCell.h
//  TYWJBus
//
//  Created by MacBook on 2018/12/14.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJMileageLog;

UIKIT_EXTERN NSString * const TYWJDriverLicensesCellID;

NS_ASSUME_NONNULL_BEGIN

@interface TYWJDriverLicensesCell : UITableViewCell

/* TYWJMileageLog.h */
@property (strong, nonatomic) TYWJMileageLog *mileageLog;

@end

NS_ASSUME_NONNULL_END
