//
//  TYWJSoapTool.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/24.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <Foundation/Foundation.h>


@class AFHTTPSessionManager;

@interface TYWJSoapTool : NSObject

+ (AFHTTPSessionManager *)SOAPDataWithSoapBody:(NSString *)soapBody success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure;
+ (AFHTTPSessionManager *)SOAPDataWithoutLoadingWithSoapBody:(NSString *)soapBody success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure;

@end
