//
//  TYWJSearchPOICell.m
//  TYWJBus
//
//  Created by Harllan He on 2018/5/31.
//  Copyright © 2018 Harllan He. All rights reserved.
//

#import "TYWJSearchPOICell.h"
#import <AMapSearchKit/AMapSearchKit.h>


NSString * const TYWJSearchPOICellID = @"TYWJSearchPOICellID";

@interface TYWJSearchPOICell()

@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;


@end
@implementation TYWJSearchPOICell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setDisplay];
}

- (void)setPoi:(AMapPOI *)poi {
    _poi = poi;
    
    [self setDisplay];
}

- (void)setDisplay {
    if (self.poi) {
        self.bodyLabel.text = self.poi.name;
        self.subtitleLabel.textColor = ZLGlobalTextColor;
        self.subtitleLabel.text = self.poi.address;
    }
}
@end
