//
//  TYWJOnlineFeedback.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/19.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJOnlineFeedback.h"
#import "TYWJBorderButton.h"
#import "TYWJTextVeiw.h"


@interface TYWJOnlineFeedback()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet TYWJTextVeiw *tv;
@property (weak, nonatomic) IBOutlet TYWJBorderButton *commitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commitTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewH;


@end

@implementation TYWJOnlineFeedback

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.commitButton setBorderColor:ZLNavTextColor];
    
    self.backgroundColor = ZLGlobalBgColor;
    
    if (ZLScreenHeight == 568) {
        self.commitTop.constant = 20.f;
        self.contentViewH.constant = 130.f;
    }else {
        self.commitTop.constant = 50.f;
        self.contentViewH.constant = 165.f;
    }
    
    self.tv.phText = @"您的建议和反馈是我们前进的动力";
}



- (void)addTarget:(id)target action:(SEL)action {
    [self.commitButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.commitButton setRoundViewWithCornerRaidus:8.f];
}


@end
