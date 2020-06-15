//
//  TYWJTipsViewRefunds.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/25.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYWJTipsViewRefunds : UIView

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *changePhoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (copy, nonatomic) void(^buttonSeleted)(NSInteger index);

@end
