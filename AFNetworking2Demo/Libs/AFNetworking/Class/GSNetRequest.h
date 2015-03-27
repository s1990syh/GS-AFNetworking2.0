//
//  MSSRequest.h
//  Secret
//
//  Created by Song on 14-8-21.
//  Copyright (c) 2014年 GhostSong. All rights reserved.
//
/*首先导入框架
 Security.framework
 MobileCoreServices.framework
 SystemConfiguration.framework
 CoreLocation.framework
 */


#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@class GSNetRequest;
@protocol GSNetRequestDelegate <NSObject>
@optional
/**
 请求响应成功
 */
- (void)netRequestSuccess:(GSNetRequest *)netRequest;
/**
 请求响应失败
 */
- (void)netRequestIsFail:(GSNetRequest *)netRequest error:(NSError *)error;
@end

@interface GSNetRequest : NSObject{
    AFHTTPRequestOperation *requestOper;
    NSURLResponse *response;
    NSError *error;
    NSData *responseData;
    NSString *responseString;
    NSStringEncoding responseStringEncoding;
    NSInteger tag;
}


@property (nonatomic, strong) AFHTTPRequestOperation *requestOper;

@property (readonly, nonatomic, strong) NSURLResponse *response;
@property (readonly, nonatomic, strong) NSError *error;
@property (readonly, nonatomic, strong) NSData *responseData;
@property (readonly, nonatomic, strong) NSString *responseString;
@property (readonly, nonatomic, assign) NSStringEncoding responseStringEncoding;
@property (nonatomic) NSInteger tag;

@property (nonatomic, weak) id<GSNetRequestDelegate> delegate;

/**
 POST 请求数据(附加URL)
 @param urlStr      附加URL
 @param parameter   参数
 */
- (void)postRequestAddURLStr:(NSString *)urlStr parameters:(NSDictionary *)parameter;

/**
 POST 请求数据(完整URL)
 @param urlStr      完整的URL
 @param parameter   参数
 */
- (void)postRequestCompleteURLStr:(NSString *)urlStr parameters:(NSDictionary *)parameter;

/**
 POST 请求数据Block(完整URL)
 @param urlStr      完整的URL
 @param parameter   参数
 @param success     请求成功Block
 @param failure     请求失败Block
 */
- (void)postRequestBlockURLStr:(NSString *)urlStr parameters:(NSDictionary *)parameter success:(void (^)(GSNetRequest *netRequest))success failure:(void (^)(GSNetRequest *netRequest, NSError *error))failure;
/**
 上传图片
 @param urlStr      完整的URL
 @param parameter   参数
 @param imageData   图片数据
 */
- (void)uploadImageURL:(NSString *)urlStr parameters:(NSDictionary *)parameter imageData:(NSData *)imageData;

/**
 GET 请求数据
 @param urlStr      URL
 */
- (void)getRequestURLStr:(NSString *)urlStr;

/**
 GET 请求数据 (带参数)
 @param urlStr      URL
 @param parameter   参数
 */
- (void)getRequestURLStr:(NSString *)urlStr parameters:(NSDictionary *)parameter;

/**
 GET 请求数据Block
 @param urlStr      URL
 @param success     请求成功Block
 @param failure     请求失败Block
 */
- (void)getRequestURLStr:(NSString *)urlStr completionBlockWithSuccess:(void (^)(GSNetRequest *netRequest))success failure:(void (^)(GSNetRequest *netRequest, NSError *error))failure;

/**
 GET 请求数据Block(带参数)
 @param urlStr      URL
 @param parameter   参数
 @param success     请求成功Block
 @param failure     请求失败Block
 */
- (void)getRequestURLStr:(NSString *)urlStr parameters:(NSDictionary *)parameter completionBlockWithSuccess:(void (^)(GSNetRequest *netRequest))success failure:(void (^)(GSNetRequest *netRequest, NSError *error))failure;
@end
