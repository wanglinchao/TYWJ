//
//  NGSVerticalButton.m
//  NeverGetSis
//
//  Created by MacTsin on 16/3/19.
//  Copyright © 2016年 MacTsin. All rights reserved.
//

#import "NGSVerticalButton.h"

@implementation NGSVerticalButton

- (void)setupViews
{
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:13.0];
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupViews];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imgViewSize.width != 0) {
        self.imageView.zl_size = self.imgViewSize;
    }
    
    self.imageView.zl_centerX = self.zl_width/2;
    self.imageView.zl_centerY = self.zl_height/2 - 10;
    
    self.titleLabel.zl_x = 0;
    self.titleLabel.zl_width = self.zl_width;
    self.titleLabel.zl_height = 16;
    self.titleLabel.zl_centerY = self.zl_height - 8;
}
@end
