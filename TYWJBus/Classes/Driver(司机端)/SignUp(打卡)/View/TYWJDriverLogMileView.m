//
//  TYWJDriverLogMileView.m
//  TYWJBus
//
//  Created by MacBook on 2018/12/13.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJDriverLogMileView.h"



@interface TYWJDriverLogMileView()

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UITextField *milesTF;
@property (weak, nonatomic) IBOutlet UITextField *carLicenseTF;
@property (weak, nonatomic) IBOutlet UILabel *carLicenseLabel;

@property (weak, nonatomic) IBOutlet UIView *containerView1;
@property (weak, nonatomic) IBOutlet UIView *containerView2;

@end

@implementation TYWJDriverLogMileView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.containerView1 setRoundViewWithCornerRaidus:8.f];
    [self.containerView2 setRoundViewWithCornerRaidus:8.f];
    
    self.carLicenseTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.milesTF.clearButtonMode = UITextFieldViewModeWhileEditing;
}


- (void)setCarLicense:(NSString *)license {
    if (license) {
        self.carLicenseTF.text = license;
        self.carLicenseLabel.text = license;
    }
    
}
#pragma mark - 按钮点击

- (IBAction)chooseCar:(id)sender {
    ZLFuncLog;
    if (self.chooseCarClicked) {
        self.chooseCarClicked();
    }
}
- (IBAction)checkoutMilesRecord:(id)sender {
    ZLFuncLog;
    if (self.checkoutMileageInfoClicked) {
        self.checkoutMileageInfoClicked();
    }
}
- (IBAction)sureClicked:(id)sender {
    ZLFuncLog;
    if (!self.carLicenseTF.text.length || !self.milesTF.text.length) {
        [MBProgressHUD zl_showAlert:@"请输入车牌号或油耗里程" afterDelay:2.f];
        return;
    }
    if (self.confirmClicked) {
        self.confirmClicked(self.carLicenseTF.text, self.milesTF.text);
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    ZLFuncLog;
    [self endEditing:YES];
}

@end
