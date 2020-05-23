//
//  ZLCalendarView.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/16.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "ZLCalendarView.h"


@interface ZLCalendarView()<UICollectionViewDelegate,UICollectionViewDataSource>

/* calendar */
@property (strong, nonatomic) NSCalendar *calendar;
/* dateFormatter */
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
/* 天数 */
@property (strong, nonatomic) NSArray *days;
/* collectionView */
@property (strong, nonatomic) UICollectionView *collectionView;
/* firstDate */
@property (strong, nonatomic) NSDate *firstDate;
/* 上月一号 */
@property (strong, nonatomic) NSDate *lastMonthFirstDate;
/* 下月一号 */
@property (strong, nonatomic) NSDate *nextMonthFirstDate;
/* headerView */
@property (strong, nonatomic) UIView *headerView;
/* weekDayView */
@property (strong, nonatomic) UIView *weekDayView;
/* line */
@property (weak, nonatomic) UIView *line;
/* 选中的天 */
@property (strong, nonatomic) NSMutableArray *selectedDates;
/* dateLabel */
@property (weak, nonatomic) UILabel *dateLabel;

@end

//日历上显示的天数，最好是7的倍数
static NSInteger const kDays = 21;

@implementation ZLCalendarView

#pragma mark - 懒加载

- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _calendar;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
        
    }
    return _dateFormatter;
}

- (NSDate *)toDate {
    if (!_toDate) {
        _toDate = [self.dateFormatter dateFromString: [NSString stringWithFormat:@"%ld-%02ld-%02ld",self.year,self.month,self.today]];
    }
    return _toDate;
}

- (NSDate *)firstDate {
    if (!_firstDate) {
        NSUInteger year = 0,month = 0,day = 0;
        if (self.today - (self.weekDay - 1) > 0) {
            day = self.today - (self.weekDay - 1);
            month = self.month;
            year = self.year;
        }else {
            //上个月的天数范围
            NSRange lastMonthRange = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.lastMonthFirstDate];
            day = lastMonthRange.length - ((self.weekDay - 1) - self.today);
            if (self.month == 1) {
                month = 12;
                year = self.year - 1;
            }else {
                month = self.month - 1;
                year = self.year;
            }
        }
        _firstDate = [self.dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%02ld-%02ld",year,month,day]];
    }
    return _firstDate;
}

