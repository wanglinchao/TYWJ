//
//  TYWJQuickEntryView.h
//  TYWJBus
//
//  Created by tywj on 2019/11/21.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJQuickEntryView : UIView
/* 包车 点击 */
@property (copy, nonatomic) void(^busBtnClicked)(void);
/* 周边游 点击 */
@property (copy, nonatomic) void(^tourBtnClicked)(void);
+ (instancetype)quickEntryView;
- (instancetype)initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
