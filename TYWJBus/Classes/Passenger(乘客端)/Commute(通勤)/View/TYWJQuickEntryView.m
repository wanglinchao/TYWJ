//
//  TYWJQuickEntryView.m
//  TYWJBus
//
//  Created by tywj on 2019/11/21.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import "TYWJQuickEntryView.h"

@implementation TYWJQuickEntryView

+ (instancetype)quickEntryView
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        
    }
    
    return self;
}

- (IBAction)busButtonClicked:(UIButton *)sender {
    if (self.busBtnClicked) {
        self.busBtnClicked();
    }
}

- (IBAction)tourButtonClicked:(UIButton *)sender {
    if (self.tourBtnClicked) {
        self.tourBtnClicked();
    }
}
@end
