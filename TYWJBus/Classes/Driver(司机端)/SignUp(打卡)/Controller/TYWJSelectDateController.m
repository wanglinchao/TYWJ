//
//  TYWJSelectDateController.m
//  TYWJBus
//
//  Created by MacBook on 2018/12/24.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJSelectDateController.h"
#import "FSCalendar.h"

@interface TYWJSelectDateController ()<FSCalendarDataSource,FSCalendarDelegate>

@property (weak, nonatomic) FSCalendar *calendar;
//@property (weak, nonatomic) UIButton *previousButton;
//@property (weak, nonatomic) UIButton *nextButton;

@property (strong, nonatomic) NSCalendar *gregorian;
/* dateFormatter */
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation TYWJSelectDateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self loadView];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"选择日期";
        self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    }
    return self;
}
- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
//    self.dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    
    // 450 for iPad and 300 for iPhone
    CGFloat height = [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 450 : 300;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, kNavBarH, view.frame.size.width, height)];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.appearance.headerMinimumDissolvedAlpha = 0;
    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
    NSDate *date = [self.dateFormatter dateFromString:self.currentDateString];
    [calendar setCurrentPage:date animated:YES];
    [calendar selectDate:date];
    [self.view addSubview:calendar];
    self.calendar = calendar;
    
}

#pragma mark - delegate

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    ZLFuncLog;
    if (self.dateSelected) {
        NSString *selectedDateString = [self.dateFormatter stringFromDate:date];
        self.dateSelected(selectedDateString);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
