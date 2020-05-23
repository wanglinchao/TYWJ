//
//  TYWJNavigationController.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/22.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYWJNavigationController : UINavigationController

/* 是否拦截pop */
@property (assign, nonatomic) BOOL isBlockPop;
/* blockPop */
@property (copy, nonatomic) void(^blockPop)(void);
@end
