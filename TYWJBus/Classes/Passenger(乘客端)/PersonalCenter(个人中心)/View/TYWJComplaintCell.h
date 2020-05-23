//
//  TYWJComplaintCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/21.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJComplaintModel;

UIKIT_EXTERN NSString * const TYWJComplaintCellID;

@interface TYWJComplaintCell : UITableViewCell

/* body */
@property (strong, nonatomic) TYWJComplaintModel *body;

- (void)setBtnSelectedStatus:(BOOL)status;

@end
