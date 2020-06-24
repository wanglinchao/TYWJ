//
//  TYWJShowAlertViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/6/2.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJShowAlertViewController.h"
#import "TYWJTipsViewRefunds.h"
#import "TYWJShareVIew.h"
#import "TYWJCalendarView.h"
#import "TYWJBottomBtnView.h"
#import "TYWJTipsViewRefundsStatus.h"
@interface TYWJShowAlertViewController ()
@property (strong, nonatomic) TYWJTipsViewRefunds *refundsView;
@property (strong, nonatomic) TYWJTipsViewRefundsStatus *refundsStatusView;

@property (strong, nonatomic) TYWJShareVIew *shareVIew;
@property (strong, nonatomic) TYWJCalendarView *calendarView;

@end

@implementation TYWJShowAlertViewController
#pragma mark - 懒加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)dismiss:(id)sender {
    if (self.buttonSeleted)
    {
        self.buttonSeleted(0);
    }
    [self dismissViewControllerAnimated:NO completion:^{}];
}
- (void)showRefundsWithDic:(id)dic{
    //    self.refundsView.zl_size = CGSizeMake(ZLScreenWidth - 88, 180.f);
    self.refundsView = [[TYWJTipsViewRefunds alloc] initWithFrame:CGRectMake(48, (ZLScreenHeight - 304)/2, ZLScreenWidth - 48*2, 304)];
    [self.refundsView confirgCellWithParam:dic];
    WeakSelf;
    self.refundsView.buttonSeleted = ^(NSInteger index) {
        [weakSelf dismissViewControllerAnimated:NO completion:^{}];
        if (weakSelf.buttonSeleted)
        {
            if (index == 200) {
                if (weakSelf.getData)
                {
                    NSString *num = weakSelf.refundsView.numLabel.text;
                    weakSelf.getData(num);
                }
            }
            weakSelf.buttonSeleted(index);
        }
        
    };
    _refundsView.center = self.view.center;

    [self.view addSubview:self.refundsView];
}
- (void)showRefundsStatusWithDic:(id)dic{
    //    self.refundsView.zl_size = CGSizeMake(ZLScreenWidth - 88, 180.f);
    self.refundsStatusView = [[TYWJTipsViewRefundsStatus alloc] initWithFrame:CGRectMake(48, (ZLScreenHeight - 180)/2, ZLScreenWidth - 48*2, 180)];
    [self.refundsStatusView confirgCellWithParam:dic];
    WeakSelf;
    self.refundsStatusView.buttonSeleted = ^(NSInteger index) {
        [weakSelf dismissViewControllerAnimated:NO completion:^{}];
        if (weakSelf.buttonSeleted)
        {
            if (index == 200) {
                if (weakSelf.getData)
                {
                    weakSelf.getData(@(weakSelf.refundsView.numLabel.text.intValue));
                }
            }
            weakSelf.buttonSeleted(index);
        }
        
    };
    _refundsStatusView.center = self.view.center;

    [self.view addSubview:self.refundsStatusView];
}
- (void)showShareViewWithDic:(NSDictionary *)dic{
    self.shareVIew = [[TYWJShareVIew alloc] initWithFrame:CGRectMake(0, ZLScreenHeight - 185 - kTabBarH, ZLScreenWidth, 185 + kTabBarH)];
    WeakSelf;
    self.shareVIew.buttonSeleted = ^(NSInteger index) {
        [weakSelf dismissViewControllerAnimated:NO completion:^{}];
        
        if (weakSelf.buttonSeleted)
        {
            weakSelf.buttonSeleted(index);
        }
    };
    _shareVIew.center = self.view.center;

    [self.view addSubview:self.shareVIew];
}
- (void)showCalendarViewithDic:(NSDictionary *)dic{
    UIView *view= [[UIView alloc] initWithFrame:CGRectMake(16, (ZLScreenHeight - 354)/2, ZLScreenWidth - 32, 354)];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 8.0f;
    view.backgroundColor = [UIColor whiteColor];
    self.calendarView = [[TYWJCalendarView alloc] initWithFrame:CGRectMake(0, 0, view.zl_width, view.zl_height - 70)];
    self.calendarView.type = 2;
    [view addSubview:self.calendarView];
    TYWJBottomBtnView *bottomBtnView = [[TYWJBottomBtnView alloc] initWithFrame:CGRectMake(0, self.calendarView.zl_height, view.zl_width, 70)];
    bottomBtnView.titleArr = @[@"取消",@"确认"];
    bottomBtnView.buttonSeleted = ^(NSInteger index) {
        
        NSArray *arr = self.calendarView.getSelectedDates;
        if (index == 201 && arr.count == 0) {
            [MBProgressHUD zl_showError:@"请选择班次日期"];
            return;
        }
        if (self.buttonSeleted)
        {
            self.buttonSeleted(index);
        }
        if (index == 200 ) {
            
            [self dismissViewControllerAnimated:NO completion:^{}];
            return;
        }
        [self dismissViewControllerAnimated:NO completion:^{}];
        NSDate *calendarDate = arr.firstObject;
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *str = [outputFormatter stringFromDate:calendarDate];
        if (self.getData)
        {
            self.getData(str);
        }
    };
    [view addSubview:bottomBtnView];
    [self.view addSubview:view];
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
