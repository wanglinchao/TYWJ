//
//  TYWJCheckCommentCell.m
//  TYWJBus
//
//  Created by MacBook on 2019/1/3.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import "TYWJCheckCommentCell.h"
#import "TYWJDriverComment.h"
#import "TYWJDriverComplaint.h"
#import "CDZStarsControl.h"


NSString * const TYWJCheckCommentCellID = @"TYWJCheckCommentCellID";


@interface TYWJCheckCommentCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *starsView;
/* CDZStarsControl *starControl */
@property (strong, nonatomic) CDZStarsControl *starControl;
/* scoreLabel */
@property (strong, nonatomic) UILabel *scoreLabel;

@end

@implementation TYWJCheckCommentCell

- (CDZStarsControl *)starControl {
    if (!_starControl) {
        CGRect f = CGRectMake(0, 0, 13.f*5, self.starsView.zl_height);
        CDZStarsControl *starControl = [[CDZStarsControl alloc] initWithFrame:f stars:5 starSize:CGSizeMake(13.f, 12.f) noramlStarImage:[UIImage imageNamed:@"icon_star_hui_13x12_"] highlightedStarImage: [UIImage imageNamed:@"icon_star_cheng_13x12_"]];
        starControl.enabled = NO;
        starControl.allowFraction = YES;
        [self.starsView addSubview:starControl];
        _starControl = starControl;
    }
    return _starControl;
}

- (UILabel *)scoreLabel {
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.starControl.frame) + 3.f, 0, 30.f, self.starsView.zl_height)];
        _scoreLabel.textColor = ZLNavTextColor;
        _scoreLabel.font = [UIFont systemFontOfSize:14.f];
        _scoreLabel.textAlignment = NSTextAlignmentLeft;
        [self.starsView addSubview:_scoreLabel];
    }
    return _scoreLabel;
}

#pragma mark - set up
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.contentLabel.backgroundColor = [UIColor cyanColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setComment:(TYWJDriverCommentInfo *)comment {
    _comment = comment;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%.01f",comment.rating.floatValue];
    self.starControl.score = comment.rating.floatValue;
//    [self.starsView addSubview:self.starControl];
    
    self.timeLabel.text = comment.time;
    NSString *content = comment.content;
    if (!content || [content isEqualToString:@""]) {
        content = @"暂无评价语";
    }
    self.contentLabel.text = content;
}

- (void)setComplaint:(TYWJDriverComplaintInfo *)complaint {
    _complaint = complaint;
    
    self.timeLabel.text = complaint.time;
    self.contentLabel.text = complaint.content;
}

@end
