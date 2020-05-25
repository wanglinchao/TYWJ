//
//  TYWJSideHeaderView.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/24.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJUserBasicInfo;

@interface TYWJSideHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *uidLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowIcon;

/* userBasicInfo */
@property (strong, nonatomic) TYWJUserBasicInfo *userBasicInfo;

/* view点击 */
@property (copy, nonatomic) void(^viewClicked)(void);

@end
