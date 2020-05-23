//
//  JXTextView.h
//  BTBTC
//
//  Created by thls on 2019/7/22.
//  Copyright © 2019 yjy361. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXTextView : UITextView
@property (nonatomic,strong) UIColor *placeholderColor;
@property (nonatomic,copy) UIFont *placeholderFont;
@property (nonatomic,copy) NSString *__nullable placeholder;
@end

NS_ASSUME_NONNULL_END
