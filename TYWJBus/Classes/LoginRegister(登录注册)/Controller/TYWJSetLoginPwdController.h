//
//  TYWJSetLoginPwdController.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/28.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBaseController.h"

@interface TYWJSetLoginPwdController : TYWJBaseController

/* 是否是忘记密码 */
@property (assign, nonatomic) BOOL isForgetPwd;
/* 是否是司机端 */
@property (assign, nonatomic) BOOL isDriver;

@end
