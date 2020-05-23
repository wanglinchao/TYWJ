//
//  TYWJIndependentTravelCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/20.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJIndependentTravelCell.h"
#import "TYWJTipsLabel.h"
#import "CDZStarsControl.h"


NSString * const TYWJIndependentTravelCellID = @"TYWJIndependentTravelCellID";

@interface TYWJIndependentTravelCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *starsView;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

/* tipsLabel */
@property (strong, nonatomic) TYWJTipsLabel *tipsLabel;

@end


@implementation TYWJIndependentTravelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.imgView setRoundViewWithCornerRaidus:3.f];
    
    _tipsLabel = [TYWJTipsLabel tipsLabelWithFrame:CGRectMake(15.f, 0, 55.f, 20.f)];
    _tipsLabel.backgroundColor = ZLNavTextColor;
    _tipsLabel.text = @"自由行";
    [self.imgView addSubview:_tipsLabel];
    
    self.originalPriceLabel.text = @"";
    self.originalPriceLabel.attributedText = [self.originalPriceLabel.text crossLine];
    
    self.starsView.backgroundColor = [UIColor clearColor];
    CDZStarsControl *starControl = [[CDZStarsControl alloc] initWithFrame:self.starsView.bounds stars:5 starSize:CGSizeMake(self.starsView.zl_width/5.f, self.starsView.zl_height - 5.f) noramlStarImage:[UIImage imageNamed:@"star_normal"] highlightedStarImage: [UIImage imageNamed:@"star_highlighted"]];
    starControl.enabled = NO;
    starControl.allowFraction = YES;
    starControl.score = 4.5;
    [self.starsView addSubview:starControl];
    
}

@end
