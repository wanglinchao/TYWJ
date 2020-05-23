//
//  TYWJApplyListCell.h
//  TYWJBus
//
//  Created by tywj on 2020/3/11.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJApplyListInfo;

NS_ASSUME_NONNULL_BEGIN

@interface TYWJApplyListCell : UITableViewCell
+ (instancetype)cellForTableView:(UITableView *)tableView;
/* routeListInfo */
@property (strong, nonatomic) TYWJApplyListInfo *applyListInfo;
@end

NS_ASSUME_NONNULL_END
