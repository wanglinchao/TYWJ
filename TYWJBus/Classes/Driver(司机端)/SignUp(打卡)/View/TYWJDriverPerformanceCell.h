//
//  TYWJDriverPerformanceCell.h
//  TYWJBus
//
//  Created by MacBook on 2018/12/28.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJBonusInfo;

UIKIT_EXTERN NSString * const TYWJDriverPerformanceCellID;

NS_ASSUME_NONNULL_BEGIN

@interface TYWJDriverPerformanceCell : UITableViewCell

/* TYWJBonusInfo */
@property (strong, nonatomic) TYWJBonusInfo *info;

@end

NS_ASSUME_NONNULL_END
