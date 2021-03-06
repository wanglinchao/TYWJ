//
//  TYWJNetWorkTolo.h
//  TYWJNetWorkTolo
//
//  Created by 陈秉慎 on 1/15/16.
//  Copyright © 2016 cbs. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
//请求成功回调block
typedef void (^requestSuccessBlock)(NSDictionary *dic);

//请求失败回调block
typedef void (^requestFailureBlock)(NSError *error);

//请求方法define
typedef enum {
    GET,
    POST,
    PUT,
    DELETE,
    HEAD
} HTTPMethod;
@interface TYWJNetWorkTolo : AFURLSessionManager
+ (instancetype)sharedManager;
- (void)requestWithMethod:(HTTPMethod)method
                 WithPath:(NSString *)path
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(requestSuccessBlock)success
          WithFailurBlock:(requestFailureBlock)failure;
- (void)requestWithMethod:(HTTPMethod)method
                 WithPath:(NSString *)path
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(requestSuccessBlock)success
          WithFailurBlock:(requestFailureBlock)failure
                 showLoad:(BOOL)show;
@end
