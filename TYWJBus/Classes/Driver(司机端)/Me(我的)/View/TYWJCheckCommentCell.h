//
//  TYWJCheckCommentCell.h
//  TYWJBus
//
//  Created by MacBook on 2019/1/3.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJDriverComplaintInfo,TYWJDriverCommentInfo;

UIKIT_EXTERN NSString * const TYWJCheckCommentCellID;

NS_ASSUME_NONNULL_BEGIN

@interface TYWJCheckCommentCell : UITableViewCell

/* TYWJDriverCommentInfo */
@property (strong, nonatomic) TYWJDriverCommentInfo *comment;
/* TYWJDriverComplaintInfo */
@property (strong, nonatomic) TYWJDriverComplaintInfo *complaint;

@end

NS_ASSUME_NONNULL_END
