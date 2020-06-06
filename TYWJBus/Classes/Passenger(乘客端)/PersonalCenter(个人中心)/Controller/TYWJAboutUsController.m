//
//  TYWJAboutUsController.m
//  TYWJBus
//
//  Created by tywj on 2020/5/23.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJAboutUsController.h"
#import "MLCalendarView.h"
@interface TYWJAboutUsController ()
@property (nonatomic, strong) MLCalendarView * calendarView;


@end

@implementation TYWJAboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.calendarView = [[MLCalendarView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height - 100)];

    self.calendarView.backgroundColor = [UIColor whiteColor];

    self.calendarView.multiSelect = YES;//是否多选 默认NO

    self.calendarView.maxTotal = 2;//最多可以选择几天

    self.calendarView.mlColor = [UIColor orangeColor];//主题颜色 默认 深红色[UIColor colorWithRed:255/255.0 green:57/255.0 blue:84/255.0 alpha:1.0]

    [self.calendarView constructionUI];

    __weak typeof(self) weakSelf = self;

    self.calendarView.cancelBlock = ^{

    [weakSelf.calendarView removeFromSuperview]; };

    //单选回调 self.calendarView.selectBlock = ^(NSString *date) {

//    };

    //多选回调 self.calendarView.multiSelectBlock = ^(NSString *beginDate, NSString *endDate, NSInteger total) { //beginDate 起始日期 //endDate 结束日期 //total 总的天数

//    };

//    [self.view addSubview:self.calendarView];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
