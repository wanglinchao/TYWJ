//
//  TYWJBaseCell.h
//  TYWJBus
//
//  Created by tywj on 2020/6/11.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJBaseCell : UITableViewCell
+ (instancetype)cellForTableView:(UITableView *)tableView;
-(void)confirgCellWithParam:(id)Param;
@end

NS_ASSUME_NONNULL_END
