//
//  TYWJCommuteCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/29.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJCommuteCell.h"
#import "TYWJBorderButton.h"
#import "TYWJRouteList.h"



CGFloat const TYWJCommuteCellH = 135.f;
NSString * const TYWJCommuteCellID = @"TYWJCommuteCellID";

@interface TYWJCommuteCell()

@property (weak, nonatomic) IBOutlet UIView *tipsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsViewH;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *boughtImageView;
@property (weak, nonatomic) IBOutlet UILabel *routeNameLabel;


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stationLabel;

@property (weak, nonatomic) IBOutlet TYWJBorderButton *ticketBtn;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *routeCategoryImg;

@end

@implementation TYWJCommuteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupView];
    ZLFuncLog;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    [self setRoundViewWithCornerRaidus:6.f];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UILabel *boughtLabel = [[UILabel alloc] init];
    boughtLabel.frame = self.boughtImageView.bounds;
    boughtLabel.textColor = [UIColor whiteColor];
    boughtLabel.font = [UIFont systemFontOfSize:10.f];
    boughtLabel.textAlignment = NSTextAlignmentCenter;
    boughtLabel.text = @"买过";
    [self.boughtImageView addSubview:boughtLabel];
}

#pragma mark - 按钮点击

- (IBAction)purchaseClicked:(id)sender {
    ZLFuncLog;
    if (self.buyClicked) {
        self.buyClicked(self.routeListInfo);
    }
//    [TYWJCommonTool pushToVc:buyTicketVc];
}

- (void)setRouteListInfo:(TYWJRouteListInfo *)routeListInfo {
    _routeListInfo = routeListInfo;
    
    self.stationLabel.text = [NSString stringWithFormat:@"%@——%@",routeListInfo.startingStop,routeListInfo.stopStop];
    self.timeLabel.text = [NSString stringWithFormat:@"￥ %0.2f",routeListInfo.price.floatValue];
    [self.ticketBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (routeListInfo.oriPrice && ![routeListInfo.oriPrice isEqualToString:@""]) {
//        self.originalPriceLabel.hidden = NO;
        self.originalPriceLabel.attributedText = [[NSString stringWithFormat:@"¥%@",routeListInfo.oriPrice] crossLine];
    }else {
        self.originalPriceLabel.hidden = YES;
    }
    self.routeNameLabel.text = routeListInfo.routeName;
    
    if ([routeListInfo.type isEqualToString:@"DeliciousFoodLine"]) {
        self.routeCategoryImg.image = [UIImage imageNamed:@"icon_card_food-line"];
    }else {
        self.routeCategoryImg.image = [UIImage imageNamed:@"icon_card_through train"];
        self.tipsLabel.textColor = [UIColor lightGrayColor];
        self.tipsLabel.text = @"轻松购买，方便出行";
        if ([routeListInfo.type isEqualToString:@"CommuteLine"]) {
            NSString *timeStr = [self.routeListInfo.startingTime componentsSeparatedByString:@"."].firstObject;
            if (timeStr.integerValue < 12) {
                self.tipsLabel.text = @"周一及节后首日提前十分钟发车";
                self.tipsLabel.textColor = [[UIColor redColor] colorWithAlphaComponent:0.75f];
            }
            
        }
    }
    
}

#pragma mark - layoutSubviews
- (void)setFrame:(CGRect)frame {
    CGFloat x = 0.f;
    CGFloat y = 10.f;
    frame.size.width = ZLScreenWidth - 2.f*x;
    frame.size.height = TYWJCommuteCellH - y;
    frame.origin.x = x;
    [super setFrame:frame];
}
@end
