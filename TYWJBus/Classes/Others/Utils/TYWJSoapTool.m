//
//  TYWJSoapTool.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/24.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJSoapTool.h"
#import "GDataXMLNode.h"
#import "XMLReader.h"


#import <AFNetworking.h>


@implementation TYWJSoapTool

+ (AFHTTPSessionManager *)SOAPDataWithSoapBody:(NSString *)soapBody success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    [MBProgressHUD zl_showMessage:TYWJWarningLoading];
    NSString *soapStr = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                         <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\
                         xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                         <soap:Header>\
                         </soap:Header>\
                         <soap:Body>%@</soap:Body>\
                         </soap:Envelope>",soapBody];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    // 设置请求超时时间.f
    manager.requestSerializer.timeoutInterval = 15.f;
    
    // 返回NSData
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 设置请求头，也可以不设置
    [manager.requestSerializer setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%lu", (unsigned long)soapStr.length] forHTTPHeaderField:@"Content-Length"];
    
    // 设置HTTPBody
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return soapStr;
    }];
    
    
    [manager POST:TYWJRequestService parameters:soapStr progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD zl_hideHUD];
        ZLLog(@"currentThread --- %@",[NSThread currentThread]);
        
        NSMutableArray *arrM = [NSMutableArray array];
        
        // 把返回的二进制数据转为字符串
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        // 创建xml 文档对象
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:result error:nil];
        //    GDataXMLElement *xmlEle = [xmlDoc rootElement];
        // 获取根节点
        GDataXMLElement *rootElement =  doc.rootElement;
        
        // 遍历子节点
        for (GDataXMLElement *child in rootElement.children) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            // 遍历子节点
            for (GDataXMLElement *childNode in child.children) {
                NSError *error = nil;
                // 获得子节点的名字
                NSString *name = childNode.name;
                // 获得子节点的内容
                NSString *value = childNode.stringValue;
                NSDictionary *subDic = [XMLReader dictionaryForXMLString:value error:&error];
                if (!subDic) {
                    [dic setObject:value forKey:name];
                }else {
                    [dic setObject:subDic forKey:name];
                }
                
                
            }
            [arrM addObject:dic];
        }
        
        // 请求成功并且结果有值把结果传出去
        if (success) {
            ZLLog(@"response --- \n%@",arrM);
            [MBProgressHUD zl_hideHUD];
            success(arrM);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            [MBProgressHUD zl_showError:TYWJWarningBadNetwork];
            failure(error);
        }
    }];
    return manager;
}

+ (AFHTTPSessionManager *)SOAPDataWithoutLoadingWithSoapBody:(NSString *)soapBody success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    NSString *soapStr = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                         <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\
                         xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                         <soap:Header>\
                         </soap:Header>\
                         <soap:Body>%@</soap:Body>\
                         </soap:Envelope>",soapBody];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    // 设置请求超时时间.f
    manager.requestSerializer.timeoutInterval = 15.f;
    
    // 返回NSData
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 设置请求头，也可以不设置
    [manager.requestSerializer setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%lu", (unsigned long)soapStr.length] forHTTPHeaderField:@"Content-Length"];
    
    // 设置HTTPBody
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return soapStr;
    }];
    
    
    [manager POST:TYWJRequestService parameters:soapStr progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        ZLLog(@"currentThread --- %@",[NSThread currentThread]);
        
        NSMutableArray *arrM = [NSMutableArray array];
        
        // 把返回的二进制数据转为字符串
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        // 创建xml 文档对象
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:result error:nil];
        //    GDataXMLElement *xmlEle = [xmlDoc rootElement];
        // 获取根节点
        GDataXMLElement *rootElement =  doc.rootElement;
        
        // 遍历子节点
        for (GDataXMLElement *child in rootElement.children) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            // 遍历子节点
            for (GDataXMLElement *childNode in child.children) {
                NSError *error = nil;
                // 获得子节点的名字
                NSString *name = childNode.name;
                // 获得子节点的内容
                NSString *value = childNode.stringValue;
                NSDictionary *subDic = [XMLReader dictionaryForXMLString:value error:&error];
                if (!subDic) {
                    [dic setObject:value forKey:name];
                }else {
                    [dic setObject:subDic forKey:name];
                }
                
                
            }
            [arrM addObject:dic];
        }
        
        // 请求成功并且结果有值把结果传出去
        if (success) {
            ZLLog(@"response --- \n%@",arrM);
            success(arrM);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    return manager;
}
@end
