//
//  TYWJCalendarView.m
//  TYWJBus
//
//  Created by tywj on 2020/6/1.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJCalendarView.h"


#import "TYWJCalendarViewController.h"
#import "FSCalendar.h"
@interface TYWJCalendarView ()<FSCalendarDelegate,FSCalendarDataSource>
@property (strong, nonatomic) NSCalendar *chineseCalendar;

@property (strong, nonatomic) FSCalendar *calendar;


@end

@implementation TYWJCalendarView
#pragma mark - Set up view
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.chineseCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    
    
    _calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth, self.zl_height)];
    _calendar.backgroundColor = [UIColor whiteColor];
    _calendar.delegate = self;
    _calendar.dataSource = self;
    _calendar.appearance.weekdayTextColor = kMainBlackColor;
    _calendar.appearance.headerTitleColor = kMainBlackColor;
    _calendar.appearance.borderRadius = 0;
    _calendar.appearance.todayColor = [UIColor colorWithHexString:@"#1677FF"];
    _calendar.allowsMultipleSelection = YES;
    //    _calendar.appearance.eventDefaultColor = [UIColor redColor];
    //    _calendar.appearance.eventSelectionColor = [UIColor yellowColor];
    _calendar.appearance.selectionColor = kMainYellowColor;
    _calendar.appearance.titleSelectionColor = kMainBlackColor;
    [_calendar setCurrentPage:[NSDate date] animated:YES];
    _calendar.appearance.headerDateFormat = @"yyyy年MM月";
    _calendar.scope = FSCalendarScopeMonth;
    [self addSubview:_calendar];
    
    
    //创建点击跳转显示上一月和下一月button
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.frame = CGRectMake(0, 0, 100, 45);
    previousButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [previousButton setImage:[UIImage imageNamed:@"日历上个月"] forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    previousButton.backgroundColor = [UIColor whiteColor];
    [_calendar addSubview:previousButton];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(ZLScreenWidth - 100, 0, 100, 45);
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextButton setImage:[UIImage imageNamed:@"日历上个月"] forState:UIControlStateNormal];
    nextButton.backgroundColor = [UIColor whiteColor];
    nextButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_calendar addSubview:nextButton];
    
    
    
    
    
    
}
//上一月按钮点击事件
- (void)previousClicked:(id)sender {
    
    NSDate *lastMonth = [self.chineseCalendar dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:self.calendar.currentPage options:0];
    
    [self.calendar setCurrentPage:lastMonth animated:YES];
    
}

//下一月按钮点击事件
- (void)nextClicked:(id)sender {
    
    NSDate *nextMonth = [self.chineseCalendar dateByAddingUnit:NSCalendarUnitMonth value:2 toDate:self.calendar.currentPage options:0];

    [self.calendar setCurrentPage:nextMonth animated:YES];

}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{

    
}

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date{
    
    if ([self.chineseCalendar isDateInToday:date]){
        return @"今";
        
    }
    
    return nil;
    
}
- (nullable NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date{
    if ([self.chineseCalendar isDateInToday:date]){
        return @"售空";
        
    }
    return @"¥12";
}
- (__kindof FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position{
    FSCalendarCell *cell = [calendar cellForDate:date atMonthPosition:position];
    return cell;
}


////设置选中日期与未选中日期Title的颜色
//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleSelectionColorForDate:(NSDate *)date {
//
//    return [UIColor whiteColor];
//}
//
////背景色
//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date {
//
//    return [UIColor whiteColor];
//}

@end

