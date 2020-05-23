//
//  TYWJActivityCenterCell.h
//  TYWJBus
//
//  Created by Harllan He on 2018/5/30.
//  Copyright © 2018 Harllan He. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJActivityCenterInfo;

UIKIT_EXTERN NSString * const TYWJActivityCenterCellID;

@interface TYWJActivityCenterCell : UITableViewCell

/* TYWJActivityCenter */
@property (strong, nonatomic) TYWJActivityCenterInfo *acInfo;

@end
