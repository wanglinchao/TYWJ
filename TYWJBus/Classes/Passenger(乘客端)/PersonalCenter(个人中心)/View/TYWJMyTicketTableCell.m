//
//  TYWJMyTicketTableCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/21.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJMyTicketTableCell.h"
#import "TYWJApplyRoute.h"


NSString * const TYWJMyTicketTableCellID = @"TYWJMyTicketTableCellID";

@interface TYWJMyTicketTableCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;


@end

@implementation TYWJMyTicketTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(TYWJApplyRoute *)model {
    _model = model;
    
    self.imgView.image = [UIImage imageNamed:model.img];
    self.bodyLabel.text = model.title;
}

@end
