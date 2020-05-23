//
//  TYWJITNotiContentView.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJITNotiContentView.h"


@interface TYWJITNotiContentView()

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *bodyTV;


@end

@implementation TYWJITNotiContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)addTarget:(id)target action:(SEL)action {
    [self.sureBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
