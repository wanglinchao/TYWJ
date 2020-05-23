//
//  TYWJRegisterController.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBaseController.h"

typedef enum : NSUInteger {
    TYWJRFTypeRegister,
    TYWJRFTypeForget,
} TYWJRFType;

@interface TYWJRegisterController : TYWJBaseController

/* TYWJRFType */
@property (assign, nonatomic) TYWJRFType type;

@end
