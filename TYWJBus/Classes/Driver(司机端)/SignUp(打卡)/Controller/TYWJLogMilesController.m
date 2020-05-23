//
//  TYWJLogMilesController.m
//  TYWJBus
//
//  Created by MacBook on 2018/12/13.
//  Copyright © 2018 MacBook. All rights reserved.
//  录入油耗信息界面

#import "TYWJLogMilesController.h"
#import "TYWJDriverLogMileView.h"
#import "TYWJMileageInfoController.h"
#import "ZLPopoverView.h"
#import "TYWJJsonRequestUrls.h"
#import "ZLHTTPSessionManager.h"
#import "TYWJLoginTool.h"
#import "TYWJMileageLog.h"
#import <MJExtension.h>


@interface TYWJLogMilesController ()

/* TYWJDriverLogMileView */
@property (strong, nonatomic) TYWJDriverLogMileView *milesView;
/* 获取到的车牌号 */
@property (strong, nonatomic) NSArray *carLicenses;
/* 选中的车牌号 */
@property (copy, nonatomic) NSString *selectedCarLicense;

@end

@implementation TYWJLogMilesController

#pragma mark - 懒加载

- (TYWJDriverLogMileView *)milesView {
    if (!_milesView) {
        _milesView = [[[NSBundle mainBundle] loadNibNamed:@"TYWJDriverLogMileView" owner:nil options:nil] lastObject];
        _milesView.frame = self.view.bounds;
        WeakSelf;
        _milesView.checkoutMileageInfoClicked = ^{
            [weakSelf requestCarMilesWithCarLicense:nil];
        };
        
        _milesView.confirmClicked = ^(NSString * _Nonnull carLicense, NSString * _Nonnull mileage) {
            [weakSelf requestUploadCarMilesWithCarLicense:carLicense mileage:mileage];
        };
        
        _milesView.chooseCarClicked = ^{
            if (weakSelf.carLicenses.count) {
                [weakSelf.view endEditing:YES];
                [[ZLPopoverView sharedInstance] showChooseCarLicenseViewWithCarLicenses:weakSelf.carLicenses cellSelected:^(NSString *cl) {
                    [weakSelf.milesView setCarLicense:cl];
                    [weakSelf requestCarMilesWithCarLicense:cl];
                }];
            }else {
                [weakSelf requestCarLicenses];
                [MBProgressHUD zl_showAlert:@"暂未获取到车牌号,请稍后重试!" afterDelay:2.f];
            }
            
        };
    }
    return _milesView;
}

#pragma mark - set up view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    
    [self requestCarLicenses];
}

- (void)setupView {
    self.navigationItem.title = @"录入油表里程";
    self.view.backgroundColor = ZLGlobalBgColor;
    
    [self.view addSubview:self.milesView];
    
}

#pragma mark - 数据请求

- (void)requestCarLicenses {
    WeakSelf;
    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"requestFrom"] = @"iOS";
    ZLHTTPSessionManager *mgr = [ZLHTTPSessionManager manager];
    [mgr.requestSerializer setValue:[TYWJLoginTool sharedInstance].driverInfo.token forHTTPHeaderField:@"token"];
    [mgr GET:[TYWJJsonRequestUrls sharedRequest].carNumbers parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        if ([responseObject[@"errCode"] integerValue] == 0) {
            weakSelf.carLicenses = responseObject[@"data"];
            if (weakSelf.carLicenses.count) {
                weakSelf.selectedCarLicense = weakSelf.carLicenses.firstObject;
            }
        }else {
            [MBProgressHUD zl_showError:responseObject[@"msg"] toView:weakSelf.view];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:weakSelf.view];
    }];
}

- (void)requestCarMilesWithCarLicense:(NSString *)carLicense {
    WeakSelf;
    [MBProgressHUD zl_showMessage:TYWJWarningLoading toView:weakSelf.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"requestFrom"] = @"iOS";
    params[@"pageNum"] = @(1);
    if (carLicense) {
        params[@"pageSize"] = @(1);
        params[@"carNumber"] = carLicense;
    }else {
        params[@"pageSize"] = @(10000);
    }
    ZLHTTPSessionManager *mgr = [ZLHTTPSessionManager manager];
    [mgr.requestSerializer setValue:[TYWJLoginTool sharedInstance].driverInfo.token forHTTPHeaderField:@"token"];
    [mgr GET:[TYWJJsonRequestUrls sharedRequest].logMileage parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        if ([responseObject[@"errCode"] integerValue] == 0) {
            if (carLicense) {
                NSArray *mileageLogs = responseObject[@"data"][@"mileageLogs"];
                if (mileageLogs.count) {
                    weakSelf.milesView.tipsLabel.text = [NSString stringWithFormat:@"上次录入%@km",mileageLogs[0][@"mileage"]];
                }else {
                    weakSelf.milesView.tipsLabel.text = @"暂无里程记录";
                }
            }else {
                TYWJMileageInfoController *mileageVc = [[TYWJMileageInfoController alloc] init];
                mileageVc.carLicenses = responseObject[@"data"][@"carNumbers"];
                mileageVc.mileageInfos = [TYWJMileageLog mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"mileageLogs"]];
                [weakSelf.navigationController pushViewController:mileageVc animated:YES];
            }
        }else {
            [MBProgressHUD zl_showError:responseObject[@"msg"] toView:weakSelf.view];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:weakSelf.view];
    }];
}

- (void)requestUploadCarMilesWithCarLicense:(NSString *)license mileage:(NSString *)mileage {
    WeakSelf;
    [MBProgressHUD zl_showMessage:@"正在录入里程" toView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"requestFrom"] = @"iOS";
    params[@"carNumber"] = license;
    params[@"mileage"] = mileage;
    ZLHTTPSessionManager *mgr = [ZLHTTPSessionManager signManager];
    [mgr.requestSerializer setValue:[TYWJLoginTool sharedInstance].driverInfo.token forHTTPHeaderField:@"token"];
    [mgr POST:[TYWJJsonRequestUrls sharedRequest].logMileage parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD zl_hideHUDForView:weakSelf.view];
        if ([responseObject[@"errCode"] integerValue] == 0) {
            [MBProgressHUD zl_showSuccess:@"录入成功" toView:weakSelf.view];
        }else {
            [MBProgressHUD zl_showError:responseObject[@"msg"] toView:weakSelf.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD zl_showError:TYWJWarningBadNetwork toView:weakSelf.view];
    }];
}

- (void)setSelectedCarLicense:(NSString *)selectedCarLicense {
    _selectedCarLicense = [selectedCarLicense copy];
    
    if (selectedCarLicense) {
        [self.milesView setCarLicense:selectedCarLicense];
        [self requestCarMilesWithCarLicense:selectedCarLicense];
    }
}

@end
