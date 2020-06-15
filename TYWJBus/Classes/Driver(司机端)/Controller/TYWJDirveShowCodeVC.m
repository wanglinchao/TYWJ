//
//  TYWJDirveShowCodeVC.m
//  TYWJBus
//
//  Created by tywj on 2020/6/15.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJDirveShowCodeVC.h"
#import <SGQRCode.h>
#import "WRNavigationBar.h"
@interface TYWJDirveShowCodeVC ()
@property (weak, nonatomic) IBOutlet UIImageView *codeImageV;

@end

@implementation TYWJDirveShowCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"验票码";
    self.codeImageV.image = [SGQRCodeObtain generateQRCodeWithData:@"https://github.com/kingsic" size:300];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [WRNavigationBar wr_setDefaultNavBarBarTintColor:[UIColor clearColor]];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [WRNavigationBar wr_setDefaultNavBarBarTintColor:ZLNavBgColor];

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
