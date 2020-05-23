//
//  TYWJSideCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/24.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJSideCell.h"
#import "TYWJSideTableModel.h"

NSString * const TYWJSideCellID = @"TYWJSideCellID";

@interface TYWJSideCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIView *firstLine;


@end

@implementation TYWJSideCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupView];
}

- (void)setupView {
    self.iconImageView.contentMode = UIViewContentModeCenter;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setDisplayInfo];
}

- (void)setDisplayInfo {
    if (self.sideModel) {
        self.iconImageView.image = [UIImage imageNamed:self.sideModel.image];
        self.bodyLabel.text = self.sideModel.title;
    }
    
}

- (void)setSideModel:(TYWJSideTableModel *)sideModel {
    _sideModel = sideModel;
    [self setDisplayInfo];
}

- (void)setIsShowingFirstLine:(BOOL)isShowingFirstLine {
    _isShowingFirstLine = isShowingFirstLine;
    if (isShowingFirstLine) {
        self.firstLine.hidden = NO;
    }
}
@end
