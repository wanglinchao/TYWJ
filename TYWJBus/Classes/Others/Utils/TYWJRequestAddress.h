//
//  TYWJRequestAddress.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/24.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYWJRequestAddress : NSObject

+ (instancetype)stantardRequest;

/* 乘客端用户登录 */
@property (copy, nonatomic) NSString *passengerLoginUrl;
@end
