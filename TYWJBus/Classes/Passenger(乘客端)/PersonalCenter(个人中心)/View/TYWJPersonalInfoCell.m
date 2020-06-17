//
//  TYWJPersonalInfoCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/11.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJPersonalInfoCell.h"
#import "TYWJLoginTool.h"


NSString * const TYWJPersonalInfoCellID = @"TYWJPersonalInfoCellID";

@interface TYWJPersonalInfoCell()
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
    UIButton *checkAvatarBtn = [[UIButton alloc] init];
    checkAvatarBtn.frame = self.avatarImgView.bounds;
    [self.avatarImgView addSubview:checkAvatarBtn];
    [checkAvatarBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.avatarImgView.userInteractionEnabled = YES;
}

- (void)dealloc {
    [ZLNotiCenter removeObserver:self name:TYWJPhotoSelectedSuccessNoti object:nil];
}

//
//- (void)setPlist:(TYWJPersonalInfoPlist *)plist {
//    _plist = plist;
//    
//    self.titleLabel.text = plist.title;
//    self.arrowImgView.hidden = !plist.isShowArrow;
//    self.infoTF.hidden = !plist.isShowInfo;
//    self.infoTF.userInteractionEnabled = plist.isInfoEnable;
//    self.chooseGenderTF.hidden = !plist.isShowChooseGender;
//    self.avatarImgView.hidden = !plist.isShowAvatar;
//    if ([TYWJLoginTool sharedInstance].avatarString) {
//        self.avatarImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[TYWJLoginTool sharedInstance].avatarString]]];
//    } else {
//        self.avatarImgView.image = [UIImage imageNamed:@"icon_my_header"];
//    }
//}
- (void)setInfo:(NSDictionary *)info {
    _info = info;
    self.titleLabel.text = [info objectForKey:@"title"];
    self.arrowImgView.hidden = ![[info objectForKey:@"showArr"] boolValue];
    if ([[info objectForKey:@"showArr"] boolValue]) {
        self.rightMargin.constant = 45;
    }
    self.avatarImgView.hidden = ![[info objectForKey:@"showImage"] boolValue];
    self.infoTF.hidden = [[info objectForKey:@"showImage"] boolValue];
    self.infoTF.userInteractionEnabled = NO;
    self.infoTF.text = [info objectForKey:@"subTitle"];
    if ([[info objectForKey:@"showImage"] boolValue]) {
        if ([TYWJLoginTool sharedInstance].avatarString) {
            self.avatarImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[TYWJLoginTool sharedInstance].avatarString]]];
        } else {
            self.avatarImgView.image = [UIImage imageNamed:@"icon_my_header"];
        }
    }
}



#pragma mark - 照片选择成功

- (void)photoSelctedSuccess:(NSNotification *)noti {
    UIImage *img = [noti object];
    self.avatarImgView.image = img;
    if (self.getAvatarImage) {
        self.getAvatarImage(img);
    }
}

- (void)btnClicked:(UIButton *)sender {
    if (self.checkAvatarClicked) {
        self.checkAvatarClicked(self.avatarImgView.image,sender);
    }
}
@end
