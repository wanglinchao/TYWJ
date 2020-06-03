//
//  TYWJRequestFailedController.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/12.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJRequestFailedController.h"
#import "TYWJBorderButton.h"


@interface TYWJRequestFailedController ()

@property (weak, nonatomic) IBOutlet TYWJBorderButton *reloadBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;


@end

@implementation TYWJRequestFailedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

- (void)setupView {
    
    self.view.backgroundColor = ZLGlobalBgColor;
    self.reloadBtn.backgroundColor = kMainRedColor;
    [self.reloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

#pragma mark - 按钮点击

- (IBAction)reloadBtnClicked:(TYWJBorderButton *)sender {
    ZLFuncLog;
    if (self.reloadClicked) {
        self.reloadClicked();
    }
}

- (void)setImg:(NSString *)img tips:(NSString *)tips btnTitle:(NSString *)btnTitle isHideBtn:(BOOL)isHideBtn {
    if (img) {
        self.imgView.image = [UIImage imageNamed:img];
    }
    if (tips) {
        self.tipsLabel.text = tips;
    }
    if (btnTitle) {
        [self.reloadBtn setTitle:btnTitle forState:UIControlStateNormal];
    }
    if (isHideBtn) {
        self.reloadBtn.hidden = isHideBtn;
    }
}
@end
