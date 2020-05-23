//
//  TYWJITCategoryCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/25.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJITCategoryCell.h"

NSString * const TYWJITCategoryCellID = @"TYWJITCategoryCellID";

@interface TYWJITCategoryCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *borderLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleNumLabel;


@end

@implementation TYWJITCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupView];
}

- (void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.imgView setRoundViewWithCornerRaidus:3.f];
    [self.borderLabel setRoundView];
    [self.borderLabel setBorderWithColor: ZLColorWithRGB(58.f, 174.f, 85.f)];
    self.borderLabel.textColor = ZLColorWithRGB(58.f, 174.f, 85.f);
}

@end
