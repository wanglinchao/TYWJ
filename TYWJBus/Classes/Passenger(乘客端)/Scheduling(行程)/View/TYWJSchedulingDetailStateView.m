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
@interface TYWJSchedulingDetailStateView ()
@end
@implementation TYWJSchedulingDetailStateView
- (void)drawRect:(CGRect)rect {
    // Drawing code

}
- (void)confirgViewWithModel:(TYWJTripList *)model{
    self.line_name.text = model.line_name;
    self.line_time.text = [NSString stringWithFormat:@"%@    %@ (发车)",model.line_date,model.line_time];
    self.startL.text = [NSString stringWithFormat:@"预计%@    %@",model.geton_time,model.geton_loc];
    self.endL.text = [NSString stringWithFormat:@"预计%@    %@",model.getoff_time,model.getoff_loc];
    self.carNumL.text = [NSString stringWithFormat:@"车牌号:%@",model.vehicle_no];
    if (model.status == 1 || model.status == 2) {
        self.zl_height += 64;
    }
    [self setStateValue:model.status];
//    if (model.status == 2) {
//            self.zl_y = ZLScreenHeight - self.zl_height - kTabBarH + kNavBarH - 64;
//
//    }else{
        self.zl_y = ZLScreenHeight - self.zl_height - kTabBarH + kNavBarH;

//    }
    NSLog(@"%f---%f---%f",ZLScreenHeight ,self.zl_height,kTabBarH);
}

- (IBAction)refundAction:(UIButton *)sender {
    if (self.buttonSeleted)
    {
        self.buttonSeleted(sender.tag);
    }
}
- (void)addBottomBtnView{
    TYWJBottomBtnView *view = [[TYWJBottomBtnView alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth, self.buttonView.zl_height)];
    view.titleArr = @[@"扫码验票"];
    view.buttonSeleted = ^(NSInteger index) {
        if (self.buttonSeleted)
        {
            self.buttonSeleted(index);
        }
    };
    [self.buttonView addSubview:view];
    
}
- (void)setStateValue:(NSInteger)stateValue{
    //0.未出票1.待配车（调度中） 2.已配车（有车票号已分配） 3.已验票（已使用 ） 4.已过期(时间到期,客户未验票) 5.退票已受理 6. 已退票
    
    switch (stateValue) {
        case 0:
        {
            self.checkStateImage.image = [UIImage imageNamed:@""];
        }
            break;
        case 1:
        {
            self.checkStateImage.image = [UIImage imageNamed:@""];
            [self addBottomBtnView];

        }
            break;
        case 2:
        {
            self.checkStateImage.image = [UIImage imageNamed:@""];
            [self addBottomBtnView];

        }
            break;
        case 3:
        {
            self.checkStateImage.image = [UIImage imageNamed:@"行程_车票详情_已验票"];
        }
            break;
        case 4:
        {
            self.checkStateImage.image = [UIImage imageNamed:@"行程_车票详情_已过期"];
        }
            break;
            case 5:
            {
                self.checkStateImage.image = [UIImage imageNamed:@""];
            }
                break;
            case 6:
            {
                self.checkStateImage.image = [UIImage imageNamed:@"行程_车票详情_已退票"];
            }
                break;
        default:
            break;
    }
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
            self.zl_y += 162;
            self.zl_height -= 162;
        } else {
            self.height1.constant = 30;
            self.view1.hidden = NO;
            self.height2.constant = 112;
            self.view2.hidden = NO;
            self.height3.constant = 30;
            self.view3.hidden = NO;
            self.zl_y -= 162;
            self.zl_height += 162;
        }
    }];
}
@end
