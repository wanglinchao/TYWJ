//
//  TYWJTipsView.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/25.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJTipsView.h"

@interface TYWJTipsView()



@end

@implementation TYWJTipsView


#pragma mark - 按钮点击

- (void)awakeFromNib {
    [super awakeFromNib];
    self.changePhoneBtn.layer.borderColor = [UIColor colorWithHexString:@"#FED302"].CGColor;
    [self setupView];
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    [self setRoundViewWithCornerRaidus:8.f];
}

/**
 更换手机号点击
 */
- (IBAction)closeBtn:(id)sender {
    if (self.changePhoneNumClicked) {
        self.changePhoneNumClicked();
    }
}
- (IBAction)changePhone:(id)sender {
    if (self.changePhoneNumClicked) {
        self.changePhoneNumClicked();
    }
}

/**
 注册点击
 */
- (IBAction)registerClicked:(id)sender {
    if (self.registerClicked) {
        self.registerClicked();
    }
}


@end
