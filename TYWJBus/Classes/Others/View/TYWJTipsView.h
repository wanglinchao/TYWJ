//
//  TYWJTipsView.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/25.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYWJTipsView : UIView

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *changePhoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

/* 更换手机号点击 */
@property (copy, nonatomic) void(^changePhoneNumClicked)(void);
/* 注册点击 */
@property (copy, nonatomic) void(^registerClicked)(void);

@end
