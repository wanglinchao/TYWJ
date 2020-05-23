//
//  TYWJUsableCitiesCurrentCityCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/28.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJUsableCitiesCurrentCityCell.h"



NSString * const TYWJUsableCitiesCurrentCityCellID = @"TYWJUsableCitiesCurrentCityCellID";

@interface TYWJUsableCitiesCurrentCityCell()

@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;


@end

@implementation TYWJUsableCitiesCurrentCityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupView];
}

- (void)setupView {
    self.bodyLabel.text = [TYWJCommonTool sharedTool].selectedCity.city;
}


@end
