//
//  TYWJChangeNumsView.m
//  TYWJBus
//
//  Created by MacBook on 2018/8/13.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJChangeNumsView.h"

@interface TYWJChangeNumsView()

@property (weak, nonatomic) IBOutlet UILabel *numsTF;

@end

static int const kMaxPersons = 10;

@implementation TYWJChangeNumsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.numsTF setBorderWithColor:ZLNavTextColor];
    
}

- (IBAction)plusClicked:(id)sender {
    ZLFuncLog;
    if (self.numsTF.text.intValue >= kMaxPersons) {
        [MBProgressHUD zl_showAlert:@"不能再多了!" afterDelay:1.5f];
        return;
    }
    int nums = self.numsTF.text.intValue;
    [ZLNotiCenter postNotificationName:TYWJTicketNumsDidChangeNoti object:@(nums + 1)];
}


- (IBAction)minusClicked:(id)sender {
    ZLFuncLog;
    if (self.numsTF.text.intValue < 2) {
        [MBProgressHUD zl_showAlert:@"不能再少了!" afterDelay:1.5f];
        return;
    }
    
    int nums = self.numsTF.text.intValue;
    [ZLNotiCenter postNotificationName:TYWJTicketNumsDidChangeNoti object:@(nums - 1)];
}

- (void)setTFText:(NSString *)text {
    if (text) {
        self.numsTF.text = text;
    }
}

@end
