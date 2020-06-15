//
//  TYWJDriverHomeViewViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/6/11.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJDriverHomeViewViewController.h"
#import "TYWJDriveHomeList.h"
#import "TYWJDriverHomeTableViewController.h"
#import "TYWJDriverPassengerListController.h"
#import "TYWJDrierAchievementController.h"
#import "YJPageControlView.h"
#import "TYWJShowAlertViewController.h"

@interface TYWJDriverHomeViewViewController ()
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation TYWJDriverHomeViewViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray array];
    self.navigationItem.title = [TYWJCommonTool getTodayDay];
    //    navigationItem.title = @"title";
    //    self.title = [TYWJCommonTool getTodayDay];
    [self setupView];
    [self addNotis];
    NSMutableArray *viewControllers = [NSMutableArray array];
    NSArray *titles = @[@"待完成", @"已完成"];
    CGRect frame =CGRectMake(0, kNavBarH, ZLScreenWidth, ZLScreenHeight - kTabBarH -kNavBarH);
    for (int i = 0 ; i<titles.count; i++) {
        TYWJDriverHomeTableViewController *vc = [[TYWJDriverHomeTableViewController alloc] init];
        vc.status = [NSString stringWithFormat:@"%d",i];
        [viewControllers addObject:vc];
    }
    YJPageControlView *PageControlView = [[YJPageControlView alloc] initWithFrame:frame Titles:titles viewControllers:viewControllers Selectindex:0];
    [PageControlView showInViewController:self];
}
#pragma mark - 通知
- (void)addNotis {
    [ZLNotiCenter addObserver:self selector:@selector(showCalendarView) name:@"TYWJDriverHomeViewViewControllerShowCalendar" object:nil];
}

- (void)removeNotis {
    [ZLNotiCenter removeObserver:self name:@"TYWJDriverHomeViewViewControllerShowCalendar" object:nil];
}
- (void)dealloc {
    ZLFuncLog;
    [self removeNotis];
}
- (void)setupView{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30.f, 20.f)];
    leftBtn.tag = 200;
    [leftBtn setTitle:@"查看绩效" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [leftBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(barBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30.f, 20.f)];
    rightBtn.tag = 201;
    [rightBtn setTitle:@"更多班次" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(barBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}
- (void)barBtnClicked:(UIButton *)button{
    switch (button.tag) {
        case 200:
        {
            TYWJDrierAchievementController *vc = [[TYWJDrierAchievementController alloc] init];
            [TYWJCommonTool pushToVc:vc];
        }
            break;
        case 201:
        {
            [self showCalendarView];
        }
            break;
        default:
            break;
    }
}
- (void)showCalendarView{
    self.tabBarController.tabBar.hidden = YES;
    TYWJShowAlertViewController *vc = [TYWJShowAlertViewController new];
    [vc showCalendarViewithDic:@{}];
    vc.buttonSeleted = ^(NSInteger index){
        self.tabBarController.tabBar.hidden = NO;
    };
    vc.getData = ^(id  _Nonnull date) {
        NSString *str = (NSString *)date;
        TYWJDriverHomeTableViewController *vc = [[TYWJDriverHomeTableViewController alloc] init];
        vc.status = @"1";
        vc.dayStr = str;
        [TYWJCommonTool pushToVc:vc];
    };
    [TYWJCommonTool presentToVcNoanimated:vc];
}
@end
