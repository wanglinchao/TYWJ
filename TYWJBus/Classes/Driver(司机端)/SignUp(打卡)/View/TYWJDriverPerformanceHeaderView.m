//
//  TYWJDriverPerformanceHeaderView.m
//  TYWJBus
//
//  Created by MacBook on 2018/12/28.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJDriverPerformanceHeaderView.h"
#import "TYWJBonus.h"

@interface TYWJDriverPerformanceHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;

@end

@implementation TYWJDriverPerformanceHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.monthLabel.text = @"";
    self.todayLabel.text = @"";
}


- (void)setBonus:(TYWJBonus *)bonus {
    _bonus = bonus;
    
    CGFloat m = 0;
    for (TYWJBonusInfo *info in bonus.bonus) {
        m += info.amount.floatValue;
    }
    self.todayLabel.text = [NSString stringWithFormat:@"¥%.1f",m];
    self.monthLabel.text = [NSString stringWithFormat:@"¥%@",bonus.monthSum];
    
//    if (!bonus.bonus.count) {
//        [MBProgressHUD zl_showError:@"当日无绩效数据"];
//    }
}
@end
