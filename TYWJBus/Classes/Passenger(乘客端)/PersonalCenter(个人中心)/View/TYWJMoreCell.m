//
//  TYWJMoreCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/26.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJMoreCell.h"
#import "TYWJMoreCellList.h"

NSString * const TYWJMoreCellID = @"TYWJMoreCellID";

@interface TYWJMoreCell()


@end

@implementation TYWJMoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupView];
}

- (void)setupView {
    self.mySwitch.hidden = YES;
    self.mySwitch.onTintColor = ZLNavTextColor;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)setCellList:(TYWJMoreCellList *)cellList {
    _cellList = cellList;
    
    [self setDisplayData];
}

- (void)setDisplayData {
    if (self.cellList) {
        self.titleLabel.text = self.cellList.title;
        self.mySwitch.hidden = !self.cellList.isShowSwitch;
        self.arrowImageView.hidden = self.cellList.isShowSwitch;
    }
}

@end
