//
//  ZLLoginAnimButton.h
//  TYWJBus
//
//  Created by MacBook on 2018/8/28.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJBorderButton.h"

@interface ZLLoginAnimButton : TYWJBorderButton

/* 是否是在登录中 */
@property (assign, nonatomic, readonly) BOOL isLogining;

- (void)loginFailed;

@end
