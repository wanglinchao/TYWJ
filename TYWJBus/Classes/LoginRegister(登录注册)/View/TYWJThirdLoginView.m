//
//  TYWJThirdLoginView.m
//  TYWJBus
//
//  Created by tywj on 2020/5/19.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJThirdLoginView.h"

@implementation TYWJThirdLoginView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)handleAction:(UIButton *)sender {
    if (self.buttonSeleted)
       {
           self.buttonSeleted(sender.tag);
       }
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"TYWJThirdLoginView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
    }
    return self;
}


@end
