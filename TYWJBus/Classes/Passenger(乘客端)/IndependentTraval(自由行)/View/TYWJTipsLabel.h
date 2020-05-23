//
//  TYWJTipsLabel.h
//  TYWJBus
//
//  Created by Harley He on 2018/7/20.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYWJTipsLabel : UIView

+ (instancetype)tipsLabelWithFrame:(CGRect)frame;

/* text */
@property (copy, nonatomic) NSString *text;
/* textColor */
@property (strong, nonatomic) UIColor *textColor;
/* font */
@property (strong, nonatomic) UIFont *font;
@end
