//
//  TYWJCarProtocolController.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBaseController.h"

typedef enum : NSUInteger {
    TYWJCarProtocolControllerTypeCarProtocol,//用车协议
    TYWJCarProtocolControllerTypeTicketingInformation,//购票说明
    TYWJCarProtocolControllerTypePrivacyPolicy,//隐私政策
    TYWJCarProtocolControllerTypeRefundTicketingInformation,//退票说明
} TYWJCarProtocolControllerType;

@interface TYWJCarProtocolController : TYWJBaseController

/* type */
@property (assign, nonatomic) TYWJCarProtocolControllerType type;

@end
