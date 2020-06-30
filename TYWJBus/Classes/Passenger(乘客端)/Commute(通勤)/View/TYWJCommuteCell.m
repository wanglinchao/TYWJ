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
    NSString *str1 = [NSString stringWithFormat:@"￥%0.2f起",routeListInfo.price.floatValue/100];
        self.tipsLabel.textColor = [UIColor lightGrayColor];
    NSMutableAttributedString *abc1 = [[NSMutableAttributedString alloc] initWithString:str1];
    [abc1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(str1.length - 1, 1)];
    [abc1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:NSMakeRange(str1.length - 1, 1)];

    self.priceLabel.attributedText = abc1;
//    self.priceLabel.text = [NSString stringWithFormat:@"￥ %0.2f起",routeListInfo.price.floatValue/100];
    [self.ticketBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.ticketBtn setBackgroundColor:[UIColor redColor]];
        self.tipsLabel.textColor = [UIColor lightGrayColor];
    NSMutableAttributedString *abc = [[NSMutableAttributedString alloc] initWithString:routeListInfo.name];

    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    if (routeListInfo.type == 2) {
            attch.image = [UIImage imageNamed:@"标签_推荐"];

    } else if (routeListInfo.type == 1){
        attch.image = [UIImage imageNamed:@"标签_常用"];

    }
    attch.bounds = CGRectMake(5, -10, 45, 26);
    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
    
    [abc appendAttributedString:imageStr];
    self.routeNameLabel.attributedText = abc;
    self.tipsLabel.text = routeListInfo.note;
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
