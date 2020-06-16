//
//  TYWJBottomPurchaseView.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/12.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYWJBottomPurchaseView : UIView

/* 是否有tipslabel */
@property (assign, nonatomic, getter=isShowTips) BOOL showTips;

- (void)addTarget:(id)target action:(nonnull SEL)action;
- (void)setPrice:(NSString *)price;
- (void)setTipsWithNum:(NSInteger)num;
- (void)setTFText:(NSString *)text;
- (void)setTitle:(NSString *)title;
@end
