//
//  TYWJHelpCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/19.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJHelpCell.h"
#import "TYWJHelpModel.h"


NSString * const TYWJHelpCellID = @"TYWJHelpCellID";

@interface TYWJHelpCell()

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;


@end

@implementation TYWJHelpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(TYWJHelpModel *)model {
    _model =  model;
    
    if (model) {
        self.questionLabel.text = [NSString stringWithFormat:@"问:%@",model.wtmc];
        self.answerLabel.text = model.answer;
        
    }
}


- (void)setFrame:(CGRect)frame {
    frame.origin.y += 8.f;
    frame.size.height -= 8.f;
    
    [super setFrame:frame];
}
@end
