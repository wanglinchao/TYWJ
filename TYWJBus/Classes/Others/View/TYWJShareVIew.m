//
//  TYWJShareVIew.m
//  TYWJBus
//
//  Created by tywj on 2020/6/6.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJShareVIew.h"
@interface TYWJShareVIew ()

{
    CGRect tempframe;
}

@end
@implementation TYWJShareVIew

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self=[[[NSBundle mainBundle]loadNibNamed:[NSString stringWithFormat:@"%@",[self class]] owner:nil options:nil] objectAtIndex:0];
        tempframe = frame;
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{
    self.frame = tempframe;
    

    // Drawing code
}
- (IBAction)handleAction:(UIButton *)sender {
    if (self.buttonSeleted)
       {
           self.buttonSeleted(sender.tag);
       }

}

@end
