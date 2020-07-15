//
//  TYWJAchievementHeaderView.m
//  TYWJBus
//
//  Created by tywj on 2020/6/12.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJAchievementHeaderView.h"
@interface TYWJAchievementHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *amountL;

@end

@implementation TYWJAchievementHeaderView
- (void)confirgCellWithParam:(id)Param{
    
    NSDictionary *dic = (NSDictionary *)Param;
    
    
    self.amountL.text = [TYWJCommonTool getPriceStringWithMount:[[dic objectForKey:@"starlight_usable_amount"] intValue]];
    
    
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
