//
//  TYWJBottomBtnView.m
//  TYWJBus
//
//  Created by tywj on 2020/5/29.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJBottomBtnView.h"
#import "TYWJBorderButton.h"
@implementation TYWJBottomBtnView


- (void)drawRect:(CGRect)rect {
    // Drawing code

}
- (void)handleBtnAction:(UIButton *)sender{
    if (self.buttonSeleted)
       {
           self.buttonSeleted(sender.tag);
       }
}
- (void)setTitleArr:(NSArray *)titleArr{
    _titleArr = titleArr;
    NSInteger num = _titleArr.count;
    float margin = 10;
    float btnWith = (self.zl_width - margin*(num+1))/num;
    for (int i = 0 ; i < num ; i ++) {
        TYWJBorderButton *btn = [[TYWJBorderButton alloc] init];
        btn.frame = CGRectMake(margin + i*(margin +btnWith), margin, btnWith, self.zl_height - 20);
        btn.tag = 200 + i;
        [btn addTarget:self action:@selector(handleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[_titleArr objectAtIndex:i] forState:UIControlStateNormal];
        [btn setRoundViewWithCornerRaidus:(self.zl_height - 20)/2];
        [self addSubview:btn];
    }
}
@end
