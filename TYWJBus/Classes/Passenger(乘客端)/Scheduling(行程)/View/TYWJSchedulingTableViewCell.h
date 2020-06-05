//
//  TYWJSchedulingTableViewCell.h
//  TYWJBus
//
//  Created by tywj on 2020/5/28.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
UIKIT_EXTERN NSString * const TYWJSchedulingTableViewCellID;

@interface TYWJSchedulingTableViewCell : UITableViewCell

- (void)showHeaderView:(BOOL)show;
-(void)confirgCellWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
