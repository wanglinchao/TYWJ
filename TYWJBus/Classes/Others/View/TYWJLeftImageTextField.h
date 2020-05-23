//
//  TYWJLeftImageTextField.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYWJLeftImageTextField : UIView

/* 是否有下面的那根分割线 */
@property (assign, nonatomic) BOOL hasSeparatorLine;
/* tf */
@property (weak, nonatomic) UITextField *textField;
@property (assign, nonatomic) NSUInteger maxlength;

- (void)setIcon:(NSString *)icon placeholder:(NSString *)placeholder isPwd:(BOOL)isPwd;
- (void)setKeyboardType:(UIKeyboardType)keyboardType;


@end
