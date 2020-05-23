//
//  TYWJCommuteHeaderView.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/29.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const TYWJCommuteHeaderViewH;

@class TYWJBanerModel;
@interface TYWJCommuteHeaderView : UIView

/* 上车地点 点击 */
@property (copy, nonatomic) void(^getupBtnClicked)(void);
/* 下车地点 点击 */
@property (copy, nonatomic) void(^getdownBtnClicked)(void);
/* 搜索按钮点击 */
@property (copy, nonatomic) void(^searchBtnClicked)(void);
/* 交换按钮点击 */
@property (copy, nonatomic) void(^switchBtnClicked)(void);

- (void)setGetupText:(NSString *)text;
- (void)setGetdownText:(NSString *)text;

- (NSString *)getGetupText;
- (NSString *)getGetdownText;

/* 是否显示阴影 */
@property (assign, nonatomic, getter=isShowShadow) BOOL showShadow;
/* getupPlaceholder */
@property (copy, nonatomic) NSString *getupPlaceholder;
/* getdownPlaceholder */
@property (copy, nonatomic) NSString *getdownPlaceholder;

@end
