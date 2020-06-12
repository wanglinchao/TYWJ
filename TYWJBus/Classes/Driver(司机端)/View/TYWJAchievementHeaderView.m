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
    self.monthAchievementL.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"month_achievement"]];
    self.dayAchievementL.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"month_achievement"]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
