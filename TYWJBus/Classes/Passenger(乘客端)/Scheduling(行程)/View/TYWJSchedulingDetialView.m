//
//  TYWJSchedulingDetialView.m
//  TYWJBus
//
//  Created by tywj on 2020/5/29.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJSchedulingDetialView.h"
@interface TYWJSchedulingDetialView ()
@property (weak, nonatomic) IBOutlet UILabel *idNumL;
@property (weak, nonatomic) IBOutlet UILabel *stateL;
@property (weak, nonatomic) IBOutlet UILabel *carNumL;
@property (weak, nonatomic) IBOutlet UILabel *idL;
@property (strong, nonatomic) TYWJSchedulingStationView *schedulingStationView;
@property (weak, nonatomic) IBOutlet UILabel *carL;
@end
@implementation TYWJSchedulingDetialView
- (void)drawRect:(CGRect)rect {

}
- (IBAction)handleBtnAction:(UIButton *)sender {
    if (self.buttonSeleted)
    {
        self.buttonSeleted(sender.tag);
    }
}
- (void)confirgViewWithModel:(TYWJTripList *)model{
    self.carNumL.text = [NSString stringWithFormat:@"%@",model.vehicle_no];
    self.schedulingStationView = [[TYWJSchedulingStationView alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth, 300)];
    [self.stationView addSubview: self.schedulingStationView ];
    [self.schedulingStationView confirgViewWithModel:model];
}
- (void)setStateValue:(NSInteger)stateValue{
    //0验票1已退款2.未使用3.已转让4.已过期
    switch (stateValue) {
        case 0:
        {
            self.idL.textColor = kMainBlackColor;
            self.idNumL.textColor = kMainBlackColor;
            self.carL.textColor = kMainBlackColor;
            self.carNumL.textColor = kMainBlackColor;
            self.stateL.textColor = kMainGreenColor;
            self.stateL.text = @"已验票";
            
        }
            break;
        case 1:
        {
            self.stateL.textColor = kMainRedColor;
            self.stateL.text = @"已退款";
            
        }
            break;
        case 2:
        {
            self.idL.textColor = kMainBlackColor;
            self.idNumL.textColor = kMainBlackColor;
            self.carL.textColor = kMainBlackColor;
            self.carNumL.textColor = kMainBlackColor;
            self.stateL.textColor = kMainBlackColor;
            self.stateL.text = @"未使用";
            
        }
            break;
        case 3:
        {
            self.stateL.text = @"已转让";
            
        }
            break;
        case 4:
        {
            self.stateL.text = @"已过期";
            
        }
            break;
            
        default:
            break;
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

