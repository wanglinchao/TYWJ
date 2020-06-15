//
//  TYWJProtocolController.h
//  TYWJBus
//
//  Created by tywj on 2020/6/15.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJBaseController.h"

typedef enum : NSUInteger {
    TYWJCarProtocolControllerTypeCarProtocol,//用车协议
    TYWJCarProtocolControllerTypeTicketingInformation,//购票说明
    TYWJCarProtocolControllerTypePrivacyPolicy,//隐私政策
} TYWJCarProtocolControllerType;

@interface TYWJProtocolController : TYWJBaseController

/* type */
@property (assign, nonatomic) TYWJCarProtocolControllerType type;

@end
