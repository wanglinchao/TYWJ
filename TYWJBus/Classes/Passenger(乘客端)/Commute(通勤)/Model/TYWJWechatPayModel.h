//
//  TYWJWechatPayModel.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/27.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYWJWechatPayModel : NSObject

/* appid */
@property (copy, nonatomic) NSString *appid;
/* noncestr */
@property (copy, nonatomic) NSString *noncestr;
/* package */
@property (copy, nonatomic) NSString *package;
/* partnerid */
@property (copy, nonatomic) NSString *partnerid;
/* prepayid */
@property (copy, nonatomic) NSString *prepayid;
/* sign */
@property (copy, nonatomic) NSString *sign;
/* timestamp */
@property (assign, nonatomic) UInt32 timestamp;

@end
