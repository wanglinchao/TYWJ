//
//  TYWJComplaintCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/21.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJComplaintCell.h"
#import "TYWJComplaintModel.h"

NSString * const TYWJComplaintCellID = @"TYWJComplaintCellID";

@interface TYWJComplaintCell()

@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;


@end

@implementation TYWJComplaintCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupView];
}

- (void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setRoundViewWithCornerRaidus:6.f];
}

- (void)setBody:(TYWJComplaintModel *)body {
    _body = body;
    
    self.bodyLabel.text = body.title;
    self.selectButton.selected = body.isSelected;
}

- (void)setBtnSelectedStatus:(BOOL)status {
    self.selectButton.selected = status;
    _body.isSelected = status;
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 15.f;
    frame.origin.y += 10.f;
    frame.size.height -= 10.f;
    frame.size.width -= 30.f;
    
    [super setFrame:frame];
}
@end
