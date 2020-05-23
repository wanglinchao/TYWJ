//
//  ZLShiftView.m
//  TYWJBus
//
//  Created by MacBook on 2018/12/12.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "ZLShiftView.h"


@interface ZLShiftView()

/* leftButton */
@property (strong, nonatomic) UIButton *leftButton;
/* rightButton */
@property (strong, nonatomic) UIButton *rightButton;

@end

@implementation ZLShiftView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)shiftViewWithFrame:(CGRect)frame {
    ZLShiftView *shiftView = [[ZLShiftView alloc] initWithFrame:frame];
    shiftView.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, shiftView.zl_width/2.f, shiftView.zl_height)];
    shiftView.backgroundColor = [UIColor whiteColor];
    
    [shiftView.leftButton setTitleColor:ZLNavTextColor forState:UIControlStateSelected];
    [shiftView.leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    shiftView.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(shiftView.zl_width/2.f, 0, shiftView.zl_width/2.f, shiftView.zl_height)];
    [shiftView.rightButton setTitleColor:ZLNavTextColor forState:UIControlStateSelected];
    [shiftView.rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    shiftView.leftButton.selected = YES;
    shiftView.rightButton.selected = NO;
    
    [shiftView.leftButton addTarget:shiftView action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [shiftView.rightButton addTarget:shiftView action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [shiftView addSubview:shiftView.leftButton];
    [shiftView addSubview:shiftView.rightButton];
    
    return shiftView;
}

#pragma mark - 外部方法

- (void)setLeftTitle:(NSString *)lTitle rightTitle:(NSString *)rTitle {
    [self.leftButton setTitle:lTitle forState:UIControlStateNormal];
    [self.rightButton setTitle:rTitle forState:UIControlStateNormal];
}



#pragma mark - 按钮点击

- (void)leftBtnClicked {
    ZLFuncLog;
    self.rightButton.selected = NO;
    self.leftButton.selected = YES;
    if (self.leftBClicked) {
        self.leftBClicked();
    }
}

- (void)rightBtnClicked {
    ZLFuncLog;
    self.leftButton.selected = NO;
    self.rightButton.selected = YES;
    if (self.rightBClicked) {
        self.rightBClicked();
    }
}

@end
