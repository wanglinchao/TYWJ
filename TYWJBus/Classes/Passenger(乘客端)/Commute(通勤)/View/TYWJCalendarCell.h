//
//  TYWJCalendarCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/12.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZLCalendarCell,ZLCalendarView;


UIKIT_EXTERN NSString * const TYWJCalendarCellID;

@protocol TYWJCalendarCellDelegate <NSObject>

@optional

- (void)calendarViewCellWillDisplayWithSelectedDate:(NSDate *)date selectedCell:(ZLCalendarCell *)cell indexPath:(NSIndexPath *)indexPath;
- (BOOL)calendarViewCellShouldSelected:(NSDate *)selectedDate indexPath:(NSIndexPath *)indexPath;
- (void)calendarViewCellDidSelected:(NSDate *)selectedDate cell:(ZLCalendarCell *)cell indexPath:(NSIndexPath *)indexPath;
- (void)calendarViewCellDidDeSelected:(NSDate *)selectedDate cell:(ZLCalendarCell *)cell indexPath:(NSIndexPath *)indexPath;

@end

@interface TYWJCalendarCell : UITableViewCell

/* lastSeats */
@property (strong, nonatomic) NSArray *lastSeats;
/* 自定义日历 */
@property (strong, nonatomic, readonly) ZLCalendarView *calendarView;
/* delegate */
@property (weak, nonatomic) id<TYWJCalendarCellDelegate> dlg;
- (void)addTarget:(id)target action:(nonnull SEL)action;
@end
