//
//  TYWJVerifyCodeController.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/28.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBaseController.h"

typedef enum : NSUInteger {
    TYWJVerifyCodeControllerTypeRegister,
    TYWJVerifyCodeControllerTypeForgetPwd,
    TYWJVerifyCodeControllerTypeUpdateUid,
} TYWJVerifyCodeControllerType;

@interface TYWJVerifyCodeController : TYWJBaseController

/* 类型，是注册还是忘记密码,是否是注册 */
@property (assign, nonatomic) TYWJVerifyCodeControllerType type;
/* 是否是司机端 */
@property (assign, nonatomic) BOOL isDriver;

@end
