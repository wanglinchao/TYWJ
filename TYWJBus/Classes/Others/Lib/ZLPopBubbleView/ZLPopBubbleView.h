//
//  ZLPopBubbleView.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/20.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ZLPopBubbleViewDirectionError = 0,
    ZLPopBubbleViewDirectionTop = 1001,
    ZLPopBubbleViewDirectionBottom
} ZLPopBubbleViewDirection;

@interface ZLPopBubbleView : UIView

/* 要显示的view */
@property (strong, nonatomic) UIView *showingView;
/* 箭头显示坐标 */
@property (assign, nonatomic) CGFloat arrowPointX;
/* view显示的方向，暂时只有上下两个方向 */
@property (assign, nonatomic) ZLPopBubbleViewDirection direction;
/* popBubble view的颜色 */
@property (strong, nonatomic) UIColor *viewColor;
/* 内容view */
@property (strong, nonatomic) UIView *contentView;
@end
