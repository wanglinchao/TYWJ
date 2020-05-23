//
//  ZLCalendarCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/16.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "ZLCalendarCell.h"

NSString * const ZLCalendarCellID = @"ZLCalendarCellID";

@interface ZLCalendarCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *boughtLabel;
/* 选中的动画view */
@property (strong, nonatomic) UIView *selectedView;


@end

@implementation ZLCalendarCell

#pragma mark - 懒加载

- (UIView *)selectedView {
    if (!_selectedView) {
        _selectedView = [[UIView alloc] init];
        _selectedView.zl_size = CGSizeMake(10.f, 5.f);
        _selectedView.zl_centerX = self.zl_width/2.f;
        _selectedView.zl_centerY = self.zl_height/2.f;
        _selectedView.backgroundColor = ZLNavTextColor;
        [_selectedView setRoundView];
    }
    return _selectedView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.backgroundColor = ZLGlobalBgColor;
}

- (void)selectCellWithStatus:(BOOL)isSelected {
    if (isSelected) {
        [self.contentView insertSubview:self.selectedView belowSubview:self.titleLabel];
        [UIView animateWithDuration:0.45f animations:^{
            self.selectedView.zl_width = self.zl_width;
            self.selectedView.zl_height = self.zl_height - 2.f;
            self.selectedView.zl_centerX = self.zl_width/2.f;
            self.selectedView.zl_centerY = self.zl_height/2.f;
            [self.selectedView setRoundViewWithCornerRaidus:6.f];
        } completion:nil];
    }else {
        [UIView animateKeyframesWithDuration:0.45f delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            self.selectedView.zl_width = 5.f;
            self.selectedView.zl_height = 5.f;
            self.selectedView.zl_centerX = self.zl_width/2.f;
            self.selectedView.zl_centerY = self.zl_height/2.f;
        } completion:^(BOOL finished) {
            [self.selectedView removeFromSuperview];
            self.selectedView = nil;
        }];
    }
}

- (void)disableCell {
    self.subTitleLabel.hidden = YES;
    self.boughtLabel.hidden = YES;
    self.titleLabel.textColor = [UIColor lightGrayColor];
    
}

@end
