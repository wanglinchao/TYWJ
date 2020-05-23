//
//  TYWJITNotiCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJITNotiCell.h"

NSString * const TYWJITNotiCellID = @"TYWJITNotiCellID";

@interface TYWJITNotiCell()

@property (weak, nonatomic) IBOutlet UILabel *notiLabel;
@property (weak, nonatomic) IBOutlet UILabel *notiBodyLabel;


@end

@implementation TYWJITNotiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.notiLabel setBorderWithColor:ZLNavTextColor];
    [self.notiLabel setRoundView];
    
    self.notiBodyLabel.text = @"2018年景区优惠政策2018年景区优惠政策2018年景区优惠政策";
    
}

@end
