//
//  TYWJBaseView.m
//  TYWJBus
//
//  Created by tywj on 2020/6/12.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJBaseView.h"
@interface TYWJBaseView ()
{
    CGRect tempframe;
}
@end
@implementation TYWJBaseView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self=[[[NSBundle mainBundle]loadNibNamed:[NSString stringWithFormat:@"%@",[self class]] owner:nil options:nil] objectAtIndex:0];
        tempframe = frame;
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.frame = tempframe;
}
-(void)drawRect:(CGRect)rect
{
    self.frame = tempframe;
    // Drawing code
}

-(void)confirgCellWithParam:(id)Param{

}
@end
