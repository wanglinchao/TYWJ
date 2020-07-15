//
//  TYWJCalendarCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/12.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJCalendarCell.h"


NSString * const TYWJCalendarCellID = @"TYWJCalendarCellID";
@interface TYWJCalendarCell ()
@end
@implementation TYWJCalendarCell


#pragma mark - setup view
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.zl_height = 426.f;
    //    NSCalendar
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    imageV.frame = CGRectMake(16, 17, 4, 16);
    imageV.backgroundColor = kMainYellowColor;
    [self addSubview:imageV];
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    tipsLabel.font = [UIFont systemFontOfSize:16.f];
    tipsLabel.textAlignment = NSTextAlignmentLeft;
    tipsLabel.frame = CGRectMake(32.f, 0, ZLScreenWidth - 20.f, 50.f);
    tipsLabel.text = @"车票日历（请选择乘车日期）";
    [self addSubview:tipsLabel];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(16, 50, ZLScreenWidth - 2* 16, self.zl_height - 50)];
    [self addSubview:contentView];
    
    
    
    
    self.calendarView = [[TYWJCalendarView alloc] initWithFrame:CGRectMake(0, 0, contentView.zl_width, contentView.zl_height - 46)];
    [contentView addSubview:self.calendarView];
    
    
    //    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, self.calendarView.zl_y + self.calendarView.zl_height, contentView.zl_width, 46)];
    //    bottomV.backgroundColor = [UIColor
    //                               greenColor];
    //    [contentView addSubview:bottomV];
    //    [contentView addSubview:self.calendarView];
}
-(void)confirgCellWithModel:(id)model{
    [self.calendarView confirgCellWithModel:model];
}





@end
