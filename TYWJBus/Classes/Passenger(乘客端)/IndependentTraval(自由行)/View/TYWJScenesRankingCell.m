//
//  TYWJScenesRankingCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/20.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJScenesRankingCell.h"
#import "TYWJTipsLabel.h"

NSString * const TYWJScenesRankingCellID = @"TYWJScenesRankingCellID";

@interface TYWJScenesRankingCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIImageView *ranking;

/* rankingLabel */
@property (strong, nonatomic) TYWJTipsLabel *rankingLabel;

@end

@implementation TYWJScenesRankingCell

- (TYWJTipsLabel *)rankingLabel {
    if (!_rankingLabel) {
        _rankingLabel = [TYWJTipsLabel tipsLabelWithFrame:CGRectMake(15.f, 0, 55.f, 20.f)];
        _rankingLabel.backgroundColor = ZLColorWithRGB(252, 50, 57);
    }
    return _rankingLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupView];
}

- (void)setupView {
    [self.bgView addSubview:self.rankingLabel];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    [self.bgView setRoundViewWithCornerRaidus:8.f];
    self.shadowView.layer.shadowRadius = 8.f;
    self.shadowView.layer.shadowOpacity = 1.f;
    self.shadowView.layer.shadowOffset = CGSizeMake(-6.f, 15.f);
    self.shadowView.layer.shadowColor = ZLGrayColorWithRGB(225.f).CGColor;
    
    if (self.rankingImg) {
        self.ranking.hidden = NO;
        self.rankingLabel.hidden = YES;
        self.ranking.image = [UIImage imageNamed:self.rankingImg];
    }else {
        self.ranking.hidden = YES;
        self.rankingLabel.hidden = NO;
        self.rankingLabel.text = self.rankingTitle;
    }
    
}

- (void)setRankingImg:(NSString *)rankingImg {
    _rankingImg = [rankingImg copy];
    
    self.ranking.hidden = NO;
    self.rankingLabel.hidden = YES;
    self.ranking.image = [UIImage imageNamed:rankingImg];
}

- (void)setRankingTitle:(NSString *)rankingTitle {
    _rankingTitle = [rankingTitle copy];
    
    self.ranking.hidden = YES;
    self.rankingLabel.hidden = NO;
    self.rankingLabel.text = rankingTitle;
}
@end
