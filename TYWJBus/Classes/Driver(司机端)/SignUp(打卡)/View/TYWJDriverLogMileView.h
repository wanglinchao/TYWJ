//
//  TYWJDriverLogMileView.h
//  TYWJBus
//
//  Created by MacBook on 2018/12/13.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJDriverLogMileView : UIView

@property (weak, nonatomic, readonly) IBOutlet UILabel *tipsLabel;
/* 查看油耗记录点击 */
@property (copy, nonatomic) void(^checkoutMileageInfoClicked)(void);
/* confirmClicked */
@property (copy, nonatomic) void(^confirmClicked)(NSString *carLicense,NSString *mileage);
/* 选择车辆按钮点击 */
@property (copy, nonatomic) void(^chooseCarClicked)(void);

- (void)setCarLicense:(NSString *)license;

@end

NS_ASSUME_NONNULL_END
