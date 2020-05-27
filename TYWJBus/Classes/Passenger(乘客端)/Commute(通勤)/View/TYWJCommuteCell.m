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
@property (weak, nonatomic) IBOutlet UILabel *routeNameLabel;


@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *stationLabel;

@property (weak, nonatomic) IBOutlet TYWJBorderButton *ticketBtn;
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
    [self setRoundViewWithCornerRaidus:16.f];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - 按钮点击

- (IBAction)purchaseClicked:(id)sender {
    ZLFuncLog;
    if (self.buyClicked) {
        self.buyClicked(self.routeListInfo);
    }
}

- (void)setRouteListInfo:(TYWJRouteListInfo *)routeListInfo {
    _routeListInfo = routeListInfo;
    
    self.stationLabel.text = [NSString stringWithFormat:@"%@",routeListInfo.fied_name];
    self.priceLabel.text = [NSString stringWithFormat:@"￥ %0.2f",routeListInfo.price.floatValue];
    [self.ticketBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.routeNameLabel.text = routeListInfo.name;
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
