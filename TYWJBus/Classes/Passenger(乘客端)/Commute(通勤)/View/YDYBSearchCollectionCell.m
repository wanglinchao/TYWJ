//
//  YDYBSearchCollectionCell.m
//  YunDuoYouBao
//
//  Created by GY on 2017/11/27.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "YDYBSearchCollectionCell.h"
#import "TYWJSearchModel.h"


NSString * const YDYBSearchCollectionCellID = @"YDYBSearchCollectionCellID";

@interface YDYBSearchCollectionCell()

@property (weak, nonatomic) IBOutlet UILabel *keywordsLabel;


@end

@implementation YDYBSearchCollectionCell

#pragma mark - 初始化
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.keywordsLabel.font = [UIFont systemFontOfSize:TYWJSearchLabelFont];
    self.keywordsLabel.textColor = [UIColor grayColor];
    [self setBorderWithColor:ZLGlobalTextColor];
    if (self.model) {
        self.keywordsLabel.text = self.model.title;
    }
    
}

- (void)setModel:(TYWJSearchModel *)model {
    _model = model;
    
    self.keywordsLabel.text = self.model.title;
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    self.keywordsLabel.text = text;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setRoundView];
    
}
@end
