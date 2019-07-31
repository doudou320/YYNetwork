//
//  YYNetworkManager.h
//  YYNetwork
//
//  Created by HouEmba on 2019/7/25.
//  Copyright © 2019 HouEmba. All rights reserved.
//

#import <AFNetworking.h>
#import "YYParameterModel.h"

typedef NS_OPTIONS(NSInteger, YYNetworkRequestMethod){
    YYNetworkRequestGET = 0, // GET请求
    YYNetworkRequestPOST, // POST请求
    YYNetworkRequestPUT, // PUT请求
};

typedef void(^SuccessBlock)(NSURLSessionTask *task, id result);

typedef void(^FailureBlock)(NSURLSessionTask *task, NSError *error);

typedef void(^NetworkStatusBlock)(AFNetworkReachabilityStatus status);

@interface YYNetworkManager : AFHTTPSessionManager

/**
 *  单例实例化
 */
+ (instancetype)shareManager;

/**
 *  GET请求
 *
 *  @param urlstring    请求的url
 *  @param params       请求的参数
 *  @param success      下载文件成功的回调
 *  @param failure      下载文件失败的回调
 */
- (void)GETWithUrlString:(NSString *)urlstring parameters:(id)params success:(SuccessBlock)success failure:(FailureBlock)failure;


/**
 *  POST请求
 *
 *  @param urlstring    请求的url
 *  @param params       请求的参数
 *  @param success      下载文件成功的回调
 *  @param failure      下载文件失败的回调
 */
- (void)POSTWithUrlString:(NSString *)urlstring parameters:(id)params success:(SuccessBlock)success failure:(FailureBlock)failure;


/**
 *  PUT请求
 *
 *  @param urlstring    请求的url
 *  @param params       请求的参数
 *  @param success      下载文件成功的回调
 *  @param failure      下载文件失败的回调
 */
- (void)PUTWithUrlString:(NSString *)urlstring parameters:(id)params success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *  上传单张图片
 *
 *  @param params       请求的参数
 *  @param uploadParams 上传文件的参数
 *  @param urlstring    请求的url
 *  @param success      下载文件成功的回调
 *  @param failure      下载文件失败的回调
 */
- (void)uploadImageWithUrlString:(NSString *)urlstring parameters:(id)params uploadParameter:(YYParameterModel *)uploadParams success:(SuccessBlock)success failure:(FailureBlock)failure;


/**
 *  文件下载
 *
 *  @param urlstring    请求的url
 *  @param success      下载文件成功的回调
 *  @param failure      下载文件失败的回调
 *  @param progress     下载文件的进度显示
 */
- (void)downloadWithUrl:(NSString *)urlstring progress:(void(^)(NSProgress *downloadProgress))progress success:(SuccessBlock)success failure:(FailureBlock)failure;


/**
 *  取消所有网络请求
 */
- (void)cancelAllNetworkRequest;


/**
 *  取消指定的url请求
 *
 *  @param method 该请求的请求类型
 *  @param urStr  该请求的完整url
 */
- (void)cancelNetowrkRequestMethod:(NSString *)method requestUrl:(NSString *)urStr;

/**
 *  监听网络状态
 */
- (void)monitoringNetworkStatus:(NetworkStatusBlock)networkStatus;

/**
 *  取消监听网络状态
 */
- (void)stopmonitoringNetworkStatus;

@end


