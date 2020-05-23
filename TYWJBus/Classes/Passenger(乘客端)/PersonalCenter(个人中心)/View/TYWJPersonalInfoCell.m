//
//  TYWJPersonalInfoCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/11.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJPersonalInfoCell.h"
#import "TYWJPersonalInfoPlist.h"
#import "TYWJLoginTool.h"


NSString * const TYWJPersonalInfoCellID = @"TYWJPersonalInfoCellID";

@interface TYWJPersonalInfoCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UITextField *chooseGenderTF;
@property (weak, nonatomic) IBOutlet UITextField *infoTF;


@end

@implementation TYWJPersonalInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [ZLNotiCenter addObserver:self selector:@selector(photoSelctedSuccess:) name:TYWJPhotoSelectedSuccessNoti object:nil];
    
    [self setupView];
}

- (void)setupView {
    [self.avatarImgView setRoundView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.infoTF.delegate = self;
    self.infoTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIButton *checkAvatarBtn = [[UIButton alloc] init];
    checkAvatarBtn.frame = self.avatarImgView.bounds;
    [self.avatarImgView addSubview:checkAvatarBtn];
    [checkAvatarBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.avatarImgView.userInteractionEnabled = YES;
}

- (void)dealloc {
    [ZLNotiCenter removeObserver:self name:TYWJPhotoSelectedSuccessNoti object:nil];
}


- (void)setPlist:(TYWJPersonalInfoPlist *)plist {
    _plist = plist;
    
    self.titleLabel.text = plist.title;
    self.arrowImgView.hidden = !plist.isShowArrow;
    self.infoTF.hidden = !plist.isShowInfo;
    self.infoTF.userInteractionEnabled = plist.isInfoEnable;
    self.chooseGenderTF.hidden = !plist.isShowChooseGender;
    self.avatarImgView.hidden = !plist.isShowAvatar;
    if ([TYWJLoginTool sharedInstance].avatarImg) {
        self.avatarImgView.image = [TYWJLoginTool sharedInstance].avatarImg;
    }
}

- (void)setInfo:(NSString *)info {
    _info = info;
    self.infoTF.text = info;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""] && textField.text.length > 0) {
        if (textField.text.length == 1) {
            [TYWJLoginTool sharedInstance].nickname = @"";
            return YES;
        }
        [TYWJLoginTool sharedInstance].nickname = [textField.text substringToIndex:textField.text.length - 1];
        return YES;
    }else {
        [TYWJLoginTool sharedInstance].nickname = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [TYWJLoginTool sharedInstance].nickname = @"";
    return YES;
}

#pragma mark - 照片选择成功

- (void)photoSelctedSuccess:(NSNotification *)noti {
    UIImage *img = [noti object];
    if (self.plist.isShowAvatar) {
        self.avatarImgView.image = img;
        [TYWJLoginTool sharedInstance].avatarImg = img;
    }
}

- (void)btnClicked:(UIButton *)sender {
    if (self.checkAvatarClicked) {
        self.checkAvatarClicked(self.avatarImgView.image,sender);
    }
}
@end
