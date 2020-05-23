//
//  TYWJITCategoryHeaderView.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/25.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJITCategoryHeaderView.h"
#import "TYWJCommuteHeaderView.h"


@interface TYWJITCategoryHeaderView()

@property (weak, nonatomic) IBOutlet TYWJCommuteHeaderView *selectionView;


@end

@implementation TYWJITCategoryHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.backgroundColor = ZLGlobalBgColor;
    self.selectionView.getupPlaceholder = @"出发地";
    self.selectionView.getdownPlaceholder = @"目的地";
    self.selectionView.backgroundColor = [UIColor clearColor];
}

@end
