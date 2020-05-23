//
//  ZLRefreshGifHeader.m
//  TYWJBus
//
//  Created by Harley He on 2018/8/9.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "ZLRefreshGifHeader.h"

@implementation ZLRefreshGifHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)prepare {
    [super prepare];
    
    NSMutableArray *willRefreshImgs = [NSMutableArray array];
    for (NSInteger i = 0; i <= 7; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"loading_000%02ld_58x10_",i]];
        [willRefreshImgs addObject:img];
    }
    
    NSMutableArray *refreshImgs = [NSMutableArray array];
    for (NSInteger i = 0; i <= 15; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"loading_000%02ld_58x10_",i]];
        [refreshImgs addObject:img];
    }
    self.stateLabel.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    [self setImages:@[refreshImgs[0]] forState:MJRefreshStateIdle];
    [self setImages:willRefreshImgs forState:MJRefreshStatePulling];
    [self setImages:refreshImgs duration:0.75f forState:MJRefreshStateRefreshing];
}

@end
