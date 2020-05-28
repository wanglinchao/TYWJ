//
//  TYWJPersonalInfoCell.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/11.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJPersonalInfoPlist;

UIKIT_EXTERN NSString * const TYWJPersonalInfoCellID;

@interface TYWJPersonalInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UITextField *infoTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMargin;

/* checkAvatarClicked */
@property (copy, nonatomic) void(^checkAvatarClicked)(UIImage *img,UIButton *sender);
/* info */
@property (copy, nonatomic) NSDictionary *info;
@end
