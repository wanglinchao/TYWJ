//
//  TYWJCalendarCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/12.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCalendarModel.h"
@class ZLCalendarCell,ZLCalendarView;


UIKIT_EXTERN NSString * const TYWJCalendarCellID;

@interface TYWJCalendarCell : UITableViewCell

/* 自定义日历 */
//@property (strong, nonatomic, readonly) ZLCalendarView *calendarView;
-(void)confirgCellWithModel:(id)model;
@end
