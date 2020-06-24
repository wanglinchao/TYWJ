//
//  TYWJNetWorkTolo.m
//  TYWJNetWorkTolo
//
//  Created by 陈秉慎 on 1/15/16.
//  Copyright © 2016 cbs. All rights reserved.
//

#import "TYWJNetWorkTolo.h"
#import "NSError+Common.h"
#define BASE_URL_PATH @"http://dev.panda.tqc.cd917.com:8080/esportingplus/v1/api/"

@implementation TYWJNetWorkTolo
+ (instancetype)sharedManager {
    static TYWJNetWorkTolo *manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://httpbin.org/"]];
    });
    return manager;
}

-(instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        // 请求超时设定
        self.requestSerializer.timeoutInterval = 5.f;
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        [self.requestSerializer setValue:@"*/*" forHTTPHeaderField:@"Accept"];
//        NSString *auth = [[NSUserDefaults standardUserDefaults] objectForKey:@"Authorization"];
//        [self.requestSerializer setValue:auth forHTTPHeaderField:@"Authorization"];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        self.securityPolicy.allowInvalidCertificates = YES;
    }
    return self;
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
    if ([path hasPrefix:@"http://192.168.2.192:9002"]) {
        path = [path stringByReplacingOccurrencesOfString:@"http://192.168.2.192:9002" withString:@"mgt"];
    }
    [MBProgressHUD showHUDAddedTo:[TYWJGetCurrentController currentViewController].view animated:YES];
    path = [NSString stringWithFormat:@"%@%@",BASE_URL_PATH,path];
    NSString *auth = [NSString stringWithFormat:@"token %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"Authorization"]];
    NSLog(@"----------------------请求服务器地址%@+++++",path);
    NSLog(@"----------------------请求参数%@+++++",params);
    NSLog(@"----------------------请求Authorization%@+++++",auth);
    switch (method) {
        case GET:{
            [self.requestSerializer setValue:auth forHTTPHeaderField:@"Authorization"];
            [self GET:path parameters:params progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
                [MBProgressHUD hideAllHUDsForView:[TYWJGetCurrentController currentViewController].view animated:YES];
                NSLog(@"----------------------GET返回数据%@++++++++++",responseObject);
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:[TYWJGetCurrentController currentViewController].view animated:YES];
                NSLog(@"Error: %@", error);
                failure(error);
            }];
            break;
        }
        case POST:{
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:path parameters:params error:nil];
            request.timeoutInterval = 5.f;
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
            [request setValue:auth forHTTPHeaderField:@"Authorization"];
            NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                [MBProgressHUD hideAllHUDsForView:CURRENTVIEW animated:YES];
                NSLog(@"----------------------POST返回数据%@++++++++++",responseObject);
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
                    NSLog(@"Error: %@", error);
                }
            }];
            [task resume];
            break;
        }
        default:
            break;
    }    
}
@end
