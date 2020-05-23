//
//  TYWJPayCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/14.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJPayCell.h"
#import "TYWJRouteList.h"
#import "TYWJPeirodTicket.h"


NSString * const TYWJPayCellID = @"TYWJPayCellID";

@interface TYWJPayCell()

@property (weak, nonatomic) IBOutlet UILabel *stationLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *ticketNumTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalFeeLabel;

@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UIButton *weChatPayBtn;


@end

@implementation TYWJPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupView];
}

- (void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.alipayBtn.selected = YES;
    
    
}


#pragma mark - 按钮点击

- (IBAction)alipayClicked:(UIButton *)sender {
    ZLFuncLog;
    self.weChatPayBtn.selected = NO;
    sender.selected = YES;
}

- (IBAction)wechatPayClicked:(UIButton *)sender {
    ZLFuncLog;
    self.alipayBtn.selected = NO;
    sender.selected = YES;
}

- (IBAction)couponBtnClicked:(id)sender {
    if (self.couponClicked) {
        self.couponClicked();
    }
}

- (void)setTicketDates:(NSArray *)ticketDates {
    _ticketDates = ticketDates;
    
    NSString *dates = @"乘车日期:";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM.dd";
    NSInteger count = self.ticketDates.count;
    for (NSInteger i = 0; i < count; i++) {
        NSDate *date = self.ticketDates[i];
        if (0 == i) {
            dates = [dates stringByAppendingString:[NSString stringWithFormat:@" %@",[formatter stringFromDate:date]]];
        }
        else {
            dates = [dates stringByAppendingString:[NSString stringWithFormat:@"、%@",[formatter stringFromDate:date]]];
        }
    }
    self.dateLabel.text = [NSString stringWithFormat:@"%@", dates];
    
    if (_singleTicket) {
        _ticketNumTipsLabel.text = @"数量";
        _ticketNumLabel.text = [NSString stringWithFormat:@"%ld张",ticketDates.count*self.ticketNums];
    }
    else {
        NSString *month = [TYWJCommonTool sharedTool].nextMonth;
        NSString *year = [TYWJCommonTool sharedTool].nextYear;
        int days = [TYWJCommonTool sharedTool].nextMonthDays;

        _ticketNumTipsLabel.text = [NSString stringWithFormat:@"%@月份月行程费",month];
        _ticketNumLabel.text = @"一份";
        self.dateLabel.text = [NSString stringWithFormat:@"有效日期:%@-%@-01至%@-%@-%d",year,month,year,month,days];

    }
}

- (void)setDesStation:(NSString *)desStation {
    _desStation = desStation;
    
    self.stationLabel.text = [NSString stringWithFormat:@"%@——%@",_startStation,desStation];
}

- (void)setInfo:(TYWJRouteListInfo *)info {
    _info = [info copy];
    
    self.detailStationLabel.text = [NSString stringWithFormat:@"%@(%@)——%@(%@)",info.startingStop,info.startingTime,info.stopStop,info.stopTime];
}

- (void)setTotalFee:(NSString *)totalFee {
    _totalFee = totalFee;
    
    self.totalFeeLabel.text = totalFee;
}

- (void)setPeriodTicket:(TYWJPeriodTicketInfo *)periodTicket {
    _periodTicket = periodTicket;
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"yyyy.MM.dd";
//    NSString *today = [dateFormatter stringFromDate:[NSDate date]];
//
//    NSDate *Date_sub = [NSDate date];//格林尼治时间
//
//    NSTimeInterval interval = 60 * 60 * 24 * (self.periodTicket.days.integerValue - 1); //秒数
//    NSString *dueDateString = [dateFormatter stringFromDate:[Date_sub  initWithTimeInterval:interval sinceDate:Date_sub]];
    
//    self.dateLabel.text = [NSString stringWithFormat:@"有效期:%@-%@",today,dueDateString];
    self.stationLabel.text = periodTicket.title;
    self.dateLabel.hidden = YES;
    self.detailStationLabel.hidden = YES;
    self.ticketNumTipsLabel.text = periodTicket.title;
    _ticketNumLabel.text = @"一份";
}
@end
