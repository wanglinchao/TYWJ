//
//  ZLCalendarView.h
//  TYWJBus
//
//  Created by Harley He on 2018/7/16.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLCalendarCell.h"

@protocol ZLCalendarViewDelegate <NSObject>

@optional
- (void)calendarViewCellWillDisplayWithSelectedDate:(NSDate *)date selectedCell:(ZLCalendarCell *)cell indexPath:(NSIndexPath *)indexPath;
- (BOOL)calendarViewCellShouldSelected:(NSDate *)selectedDate indexPath:(NSIndexPath *)indexPath;
- (void)calendarViewCellDidSelected:(NSDate *)selectedDate cell:(ZLCalendarCell *)cell indexPath:(NSIndexPath *)indexPath;
- (void)calendarViewCellDidDeSelected:(NSDate *)selectedDate cell:(ZLCalendarCell *)cell indexPath:(NSIndexPath *)indexPath;

@end

@interface ZLCalendarView : UIView
/* 天数 */
@property (strong, nonatomic, readonly) NSArray *days;
/* lastSeats */
@property (strong, nonatomic) NSArray *lastSeats;
/* 选中的天 */
@property (strong, nonatomic, readonly) NSMutableArray *selectedDates;
/* 今年 */
@property (assign, nonatomic) NSInteger year;
/* 本月 */
@property (assign, nonatomic) NSInteger month;
/* 今天 */
@property (assign, nonatomic) NSInteger today;
/* 今天是周几 */
@property (assign, nonatomic) NSInteger weekDay;
/* 今天 */
@property (strong, nonatomic) NSDate *toDate;
/* 是否设置周末不能选 */
@property (assign, nonatomic) BOOL canSelectWeekends;

/* dlg */
@property (weak, nonatomic) id<ZLCalendarViewDelegate> delegate;

- (void)deSelectWithCell:(ZLCalendarCell *)cell date:(NSDate *)date;
- (void)reloadCalendar;
- (void)reloadItemsAtIndexPaths:(nonnull NSArray<NSIndexPath *> *)indexPaths;

@end
