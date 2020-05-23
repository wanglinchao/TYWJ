//
//  TYWJCalendarCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/12.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJCalendarCell.h"
#import "ZLCalendarView.h"



NSString * const TYWJCalendarCellID = @"TYWJCalendarCellID";

@interface TYWJCalendarCell()<ZLCalendarViewDelegate>
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
/* buyDescriptionBtn */
@property (strong, nonatomic) UIButton *buyDescriptionBtn;
/* currCalendar */
@property (strong, nonatomic) NSCalendar *currentCalendar;
/* 自定义日历 */
@property (strong, nonatomic) ZLCalendarView *calendarView;
@end
@implementation TYWJCalendarCell

#pragma mark - 懒加载

- (NSCalendar *)currentCalendar {
    if (!_currentCalendar) {
        _currentCalendar = [NSCalendar currentCalendar];
    }
    return _currentCalendar;
}
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy/MM/dd";
    }
    return _dateFormatter;
}
- (UIButton *)buyDescriptionBtn {
    if (!_buyDescriptionBtn) {
        _buyDescriptionBtn = [[UIButton alloc] init];
        [_buyDescriptionBtn setTitle:@"购买须知" forState:UIControlStateNormal];
        [_buyDescriptionBtn setImage:[UIImage imageNamed:@"icon_about_12x12_"] forState:UIControlStateNormal];
        [_buyDescriptionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _buyDescriptionBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        
    }
    return _buyDescriptionBtn;
}
#pragma mark - setup view
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
//    NSCalendar
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addCustomCalendar];
    [self addSubview:self.buyDescriptionBtn];
    
}

- (void)addCustomCalendar {
    ZLCalendarView *calendar = [[ZLCalendarView alloc] initWithFrame:CGRectMake(0, 0, self.zl_width, 220.f)];
    [calendar setRoundViewWithCornerRaidus:6.f];
//    [calendar setBorderWithColor:ZLGlobalTextColor];
    calendar.delegate = self;
    [self addSubview:calendar];
    self.calendarView = calendar;
    calendar.backgroundColor = [UIColor whiteColor];
}

#pragma mark - ZLCalendarViewDelegate

- (void)calendarViewCellWillDisplayWithSelectedDate:(NSDate *)date selectedCell:(ZLCalendarCell *)cell indexPath:(NSIndexPath *)indexPath {
    if ([self.dlg respondsToSelector:@selector(calendarViewCellWillDisplayWithSelectedDate:selectedCell:indexPath:)]) {
        [self.dlg calendarViewCellWillDisplayWithSelectedDate:date selectedCell:cell indexPath:indexPath];
    }
}

- (BOOL)calendarViewCellShouldSelected:(NSDate *)selectedDate indexPath:(NSIndexPath *)indexPath {
    if ([self.dlg respondsToSelector:@selector(calendarViewCellShouldSelected:indexPath:)]) {
        return [self.dlg calendarViewCellShouldSelected:selectedDate indexPath:indexPath];
    }
    return YES;
}

- (void)calendarViewCellDidSelected:(NSDate *)selectedDate cell:(ZLCalendarCell *)cell indexPath:(NSIndexPath *)indexPath {
    if ([self.dlg respondsToSelector:@selector(calendarViewCellWillDisplayWithSelectedDate:selectedCell:indexPath:)]) {
        [self.dlg calendarViewCellDidSelected:selectedDate cell:cell indexPath:indexPath];
    }
}

- (void)calendarViewCellDidDeSelected:(NSDate *)selectedDate cell:(ZLCalendarCell *)cell indexPath:(NSIndexPath *)indexPath {
    if ([self.dlg respondsToSelector:@selector(calendarViewCellDidDeSelected:cell:indexPath:)]) {
        [self.dlg calendarViewCellDidDeSelected:selectedDate cell:cell indexPath:indexPath];
    }
}

#pragma mark -

- (void)layoutSubviews {
    [super layoutSubviews];
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    imageV.frame = CGRectMake(16, 17, 4, 16);
    imageV.backgroundColor = kMainYellowColor;
    [self addSubview:imageV];
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    tipsLabel.font = [UIFont systemFontOfSize:16.f];
    tipsLabel.textAlignment = NSTextAlignmentLeft;
    tipsLabel.frame = CGRectMake(32.f, 0, ZLScreenWidth - 20.f, 50.f);
    tipsLabel.text = @"车票日历（请选择乘车日期）";
    [self addSubview:tipsLabel];
    self.buyDescriptionBtn.frame = CGRectMake(self.zl_width - 75.f, self.zl_height - 30.f, 65.f, 20.f);
    
    self.calendarView.frame = CGRectMake(17.f, 50.f, self.zl_width - 34.f, self.zl_height - 50.f);
}

- (void)addTarget:(id)target action:(SEL)action {
    [self.buyDescriptionBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

//是否是周末
- (BOOL)isWeekendDayWithDate:(NSDate *)date {
    NSDateComponents *comp = [self.currentCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    //1是周日   7是周六
    if (weekDay == 1 || weekDay == 7) {
        return YES;
    }
    return NO;
}

/**
 是否在今天之前
 */
- (BOOL)isPreviouseThanTodayWithDate:(NSDate *)date {
    NSDateComponents *selectComp = [self.currentCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:date];
    NSDateComponents *todayComp = [self.currentCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:[NSDate date]];
    // 获取是几号
    NSInteger selectDay = [selectComp day];
    NSInteger today = [todayComp day];
    NSInteger selectMonth = [selectComp month];
    NSInteger currMonyh = [todayComp month];
    if (currMonyh > selectMonth) {
        return NO;
    }
    if (selectDay < today) {
        return YES;
    }
    return NO;
}

/**
 是否是本月
 */
- (BOOL)isCurrentMonthWithDate:(NSDate *)date {
    NSDateComponents *selectComp = [self.currentCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:date];
    NSDateComponents *todayComp = [self.currentCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:[NSDate date]];
    
    // 获取是几号
    NSInteger selectMonth = [selectComp month];
    NSInteger currMonyh = [todayComp month];
    if (currMonyh != selectMonth) {
        return YES;
    }
    return NO;
}

- (NSString *)getCurrentMonth {
    NSDateComponents *todayComp = [self.currentCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:[NSDate date]];
    // 获取是几号
    NSInteger currMonth = [todayComp month];
    NSInteger currYear = [todayComp year];
    return [NSString stringWithFormat:@"%ld年%ld月",currYear,currMonth];
}
@end
