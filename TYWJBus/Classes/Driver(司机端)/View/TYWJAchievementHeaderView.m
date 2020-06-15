//
//  TYWJAchievementHeaderView.m
//  TYWJBus
//
//  Created by tywj on 2020/6/12.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJAchievementHeaderView.h"
@interface TYWJAchievementHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *dayAchievementL;
@property (weak, nonatomic) IBOutlet UILabel *monthAchievementL;

@end

@implementation TYWJAchievementHeaderView
- (void)confirgCellWithParam:(id)Param{
    NSDictionary *dic = (NSDictionary *)Param;
    NSArray *day_achievement_list = [dic objectForKey:@"day_achievement_list"];
    int dayMoney = 0;
    if (day_achievement_list.count > 0) {
        for (NSDictionary *dic in day_achievement_list) {
            dayMoney += [[dic objectForKey:@"money"] intValue];

        }
        
    }
    self.dayAchievementL.text = [NSString stringWithFormat:@"%d",dayMoney];
    self.monthAchievementL.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"month_achievement"]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
