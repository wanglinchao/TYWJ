//
//  TYWJTextVeiw.m
//  TYWJBus
//
//  Created by MacBook on 2018/8/21.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJTextVeiw.h"

@interface TYWJTextVeiw()
/* placeholder */
@property (strong, nonatomic) UILabel *placeholder;

@end

@implementation TYWJTextVeiw

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addPlaceholder];
    
    [ZLNotiCenter addObserver:self selector:@selector(tvTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}


- (void)dealloc {
    [ZLNotiCenter removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}


- (void)addPlaceholder {
    UILabel *placeholder = [[UILabel alloc] init];
    placeholder.textColor = [UIColor lightGrayColor];
    placeholder.font = self.font;
    placeholder.textAlignment = NSTextAlignmentLeft;
    placeholder.frame = CGRectMake(3.f, 6.f, self.zl_width - 6.f, 20.f);
//    placeholder.text = @"您的建议和反馈是我们前进的动力";
    self.placeholder = placeholder;
    if (self.phText) {
        placeholder.text = self.phText;
    }
    [self addSubview:placeholder];
}


#pragma mark - UITextViewDelegate

- (void)tvTextDidChange:(NSNotification *)noti {
    UITextView *textView = noti.object;
    if (textView.text.length == 0) {
        self.placeholder.hidden = NO;
    }else {
        self.placeholder.hidden = YES;
    }
}


- (void)showPlaceholder {
    self.placeholder.hidden = NO;
}

- (void)setPhText:(NSString *)phText {
    _phText = phText;
    if (phText) {
        self.placeholder.text = phText;
    }
}

@end
