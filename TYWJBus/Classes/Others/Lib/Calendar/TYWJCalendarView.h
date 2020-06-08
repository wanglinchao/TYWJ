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
-(void)confirgCellWithModel:(id)model;
-(NSArray *)getSelectedDates;
@end

NS_ASSUME_NONNULL_END
