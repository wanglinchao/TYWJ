//
//  TYWJMyOrderTableViewCell.h
//  TYWJBus
//
//  Created by tywj on 2020/6/1.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYWJOrderList.h"
NS_ASSUME_NONNULL_BEGIN

@interface TYWJMyOrderTableViewCell : UITableViewCell
+ (instancetype)cellForTableView:(UITableView *)tableView;
-(void)confirgCellWithModel:(TYWJOrderList *)model;
@end

NS_ASSUME_NONNULL_END
