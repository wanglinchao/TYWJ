//
//  TYWJMyRouteCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/28.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJMyRouteCell.h"
#import "TYWJTicketList.h"
#import "TYWJPeirodTicket.h"


NSString * const TYWJMyRouteCellID = @"TYWJMyRouteCell";

@interface TYWJMyRouteCell()

@property (weak, nonatomic) IBOutlet UILabel *getupTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *stationLabel;
@property (weak, nonatomic) IBOutlet UILabel *getupStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *getdownStationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowIcon;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation TYWJMyRouteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupView];
}

- (void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.statusLabel setRoundViewWithCornerRaidus:3.f];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 10.f;
    frame.size.height -= 10.f;
    [super setFrame:frame];
}

- (void)setTicket:(TYWJTicketListInfo *)ticket {
    _ticket = ticket;
    
    [self setStatusLabelWithStatus:ticket.status];
    self.stationLabel.text = [NSString stringWithFormat:@"%@——%@",ticket.startStation,ticket.desStation];
    self.getupStationLabel.text = [NSString stringWithFormat:@"%@(%@)",ticket.beginStation,ticket.getupTime];
    self.getdownStationLabel.text = [NSString stringWithFormat:@"%@(%@)",ticket.endStation,ticket.getdownTime];
    self.getupTimeLabel.text = ticket.getupDate;
    self.timeLabel.text = ticket.getupTime;
    
}

- (void)setPeriodTicket:(TYWJPeriodDetailTicket *)periodTicket {
    _periodTicket = periodTicket;
    
    [self setStatusLabelWithStatus:periodTicket.status];
    
    self.stationLabel.text = [NSString stringWithFormat:@"购买日期:%@",periodTicket.purchaseDate];
    self.getupStationLabel.text = [NSString stringWithFormat:@"起始日期:%@",periodTicket.startDate];
    self.getdownStationLabel.text = [NSString stringWithFormat:@"到期日期:%@",periodTicket.endDate];
    self.getupTimeLabel.text = [NSString stringWithFormat:@"%@周期行程费",periodTicket.city];
    self.arrowIcon.hidden = YES;
}

- (void)setStatusLabelWithStatus:(NSString *)status {
    if ([status isEqualToString:@"待乘车"]) {
        self.statusLabel.backgroundColor = ZLColorWithRGB(255, 135, 36);
        self.statusLabel.textColor = [UIColor whiteColor];
        self.arrowIcon.hidden = NO;
    }else if ([status isEqualToString:@"待支付"]) {
        self.statusLabel.backgroundColor = ZLColorWithRGB(253, 208, 0);
        self.statusLabel.textColor = ZLGrayColorWithRGB(51);
        self.arrowIcon.hidden = YES;
    }else if ([status isEqualToString:@"已完成"] || [status isEqualToString:@"已乘车"]) {
        [self.statusLabel setBorderWithColor:ZLColorWithRGB(73, 207, 104)];
        self.statusLabel.backgroundColor = [UIColor clearColor];
        self.statusLabel.textColor = ZLColorWithRGB(73, 207, 104);
//        if ([status isEqualToString:@"已乘车"]) {
        self.arrowIcon.hidden = NO;
//        }else {
//            self.arrowIcon.hidden = YES;
//        }
    }else {
        [self.statusLabel setBorderWithColor: [UIColor grayColor]];
        self.statusLabel.backgroundColor = ZLGlobalBgColor;
        self.statusLabel.textColor = [UIColor grayColor];
        if ([status isEqualToString:@"已退款"]) {
            self.arrowIcon.hidden = YES;
        }else {
            self.arrowIcon.hidden = NO;
        }
    }
    self.statusLabel.text = status;
}
@end
