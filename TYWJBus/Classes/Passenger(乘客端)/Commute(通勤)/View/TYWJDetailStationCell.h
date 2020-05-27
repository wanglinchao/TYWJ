//
//  TYWJDetailStationCell.h
//  TYWJBus
//
//  Created by tywj on 2020/5/26.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYWJSubRouteList.h"
NS_ASSUME_NONNULL_BEGIN
UIKIT_EXTERN NSString * const TYWJDetailStationCellID;

@interface TYWJDetailStationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTopHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconBottomHeight;
- (void)configCellWithData:(TYWJSubRouteListInfo *)data;
+ (instancetype)cellForTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
