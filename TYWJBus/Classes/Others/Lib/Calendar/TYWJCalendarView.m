//
//  TYWJCalendarView.m
//  TYWJBus
//
//  Created by tywj on 2020/6/1.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJCalendarView.h"
#import "NSDate+HXExtension.h"

#import "FSCalendar.h"
@interface TYWJCalendarView ()<FSCalendarDelegate,FSCalendarDataSource>
@property (strong, nonatomic) NSCalendar *chineseCalendar;

@property (strong, nonatomic) FSCalendar *calendar;

@property (strong, nonatomic) NSArray *modelArr;

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
- (void)setType:(int)type{
    _type = type;
    switch (_type) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
//            _calendar.userInteractionEnabled = NO;
//            _calendar.scrollEnabled = YES;

        }
            break;
        case 2:
        {
            _calendar.allowsMultipleSelection = NO;

        }
            break;
        default:
            break;
    }
    [_calendar reloadData];
}
- (void)setupView {
    self.chineseCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    _calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, self.zl_width, self.zl_height)];
    _calendar.backgroundColor = [UIColor whiteColor];
    _calendar.headerHeight = 46.f;
    _calendar.weekdayHeight = 38.f;
    _calendar.delegate = self;
    _calendar.dataSource = self;
    _calendar.appearance.weekdayTextColor = kMainBlackColor;
    _calendar.appearance.headerTitleColor = kMainBlackColor;
    _calendar.appearance.borderRadius = 0;
    _calendar.appearance.todayColor = [UIColor clearColor];
    _calendar.appearance.titleTodayColor = [UIColor colorWithHexString:@"#1677FF"];
    _calendar.allowsMultipleSelection = YES;
    //    _calendar.appearance.eventDefaultColor = [UIColor redColor];
    //    _calendar.appearance.eventSelectionColor = [UIColor yellowColor];
    _calendar.appearance.selectionColor = kMainYellowColor;
    [_calendar setCurrentPage:[NSDate date] animated:YES];
    _calendar.appearance.headerDateFormat = @"yyyy年MM月";
    _calendar.scope = FSCalendarScopeMonth;
    [self addSubview:_calendar];
    
    
    //创建点击跳转显示上一月和下一月button
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.frame = CGRectMake(0, 0, 100, 46);
    previousButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [previousButton setImage:[UIImage imageNamed:@"日历上个月"] forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    previousButton.backgroundColor = [UIColor whiteColor];
    [_calendar addSubview:previousButton];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(self.zl_width - 100, 0, 100, 46);
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
//外部获取选中的日历天数
-(NSArray *)getSelectedDates{
    return _calendar.selectedDates;
}

//默认选中
-(void)selectDate{
    [_calendar selectDate:[NSDate new]];
}
-(void)confirgCellWithModel:(id)model{

    NSArray *infoArr = (NSArray *)model;
    
    self.modelArr = infoArr;
    [_calendar reloadData];
    if (self.type == 1) {
        _calendar.appearance.titleDefaultColor = [UIColor lightGrayColor];

            for (TYWJCalendarModel *mod in infoArr) {
            NSDate *data = [TYWJCommonTool dateFromString:mod.line_date withFormat:@"yyyy-MM-dd"];
            [_calendar selectDate:data];
            
        }
    }

}








- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    [ZLNotiCenter postNotificationName:TYWJTicketNumsDidChangeNoti object:nil];
    
}
- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    [ZLNotiCenter postNotificationName:TYWJTicketNumsDidChangeNoti object:nil];

}
- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    
    
    
}

//- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date{
//
//    return kMainRedColor;
//}
//起始日期
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar{
    
    
    if (self.type == 2 ) {
        return nil;
    }
    if (self.type == 1) {
        TYWJCalendarModel *minimodel = [self.modelArr firstObject];
        NSTimeInterval miniinterval = [[TYWJCommonTool dateFromString:minimodel.line_date withFormat:@"yyyy-MM-dd"] timeIntervalSince1970];
        for (TYWJCalendarModel *model in self.modelArr) {
            NSTimeInterval interval = [[TYWJCommonTool dateFromString:model.line_date withFormat:@"yyyy-MM-dd"] timeIntervalSince1970];
            if (miniinterval > interval) {
                miniinterval = interval;
                minimodel = model;
            }
        }
        return [TYWJCommonTool dateFromString:minimodel.line_date withFormat:@"yyyy-MM-dd"];
    }
    TYWJCalendarModel *model = [self.modelArr firstObject];
    if (model) {
        return [TYWJCommonTool dateFromString:model.line_date withFormat:@"yyyy-MM-dd"];
    } else{
        return [NSDate new];
    }
}
//结束日期
- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar{
    
    if (self.type == 2 ) {
        return nil;
    }
    if (self.type == 1) {
        TYWJCalendarModel *maxmodel = [self.modelArr lastObject];
        NSTimeInterval maxinterval = [[TYWJCommonTool dateFromString:maxmodel.line_date withFormat:@"yyyy-MM-dd"] timeIntervalSince1970];
        for (TYWJCalendarModel *model in self.modelArr) {
            NSTimeInterval interval = [[TYWJCommonTool dateFromString:model.line_date withFormat:@"yyyy-MM-dd"] timeIntervalSince1970];
            if (maxinterval < interval) {
                maxinterval = interval;
                maxmodel = model;
            }
        }
        return [TYWJCommonTool dateFromString:maxmodel.line_date withFormat:@"yyyy-MM-dd"];
    }
    TYWJCalendarModel *model = [self.modelArr lastObject];
    if (model) {
        return [TYWJCommonTool dateFromString:model.line_date withFormat:@"yyyy-MM-dd"];
    } else{
        return [NSDate new];
    }
}
//设置标题
- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date{
    
    //    if ([self.chineseCalendar isDateInToday:date]){
    //        return @"今";
    //
    //    }
    return nil;
}
//设置副标题
- (nullable NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date{
    if (self.type == 1) {
        return @"";
    }
    if (self.modelArr.count) {
        for (TYWJCalendarModel *model in self.modelArr) {
            if ([[date dateStringWithFormat:@"yyyy-MM-dd"] isEqualToString:model.line_date]) {
                return [NSString stringWithFormat:@"￥%0.1f",model.sell_price.floatValue/100];
            }
        }
    }
        
    return @"";
}
- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    if (self.type == 1) {
        return NO;
    }
    return YES;
}
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
        if (self.type == 1) {
        return NO;
    }
    return YES;
}
//设置选中日期与未选中日期Title的颜色
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleSelectionColorForDate:(NSDate *)date {

    return kMainBlackColor;
}
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleDefaultColorForDate:(NSDate *)date{
    return [UIColor clearColor];

}
////背景色
//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date {
//    if (self.modelArr.count) {
//        for (TYWJCalendarModel *model in self.modelArr) {
//            NSString *d = model.line_date;
//            NSString *ge = [date dateStringWithFormat:@"yyyy-MM-dd"];
//            if ([ge isEqualToString:d]) {
//                return kMainYellowColor;
//            }
//        }
//    }
//    return [UIColor clearColor];
//}

@end

