//
//  TYWJTipsController.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/25.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYWJTipsController : UIViewController

/* viewClicked */
@property (copy, nonatomic) void(^viewClicked)(BOOL isRegisterClicked);
- (void)setTips:(NSString *)tips leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle;
- (void)setSingleBtnWithTips:(NSString *)tips;

@end
