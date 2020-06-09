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
@interface TYWJShowAlertViewController ()
@property (strong, nonatomic) TYWJTipsViewRefunds *refundsView;
@property (strong, nonatomic) TYWJShareVIew *shareVIew;

@end

@implementation TYWJShowAlertViewController
#pragma mark - 懒加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{}];
}
- (void)showRefundsWithDic:(NSDictionary *)dic{
    //    self.refundsView.zl_size = CGSizeMake(ZLScreenWidth - 88, 180.f);
    self.refundsView = [[TYWJTipsViewRefunds alloc] initWithFrame:CGRectMake(20, (ZLScreenHeight - 244)/2, ZLScreenWidth - 40, 244)];
    WeakSelf;
    self.refundsView.buttonSeleted = ^(NSInteger index) {
        [weakSelf dismissViewControllerAnimated:NO completion:^{}];
        if (weakSelf.buttonSeleted)
        {
            weakSelf.buttonSeleted(index);
        }
    };
    _refundsView.center = self.view.center;

    [self.view addSubview:self.refundsView];
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
