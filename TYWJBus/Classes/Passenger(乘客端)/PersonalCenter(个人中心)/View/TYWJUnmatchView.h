//
//  TYWJUnmatchView.h
//  TYWJBus
//
//  Created by tywj on 2020/3/16.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJApplyListInfo;

NS_ASSUME_NONNULL_BEGIN

@interface TYWJUnmatchView : UIView
+ (instancetype)unmatchView;
- (instancetype)initWithFrame:(CGRect)frame;
@property (strong, nonatomic) TYWJApplyListInfo *applyListInfo;
@end

NS_ASSUME_NONNULL_END
