//
//  TYWJCalendarCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/12.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYWJCalendarView.h"
@class ZLCalendarCell;


UIKIT_EXTERN NSString * const TYWJCalendarCellID;

@interface TYWJCalendarCell : UITableViewCell
@property (strong, nonatomic) TYWJCalendarView *calendarView;
/* 自定义日历 */
-(void)confirgCellWithModel:(id)model;
@end
