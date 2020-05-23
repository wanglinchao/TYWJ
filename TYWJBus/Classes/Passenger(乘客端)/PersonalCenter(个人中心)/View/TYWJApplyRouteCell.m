//
//  TYWJApplyRouteCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/15.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJApplyRouteCell.h"
#import "TYWJApplyRoute.h"


NSString * const TYWJApplyRouteCellID = @"TYWJApplyRouteCellID";

@interface TYWJApplyRouteCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *separator;


@end

@implementation TYWJApplyRouteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupView];
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setRoute:(TYWJApplyRoute *)route {
    _route = route;
    
    if (!route) return;
    
    self.tipsLabel.text = route.title;
    self.detailLabel.text = route.body;
    self.iconImgView.image = [UIImage imageNamed:route.img];
}
@end