- (NSDate *)lastMonthFirstDate {
    if (!_lastMonthFirstDate) {
        if (self.month != 1) {
            _lastMonthFirstDate = [self.dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%02ld-%d",self.year,self.month - 1,01]];
        }else{
            _lastMonthFirstDate = [self.dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%d-%d",self.year - 1,12,01]];
        }
    }
    return _lastMonthFirstDate;
}

- (NSDate *)nextMonthFirstDate {
    if (!_nextMonthFirstDate) {
        if (self.month == 12) {
            _nextMonthFirstDate = [self.dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%d-%d",self.year + 1,1,1]];
        }else {
            _nextMonthFirstDate = [self.dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%02ld-%d",self.year,self.month + 1,1]];
        }
    }
    return _nextMonthFirstDate;
}

- (NSMutableArray *)selectedDates {
    if (!_selectedDates) {
        _selectedDates = [NSMutableArray array];
    }
    return _selectedDates;
}

- (NSArray *)days {
    if (!_days) {
        NSInteger year = 0,month = 0,day = 0;
        NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
        NSRange lastMonthrange = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.firstDate];
        
        NSArray *firstDateArr = [[self.dateFormatter stringFromDate:self.firstDate] componentsSeparatedByString:@"-"];
        NSArray *nextMonthDateArr = [[self.dateFormatter stringFromDate:self.nextMonthFirstDate] componentsSeparatedByString:@"-"];
        NSInteger firstDay = [firstDateArr[2] integerValue];
        NSInteger firstDayMonth = [firstDateArr[1] integerValue];
        NSInteger firstDayYear = [firstDateArr[0] integerValue];
        NSMutableArray *daysArr = [NSMutableArray array];
        NSInteger count = kDays;
        for (NSInteger i = 0; i < count; i++) {
            if (firstDayYear == self.year) {
                //第一天是今年的时候，执行这段代码,没这个判断的话，就会使第一天是12月的每一天都多加一个月
                if (firstDayMonth < self.month) {
                    if (firstDay + i > lastMonthrange.length) {
                        day = i + firstDay - lastMonthrange.length;
                        month = self.month;
                        year = self.year;
                    }
                    else {
                        day = firstDay + i;
                        month = [firstDateArr[1] integerValue];
                        year = [firstDateArr[0] integerValue];
                    }
                }else {
                    if (firstDay + i > range.length) {
                        day = firstDay + i - range.length;
                        month = [nextMonthDateArr[1] integerValue];
                        year = [nextMonthDateArr[0] integerValue];
                    }else {
                        day = firstDay + i;
                        month = self.month;
                        year = self.year;
                    }
                }
                
                NSString *dateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)year,month,day];
                NSDate *date = [self.dateFormatter dateFromString:dateString];
                [daysArr addObject:date];
                continue;
            }
            //第一天不是今年的时候，执行这段代码
            if (firstDay + i > lastMonthrange.length) {
                day = i + firstDay - lastMonthrange.length;
                month = self.month;
                year = self.year;
            }
            else {
                day = firstDay + i;
                month = [firstDateArr[1] integerValue];
                year = [firstDateArr[0] integerValue];
            }
            
            NSString *dateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)year,month,day];
            NSDate *date = [self.dateFormatter dateFromString:dateString];
            [daysArr addObject:date];
            
        }
        _days = daysArr;
    }
    return _days;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.minimumLineSpacing = 0;
        flowlayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowlayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"ZLCalendarCell" bundle:nil] forCellWithReuseIdentifier:ZLCalendarCellID];
        
    }
    return _collectionView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.frame = self.bounds;
        _headerView.zl_height = 30.f;
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *tipsLabel = [[UILabel alloc] init];
        tipsLabel.frame = CGRectMake(10.0f, 0, 100.f, 30.f);
        tipsLabel.textColor = [UIColor grayColor];
        tipsLabel.font = [UIFont systemFontOfSize:12.f];
        tipsLabel.text = @"选择乘车日期";
        [_headerView addSubview:tipsLabel];
        
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.font = tipsLabel.font;
        dateLabel.frame = CGRectMake(self.zl_width - 75.f, 0, 100.f, 30.f);
        dateLabel.text = [NSString stringWithFormat:@"%ld年%02ld月",self.year,self.month];
        dateLabel.textAlignment = NSTextAlignmentRight;
        dateLabel.textColor = tipsLabel.textColor;
        [_headerView addSubview:dateLabel];
        _dateLabel = dateLabel;
        
        UIView *line = [[UIView alloc] init];
        line.zl_bottmLine = _headerView.zl_height;
        line.zl_x = 0;
        line.zl_height = 0.5f;
        line.zl_width = _headerView.zl_width;
        line.backgroundColor = ZLGrayColorWithRGB(222);
        [_headerView addSubview:line];
        self.line = line;
    }
    return _headerView;
}

- (UIView *)weekDayView {
    if (!_weekDayView) {
        _weekDayView = [[UIView alloc] init];
        _weekDayView.backgroundColor = [UIColor clearColor];
        _weekDayView.frame = self.bounds;
        _weekDayView.zl_y = CGRectGetMaxY(self.headerView.frame);
        _weekDayView.zl_height = 30.f;
        
        NSArray *weekDays = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
        NSInteger count = weekDays.count;
        for (NSInteger i = 0; i < count; i++) {
            NSString *weekDay = weekDays[i];
            UILabel *weekDayLabel = [[UILabel alloc] init];
            weekDayLabel.font = [UIFont systemFontOfSize:14.f];
            weekDayLabel.textAlignment = NSTextAlignmentCenter;
            weekDayLabel.text = weekDay;
            weekDayLabel.textColor = [UIColor darkGrayColor];
            [_weekDayView addSubview:weekDayLabel];
        }
    }
    return _weekDayView;
}

#pragma mark - Set up view
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_zl_setup];
        [self p_zl_setupView];
    }
    return self;
}

- (void)p_zl_setup {
    NSDateComponents *nowCompoents =[self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:[NSDate date]];
    self.year = nowCompoents.year;
    self.month = nowCompoents.month;
    self.today = nowCompoents.day;
    self.weekDay = nowCompoents.weekday;
    
}

- (void)p_zl_setupView {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionView];
    [self addSubview:self.headerView];
    [self addSubview:self.weekDayView];
    [self.collectionView reloadData];
}

