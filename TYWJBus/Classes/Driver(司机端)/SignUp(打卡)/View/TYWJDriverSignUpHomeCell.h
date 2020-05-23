//
//  TYWJDriverSignUpHomeCell.h
//  TYWJBus
//
//  Created by MacBook on 2018/12/11.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJTripsModel;


UIKIT_EXTERN NSString * const TYWJDriverSignUpHomeCellID;

NS_ASSUME_NONNULL_BEGIN

@interface TYWJDriverSignUpHomeCell : UITableViewCell

/* TYWJTripsModel */
@property (strong, nonatomic) TYWJTripsModel *trip;
@property (weak, nonatomic, readonly) IBOutlet TYWJBorderButton *signInBtn;
/* 打卡点击 */
@property (copy, nonatomic) void(^mSignInClicked)(TYWJTripsModel *trip);

@end

NS_ASSUME_NONNULL_END
