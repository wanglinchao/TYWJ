//
//  NSError+Common.h
//  TYWJBus
//
//  Created by tywj on 2020/6/19.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//domain
FOUNDATION_EXPORT NSString *const NSCommonErrorDomain;
/**错误状态码*/
typedef NS_ENUM(NSInteger,NSCommonErrorCode){
    NSCommonErrorCodeUnKnow = -1000,
    NSCommonErrorCodeSucc = -1001,
    NSCommonErrorCodefailed = -1002,
};

@interface NSError (Common)
+(NSError*)errorCode:(NSCommonErrorCode)code;
+(NSError*)errorCode:(NSCommonErrorCode)code userInfo:(nullable NSDictionary*)userInfo;
@end

NS_ASSUME_NONNULL_END
