//
//  ZLHTTPSessionManager.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/26.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "ZLHTTPSessionManager.h"

@implementation ZLHTTPSessionManager

+ (instancetype)manager {
    ZLHTTPSessionManager *mgr = [super manager];
    // 告诉AFN，支持接受 text/xml 的数据
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
//    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer.timeoutInterval = 10.f;
    return mgr;
}

+ (instancetype)signManager {
    ZLHTTPSessionManager *mgr = [super manager];
    // 告诉AFN，支持接受 text/xml 的数据
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
//    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer.timeoutInterval = 10.f;
    return mgr;
}

@end
