//
//  TYWJHomeHeaderView.m
//  TYWJBus
//
//  Created by tywj on 2020/5/21.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJHomeHeaderView.h"

@implementation TYWJHomeHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        self.frame = frame;
        if ([TYWJCommonTool sharedTool].currentSysVersion.floatValue < 11) {
            self.topHeight.constant = 30;
        } else {
            self.topHeight.constant = 0;
            
        }
    }    
    return self;
}
- (IBAction)leftAction:(id)sender {
    if (self.buttonSeleted)
    {
        self.buttonSeleted(0);
    }
}
- (void)showMessage:(BOOL)show{
    if (show) {
        self.meassageViewHeight.constant = 40;
    }else{
        self.meassageViewHeight.constant = 0;
    }
}

- (IBAction)rightAction:(UIButton *)sender {
    if (self.buttonSeleted)
    {
        self.buttonSeleted(1);
    }
}


@end
