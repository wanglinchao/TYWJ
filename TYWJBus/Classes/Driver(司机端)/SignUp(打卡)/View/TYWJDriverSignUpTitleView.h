//
//  TYWJDriverSignUpTitleView.h
//  TYWJBus
//
//  Created by MacBook on 2018/12/24.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJDriverSignUpTitleView : UIView

+ (instancetype)titleViewWithSize:(CGSize)size;

- (void)setTitle:(NSString *)title;
- (void)setDateTitle:(NSString *)title;

/* dateUpdated */
@property (copy, nonatomic) void(^dateUpdated)(NSString *selectedDate);

@end

NS_ASSUME_NONNULL_END
