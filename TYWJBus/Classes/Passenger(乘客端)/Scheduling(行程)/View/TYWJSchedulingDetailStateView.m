//
//  TYWJSchedulingDetailStateView.m
//  TYWJBus
//
//  Created by tywj on 2020/5/29.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJSchedulingDetailStateView.h"
#import "TYWJBottomBtnView.h"
#import "TYWJSchedulingStationView.h"
@implementation TYWJSchedulingDetailStateView
- (void)drawRect:(CGRect)rect {
    // Drawing code
    TYWJSchedulingStationView *stationView = [[[NSBundle mainBundle] loadNibNamed:@"TYWJSchedulingStationView" owner:self options:nil] lastObject];
    [stationView hiddenView];
    [self.view2 addSubview:stationView];
    self.zl_y = ZLScreenHeight - self.zl_height -kNavBarH;
    TYWJBottomBtnView *view = [[TYWJBottomBtnView alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth, self.buttonView.zl_height)];
    view.titleArr = @[@"车票转让",@"扫码验票"];
    view.buttonSeleted = ^(NSInteger index) {
        switch (index -200) {
            case 0:
                
                break;
                
            default:
                break;
        }
    };
    [self.buttonView addSubview:view];
}
- (IBAction)open:(UIButton *)sender {
    BOOL open = sender.isSelected;
    sender.selected = !open;
    [UIView animateWithDuration:0.3 animations:^{
            if (!open) {
            self.height1.constant = 0;
            self.view1.hidden = YES;
            self.height2.constant = 0;
            self.view2.hidden = YES;
            self.height3.constant = 0;
            self.view3.hidden = YES;
            self.zl_y += 182;
            self.zl_height -= 182;
        } else {
            self.height1.constant = 50;
            self.view1.hidden = NO;
            self.height2.constant = 102;
            self.view2.hidden = NO;
            self.height3.constant = 30;
            self.view3.hidden = NO;
            self.zl_y -= 182;
            self.zl_height += 182;
        }
    }];
}
@end
