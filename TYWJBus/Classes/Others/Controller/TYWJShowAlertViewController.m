//
//  TYWJShowAlertViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/6/2.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJShowAlertViewController.h"
#import "TYWJTipsViewRefunds.h"
@interface TYWJShowAlertViewController ()
@property (strong, nonatomic) TYWJTipsViewRefunds *refundsView;

@end

@implementation TYWJShowAlertViewController
#pragma mark - 懒加载
- (TYWJTipsViewRefunds *)refundsView {
    if (!_refundsView) {
        _refundsView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TYWJTipsViewRefunds class]) owner:nil options:nil] lastObject];
    }
    return _refundsView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showRefundsWithDic:@{}];
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{}];
}
- (void)showRefundsWithDic:(NSDictionary *)dic{
    //    self.refundsView.zl_size = CGSizeMake(ZLScreenWidth - 88, 180.f);
    self.refundsView.frame = CGRectMake(0, 100, ZLScreenWidth - 80, 400);
    WeakSelf;
    self.refundsView.buttonSeleted = ^(NSInteger index) {
        switch (index - 200) {
            case 0:
            {
                [weakSelf dismissViewControllerAnimated:NO completion:^{}];
                
            }
                break;
            case 1:
            {
                
                
            }
                break;
            default:
                break;
        }
    };
    _refundsView.center = self.view.center;
    
    [self.view addSubview:self.refundsView];
    
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
