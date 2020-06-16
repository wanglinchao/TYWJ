//
//  TYWJCalendarView.h
//  TYWJBus
//
//  Created by tywj on 2020/6/1.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYWJCalendarModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TYWJCalendarView : UIView
//1.下单详情    2.订单详情  3.选择
@property(assign, nonatomic) int type;
-(void)confirgCellWithModel:(id)model;
-(NSArray *)getSelectedDates;
@end

NS_ASSUME_NONNULL_END
