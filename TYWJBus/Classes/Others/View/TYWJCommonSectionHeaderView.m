//
//  TYWJCommonSectionHeaderView.m
//  TYWJBus
//
//  Created by tywj on 2020/6/12.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJCommonSectionHeaderView.h"
@interface TYWJCommonSectionHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@end
@implementation TYWJCommonSectionHeaderView
- (void)confirgCellWithParam:(id)Param{
    NSString *str = (NSString *)Param;
    self.titleL.text = str;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
