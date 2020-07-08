//
//  TYWJNetWorkTolo.m
//  TYWJNetWorkTolo
//
//  Created by 陈秉慎 on 1/15/16.
//  Copyright © 2016 cbs. All rights reserved.
//

#import "TYWJNetWorkTolo.h"
#import "NSError+Common.h"
//#define BASE_URL_PATH @"http://dev.panda.tqc.cd917.com:8080/esportingplus/v1/api/"
#define BASE_URL_PATH @"http://192.168.2.91:8080/esportingplus/v1/api/"
//#define BASE_URL_PATH @"https://commute.panda.cd917.com/esportingplus/v1/api/"
@interface TYWJNetWorkTolo()



@property (nonatomic,strong) AFURLSessionManager * manager;



@end
@implementation TYWJNetWorkTolo
+ (instancetype)sharedManager {
    static TYWJNetWorkTolo *manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [[TYWJNetWorkTolo alloc] init];
        manager.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return manager;
}
- (void)requestWithMethod:(HTTPMethod)method
                 WithPath:(NSString *)path
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(requestSuccessBlock)success
          WithFailurBlock:(requestFailureBlock)failure
{
    if ([path hasPrefix:@"http://192.168.2.91:9001"]) {
        path = [path stringByReplacingOccurrencesOfString:@"http://192.168.2.91:9001" withString:@"user"];
    }
    if ([path hasPrefix:@"http://192.168.2.91:9003"]) {
        path = [path stringByReplacingOccurrencesOfString:@"http://192.168.2.91:9003" withString:@"route"];
    }
    if ([path hasPrefix:@"http://192.168.2.91:9005"]) {
        path = [path stringByReplacingOccurrencesOfString:@"http://192.168.2.91:9005" withString:@"ticket"];
    }
    if ([path hasPrefix:@"http://192.168.2.192:9005"]) {
        path = [path stringByReplacingOccurrencesOfString:@"http://192.168.2.192:9005" withString:@"ticket"];
    }
    if ([path hasPrefix:@"http://192.168.2.191:9005"]) {
        path = [path stringByReplacingOccurrencesOfString:@"http://192.168.2.191:9005" withString:@"ticket"];
    }
    if ([path hasPrefix:@"http://192.168.2.191:9002"]) {
        path = [path stringByReplacingOccurrencesOfString:@"http://192.168.2.191:9002" withString:@"mgt"];
    }
    [MBProgressHUD showHUDAddedTo:[TYWJGetCurrentController currentViewController].view animated:YES];
    path = [NSString stringWithFormat:@"%@%@",BASE_URL_PATH,path];
    NSString *auth = [NSString stringWithFormat:@"token %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"Authorization"]];
    NSString *requestMethod = @"";
    switch (method) {
        case GET:
            requestMethod = @"GET";
            break;
        case POST:
            requestMethod = @"POST";
            break;
        case PUT:
            requestMethod = @"PUT";
            break;
        case DELETE:
            requestMethod = @"DELETE";
            break;
        case HEAD:
            requestMethod = @"HEAD";
            break;
        default:
            break;
    }
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:requestMethod URLString:path parameters:params error:nil];
    request.timeoutInterval = 5.f;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [request setValue:auth forHTTPHeaderField:@"Authorization"];
    NSLog(@"----------------------请求服务器地址%@",path);
    NSLog(@"----------------------请求参数%@",params);
    NSLog(@"----------------------请求Authorization%@",auth);
    NSURLSessionDataTask *task = [self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [MBProgressHUD hideAllHUDsForView:CURRENTVIEW animated:YES];
        NSLog(@"----------------------返回数据%@++++++++++",responseObject);
        if (!error) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                // 请求成功数据处理
                NSNumber *code = [responseObject objectForKey:@"code"];
                if (code.intValue == 0) {
                    success(responseObject);
                } else {
                    NSError *error = [NSError errorCode:NSCommonErrorDomain userInfo:(NSDictionary *)responseObject];
                    failure(error);
                }
            } else {
                NSLog(@"Error: %@", error);
            }
        } else {
            NSInteger code = error.code;
                if (code == 401) {
                    [MBProgressHUD zl_showMessage:@"用户已过期，需重新登陆" ];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [TYWJCommonTool signOutUserWithView:nil];
                    });
                    return;
                }
            NSError *error = [NSError errorCode:NSCommonErrorDomain userInfo:(NSDictionary *)responseObject];
            failure(error);
            NSLog(@"Error: %@", error);
        }
    }];
    [task resume];
}
@end
