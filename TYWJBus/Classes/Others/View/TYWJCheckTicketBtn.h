//
//  TYWJCheckTicketBtn.h
//  TYWJBus
//
//  Created by Harley He on 2018/7/28.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "ZLBorderButton.h"

@interface TYWJCheckTicketBtn : ZLBorderButton

/* 验票动画结束 */
@property (copy, nonatomic) void(^checkTicketSuc)(void);

- (void)removeAnimLayer;

- (void)startSuccAnimation;
- (void)stopSuccAnimation;

@end
