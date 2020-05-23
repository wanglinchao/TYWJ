//
//  TYWJUsableCitiesDredgedCityCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/28.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJUsableCitiesDredgedCityCell.h"


NSString * const TYWJUsableCitiesDredgedCityCellID = @"TYWJUsableCitiesDredgedCityCellID";

@interface TYWJUsableCitiesDredgedCityCell()

@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;

@end

@implementation TYWJUsableCitiesDredgedCityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCity:(TYWJUsableCity *)city {
    _city = city;
    
    self.bodyLabel.text = city.csmc;
}
@end
