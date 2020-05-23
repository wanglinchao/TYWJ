//
//  TYWJCombineTextButton.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYWJCombineTextButton : UIView

/* 按钮是文字是否有下划线 */
@property (assign, nonatomic) BOOL hasUnderLine;
/* 按钮点击 */
@property (copy, nonatomic) void(^btnClicked)(void);

- (void)setTips:(NSString *)tips protocol:(NSString *)protocol;

@end