- (NSInteger)p_get_weekdayWithDate:(NSDate *)date {
    NSDateComponents *nowCompoents =[self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
    return nowCompoents.weekday;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    CGFloat headerH = 30.f;
    
    self.collectionView.frame = self.bounds;
    self.collectionView.zl_y = headerH*2.f;
    self.collectionView.zl_height = self.zl_height - 2.f*headerH;
    
    self.headerView.frame = self.bounds;
    self.headerView.zl_height = headerH;
    self.line.zl_width = self.zl_width;
    
    self.weekDayView.frame = self.bounds;
    self.weekDayView.zl_y = headerH;
    self.weekDayView.zl_height = headerH;
    self.dateLabel.zl_x = self.zl_width - 110.f;
    
    NSInteger count = self.weekDayView.subviews.count;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = self.weekDayView.zl_width/count;
    CGFloat h = self.weekDayView.zl_height;
    for (NSInteger i = 0; i < count; i++) {
        x = w*i;
        UILabel *weekDayLabel = self.weekDayView.subviews[i];
        weekDayLabel.frame = CGRectMake(x, y, w, h);
    }
    
}

#pragma mark - 外部方法

- (void)reloadCalendar {
    [self.collectionView reloadData];
}

- (void)reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self.collectionView reloadItemsAtIndexPaths:indexPaths];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.days.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZLCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZLCalendarCellID forIndexPath:indexPath];
    NSDate *date = self.days[indexPath.item];
    NSArray *dateArr = [[self.dateFormatter stringFromDate:date] componentsSeparatedByString:@"-"];
    cell.titleLabel.text = [dateArr lastObject];
    if (date.timeIntervalSince1970 < self.toDate.timeIntervalSince1970) {
        cell.subTitleLabel.hidden = YES;
        cell.titleLabel.textColor = [UIColor lightGrayColor];
    }else {
        cell.subTitleLabel.hidden = NO;
        cell.titleLabel.textColor = [UIColor blackColor];
    }
    
    if (self.canSelectWeekends) {
        NSInteger weekDay = [self p_get_weekdayWithDate:date];
        if (weekDay == 1 || weekDay == 7) {
            cell.subTitleLabel.hidden = YES;
            cell.titleLabel.textColor = [UIColor lightGrayColor];
        }
//        else {
//            cell.subTitleLabel.hidden = NO;
//            cell.titleLabel.textColor = [UIColor blackColor];
//        }
    }
    
    if ([self.delegate respondsToSelector:@selector(calendarViewCellWillDisplayWithSelectedDate:selectedCell:indexPath:)]) {
        
        NSDate *selectedDate = self.days[indexPath.row];
        [self.delegate calendarViewCellWillDisplayWithSelectedDate:selectedDate selectedCell:cell indexPath:indexPath];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.zl_width/7.f, self.collectionView.zl_height/(kDays/7));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZLCalendarCell *cell = (ZLCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selectedStatus = !cell.selectedStatus;
    [cell selectCellWithStatus:cell.selectedStatus];
    NSDate *selectedDate = self.days[indexPath.row];
    if (cell.selectedStatus) {
        [self.selectedDates addObject:selectedDate];
        if ([self.delegate respondsToSelector:@selector(calendarViewCellDidSelected:cell:indexPath:)]) {
            [self.delegate calendarViewCellDidSelected:selectedDate cell:cell indexPath:indexPath];
        }
    }else {
        [self.selectedDates removeObject:selectedDate];
        if ([self.delegate respondsToSelector:@selector(calendarViewCellDidDeSelected:cell:indexPath:)]) {
            [self.delegate calendarViewCellDidDeSelected:selectedDate cell:cell indexPath:indexPath];
        }
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = self.days[indexPath.item];
    if (date.timeIntervalSince1970 < self.toDate.timeIntervalSince1970) {
        return NO;
    }
    
    if (self.canSelectWeekends) {
        NSInteger weekDay = [self p_get_weekdayWithDate:date];
        if (weekDay == 1 || weekDay == 7) {
            return NO;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(calendarViewCellShouldSelected:indexPath:)]) {
        NSDate *selectedDate = self.days[indexPath.row];
        return [self.delegate calendarViewCellShouldSelected:selectedDate indexPath:indexPath];
    }
    return YES;
}

#pragma mark - waibu

- (void)deSelectWithCell:(ZLCalendarCell *)cell date:(NSDate *)date {
    cell.selectedStatus = NO;
    [cell selectCellWithStatus:NO];
    
    [self.selectedDates removeObject:date];
}

@end
