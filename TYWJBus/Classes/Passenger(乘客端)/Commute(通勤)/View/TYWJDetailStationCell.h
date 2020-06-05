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
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (copy, nonatomic) void(^buttonSeleted)(NSInteger index);
@property (weak, nonatomic) IBOutlet UIImageView *stationImage;
@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet UIView *showTopView;
@property (weak, nonatomic) IBOutlet UIView *showBottomView;

@end

NS_ASSUME_NONNULL_END
