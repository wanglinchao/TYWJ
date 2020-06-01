//
//  TYWJCalendarViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/6/1.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJCalendarViewController.h"
#import "FSCalendar.h"
#import "TYWJCalendarView.h"
@interface TYWJCalendarViewController ()<FSCalendarDelegate,FSCalendarDataSource>
@property (strong, nonatomic) NSCalendar *chineseCalendar;

@property (strong, nonatomic) FSCalendar *calendar;


@end

@implementation TYWJCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TYWJCalendarView *view = [[TYWJCalendarView alloc] initWithFrame:CGRectMake(0, 200, ZLScreenWidth, 300)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
}

@end
