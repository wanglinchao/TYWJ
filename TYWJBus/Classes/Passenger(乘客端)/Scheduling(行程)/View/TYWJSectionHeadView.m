//
//  TYWJSectionHeadView.m
//  TYWJBus
//
//  Created by tywj on 2020/5/28.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJSectionHeadView.h"
@implementation TYWJSectionHeadView
- (IBAction)handleBtnAction:(UIButton *)sender {
    if (self.buttonSeleted) {
        self.buttonSeleted();
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
