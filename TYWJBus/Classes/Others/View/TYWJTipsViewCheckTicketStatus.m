//
//  TYWJTipsViewCheckTicketStatus.m
//  TYWJBus
//
//  Created by tywj on 2020/7/8.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJTipsViewCheckTicketStatus.h"
@interface TYWJTipsViewCheckTicketStatus ()
@property (weak, nonatomic) IBOutlet UILabel *numL;
@property (weak, nonatomic) IBOutlet UILabel *vehicle_noL;

@end
@implementation TYWJTipsViewCheckTicketStatus

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)handleAction:(UIButton *)sender {
    if (self.buttonSeleted)
    {
        self.buttonSeleted(sender.tag);
    }
}
- (void)confirgCellWithParam:(id)Param{
    NSDictionary *dic = (NSDictionary *)Param;
    self.numL.text = [NSString stringWithFormat:@"乘客数：%@人",[dic objectForKey:@"people"]];
    self.vehicle_noL.text = [NSString stringWithFormat:@"车牌号:%@",[dic objectForKey:@"vehicle_no"]];
}
@end
