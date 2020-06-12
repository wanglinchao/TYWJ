//
//  TYWJDriverPassegerHeaderView.m
//  TYWJBus
//
//  Created by tywj on 2020/6/12.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJDriverPassegerHeaderView.h"
#import "TYWJPassengerInfo.h"
@interface TYWJDriverPassegerHeaderView ()
{
    CGRect tempframe;
}
@property (weak, nonatomic) IBOutlet UILabel *checkInfoL;
@end
@implementation TYWJDriverPassegerHeaderView


-(void)confirgCellWithParam:(id)Param{
    NSDictionary *dic = (NSDictionary *)Param;
    self.checkInfoL.text = [NSString stringWithFormat:@"验票/乘客数：%@/%@",[dic objectForKey:@"inspect_num"],[dic objectForKey:@"passenger_num"]];
}
@end

