//
//  TYWJTipsViewCheckTicketStatus.h
//  TYWJBus
//
//  Created by tywj on 2020/7/8.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYWJTipsViewCheckTicketStatus : TYWJBaseView
@property (copy, nonatomic) void(^buttonSeleted)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
