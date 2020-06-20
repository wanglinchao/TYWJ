//
//  TYWJChooseUserTypeWindow.m
//  TYWJBus
//
//  Created by tywj on 2020/6/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJChooseUserTypeWindow.h"
#import "TYWJChooseUserTypeView.h"
static TYWJChooseUserTypeWindow *singleInstance;
@interface TYWJChooseUserTypeWindow ()
@property (strong, nonatomic)TYWJChooseUserTypeView *chooseUserTypeView;
@end
@implementation TYWJChooseUserTypeWindow

-(instancetype)init
{
    if (self = [super initWithFrame:CGRectMake(60, kNavBarH - 44, ZLScreenWidth - 120, 44)]) {
        self.windowLevel = UIWindowLevelAlert - 1;
        self.chooseUserTypeView = [[TYWJChooseUserTypeView alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth - 120, 44)];
        [self.chooseUserTypeView chooseType:NO];
        [self addSubview:self.chooseUserTypeView];
        
        singleInstance = self;
        
    }
    return self;
}
- (void)showWithAnimation{
    [self showWithAnimation:NO];
    
}
-(void)hideWithAnimation
{
    [self hideWithAnimation:NO];
}

- (void)showWithAnimation:(BOOL)animation
{
    [self makeKeyAndVisible];
    
    [UIView animateWithDuration:animation ? 0.3 : 0
                     animations:^{
    }
                     completion:^(BOOL finished) {
        
    }];
}

- (void)hideWithAnimation:(BOOL)animation
{
    
    [UIView animateWithDuration:animation ? 0.3 : 0
                     animations:^{
        self.alpha = 0;
    }
                     completion:^(BOOL finished) {
        singleInstance = nil;
        
    }];
}

- (void)dealloc
{
    [self resignKeyWindow];
}

@end
