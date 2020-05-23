//
//  ZLPageControl.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/16.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "ZLPageControl.h"

@implementation ZLPageControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setCurrentPage:(NSInteger)currentPage {
    [super setCurrentPage:currentPage];
    
    NSInteger count = self.subviews.count;
    for (NSUInteger subviewIndex = 0; subviewIndex < count; subviewIndex++) {
        
        UIView *sView = [self.subviews objectAtIndex:subviewIndex];
        ZLLog(@"%@",sView.subviews);
        UIImageView *subview = nil;
        
        
        if (sView.subviews) {
            subview = [sView.subviews firstObject];
        }else {
            UIImageView *subview = [[UIImageView alloc] initWithFrame:sView.bounds];
            [sView addSubview:subview];
            
        }
        
        CGSize size = CGSizeZero;
        size.height = 12;
        size.width = 12;
        subview.zl_size = size;
        sView.zl_size = size;
        [sView setRoundView];
        
        if (subviewIndex == currentPage)
        {
            subview.image = [UIImage imageNamed:self.currentPageImg];
        }
        else
        {
            subview.image = [UIImage imageNamed:self.pageImg];
        }
        
    }
}
@end
