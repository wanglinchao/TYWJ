//
//  TYWJCharteredBusCell.h
//  TYWJBus
//
//  Created by tywj on 2019/11/26.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJCharteredBusCell : UITableViewCell
@property (copy, nonatomic) void(^submitBtnClicked)(NSString *numStr, NSString *nameStr, NSString *phoneStr, NSString *timeStr, NSString *reqStr);
+ (instancetype)cellForTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
