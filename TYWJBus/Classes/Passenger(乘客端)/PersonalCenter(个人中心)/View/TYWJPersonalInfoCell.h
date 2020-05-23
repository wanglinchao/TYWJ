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

/* plist */
@property (strong, nonatomic) TYWJPersonalInfoPlist *plist;
/* info */
@property (copy, nonatomic) NSString *info;
/* checkAvatarClicked */
@property (copy, nonatomic) void(^checkAvatarClicked)(UIImage *img,UIButton *sender);

@end
