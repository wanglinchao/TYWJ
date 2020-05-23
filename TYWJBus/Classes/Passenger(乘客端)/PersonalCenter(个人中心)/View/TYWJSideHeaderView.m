//
//  TYWJSideHeaderView.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/24.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJSideHeaderView.h"
#import "TYWJUserBasicInfo.h"
#import "TYWJLoginTool.h"


@implementation TYWJSideHeaderView

#pragma mark - setup view
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupView];
}

- (void)setupView {
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.avatarImageView setRoundView];
    
    if (self.userBasicInfo) {
        [self setBasicInfo];
        if ([TYWJLoginTool sharedInstance].avatarImg) {
            self.avatarImageView.image = [TYWJLoginTool sharedInstance].avatarImg;
        }
    }
}

#pragma mark -

- (void)setUserBasicInfo:(TYWJUserBasicInfo *)userBasicInfo {
    _userBasicInfo = userBasicInfo;
    [self setBasicInfo];
    if ([TYWJLoginTool sharedInstance].avatarImg) {
        self.avatarImageView.image = [TYWJLoginTool sharedInstance].avatarImg;
    }
}

- (void)setBasicInfo {
    if ([[TYWJLoginTool sharedInstance] loginStatus]) {
        self.avatarImageView.image = [UIImage imageNamed:self.userBasicInfo.avatarImage];
                self.nickNameLabel.text = self.userBasicInfo.nickname;
            self.phoneNumLabel.text = self.userBasicInfo.phoneNum;
    }else{
  self.avatarImageView.image = [UIImage imageNamed:self.userBasicInfo.avatarImage];
            self.nickNameLabel.text = @"未登陆";
            self.phoneNumLabel.text = @"";
    }

}

#pragma mark - view点击

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.viewClicked) {
        self.viewClicked();
    }
}
@end
