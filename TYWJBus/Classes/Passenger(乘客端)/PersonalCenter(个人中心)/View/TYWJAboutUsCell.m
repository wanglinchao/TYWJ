//
//  TYWJAboutUsCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/20.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJAboutUsCell.h"

NSString * const TYWJAboutUsCellID = @"TYWJAboutUsCellID";

@interface TYWJAboutUsCell()

@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;


@end

@implementation TYWJAboutUsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setText:(NSString *)text {
    _text = text;
    
    self.bodyLabel.text = text;
}

@end
