//
//  MSSRequest.m
//  Secret
//
//  Created by Song on 14-8-21.
//  Copyright (c) 2014年 GhostSong. All rights reserved.
//

#import "GSNetRequest.h"

@implementation GSNetRequest

@synthesize requestOper, response, responseData, responseString, responseStringEncoding, error, tag;




- (void)postRequestAddURLStr:(NSString *)urlStr parameters:(NSDictionary *)parameter
{
    NSMutableString *CompleteURLStr = [NSMutableString stringWithString: @"http://api.meishi.cc/v2/"];
    [CompleteURLStr appendString:urlStr];
    [self postRequestCompleteURLStr:CompleteURLStr parameters:parameter];
}

- (void)postRequestCompleteURLStr:(NSString *)urlStr parameters:(NSDictionary *)parameter{
    [self postRequestBlockURLStr:urlStr parameters:parameter success:nil failure:nil];
}

- (void)postRequestBlockURLStr:(NSString *)urlStr parameters:(NSDictionary *)parameter success:(void (^)(GSNetRequest *netRequest))success failure:(void (^)(GSNetRequest *netRequest, NSError *error))failure{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];     //网络连接标示符

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = 30;
    [manager POST:urlStr parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //请求响应成功
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"++++++请求成功，返回数据:%@",operation.responseString);

        response = operation.response;
        responseData = operation.responseData;
        responseString = operation.responseString;
        responseStringEncoding = operation.responseStringEncoding;
        error = operation.error;
        if ([self.delegate respondsToSelector:@selector(netRequestSuccess:)]) {
            [self.delegate netRequestSuccess:self];
        }
        if (success) {
            success(self);
        }
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //请求响应失败
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"+++++++请求失败：返回数据:%@",operation.responseString);
        
        if ([self.delegate respondsToSelector:@selector(netRequestIsFail:error:)]) {
            [self.delegate netRequestIsFail:self error:operation.error];
        }
        if (failure) {
            failure(self, operation.error);
        }
    }];
    //    //取消所有请求操作
    //    [manager.operationQueue cancelAllOperations];
}

- (void)uploadImageURL:(NSString *)urlStr parameters:(NSDictionary *)parameter imageData:(NSData *)imageData
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

//    NSString *URL_STR = [NSString stringWithFormat:@"%@%@",HOST_ADDRESS, urlStr];
//    NSLog(@"地址：%@",URL_STR);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = 10;
    [manager POST:urlStr parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFormData:imageData name:nil];
        [formData appendPartWithFileData :imageData name:@"imgFile" fileName:@"photo.png" mimeType:@"image/jpeg"];

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //请求响应成功
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"+++++++请求成功：返回数据:%@",operation.responseString);
        
        response = operation.response;
        responseData = operation.responseData;
        responseString = operation.responseString;
        responseStringEncoding = operation.responseStringEncoding;
        error = operation.error;
        if ([self.delegate respondsToSelector:@selector(netRequestSuccess:)]) {
            [self.delegate netRequestSuccess:self];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //请求响应失败
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"+++++++请求失败：返回数据:%@",operation.responseString);
    }];
}
- (void)getRequestURLStr:(NSString *)urlStr
{
    [self getRequestURLStr:urlStr parameters:nil];
}
- (void)getRequestURLStr:(NSString *)urlStr parameters:(NSDictionary *)parameter{
    [self getRequestURLStr:urlStr parameters:parameter completionBlockWithSuccess:nil failure:nil];
}

- (void)getRequestURLStr:(NSString *)urlStr completionBlockWithSuccess:(void (^)(GSNetRequest *))success failure:(void (^)(GSNetRequest *, NSError *))failure
{
    [self getRequestURLStr:urlStr parameters:nil completionBlockWithSuccess:success failure:failure];
}

- (void)getRequestURLStr:(NSString *)urlStr parameters:(NSDictionary *)parameter completionBlockWithSuccess:(void (^)(GSNetRequest *))success failure:(void (^)(GSNetRequest *, NSError *))failure
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    __block NSMutableString *parameterURLStr = [NSMutableString stringWithString:urlStr];
    NSLog(@" 接口 URL:  %@",parameterURLStr);
    
    //如果有参数, 拼接参数
    if (parameter) {
        NSArray *keyArr = [parameter allKeys];
        for (int i=0; i<[keyArr count]; i++) {
            NSString *key = keyArr[i];
            NSLog(@"参数   %@  :  %@",key, parameter[key]);
            if (i == [keyArr count] - 1) {
                [parameterURLStr appendString:[NSString stringWithFormat:@"%@=%@",key, parameter[key]]];
            }else{
                [parameterURLStr appendString:[NSString stringWithFormat:@"%@=%@&",key, parameter[key]]];
            }
        }
    }
//    NSLog(@"==========完整 URL============:%@",parameterURLStr);
    
    //编码   针对参数编码
    
    //    NSString *unicodeStr = [NSString stringWithCString:[parameterURLStr UTF8String] encoding:NSUnicodeStringEncoding];
    
    //编码   针对地址编码
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)parameterURLStr, NULL, NULL,  kCFStringEncodingUTF8 ));
    
    NSURL *URL = [NSURL URLWithString:encodedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //请求响应成功
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"+++++++请求成功：返回数据:%@",operation.responseString);

        response = operation.response;
        responseData = operation.responseData;
        responseString = operation.responseString;
        responseStringEncoding = operation.responseStringEncoding;
        error = operation.error;
        if ([self.delegate respondsToSelector:@selector(netRequestSuccess:)]) {
            [self.delegate netRequestSuccess:self];
        }
        if (success) {
            success(self);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //请求响应失败
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"+++++++请求失败：返回数据:%@",operation.responseString);

        if ([self.delegate respondsToSelector:@selector(netRequestIsFail:error:)]) {
            [self.delegate netRequestIsFail:self error:operation.error];
        }
        if (failure) {
            failure(self, operation.error);
        }
    }];
    [operation start];
    
    //    //取消请求操作
    //    [operation cancel];
}



















@end
