//
//  YYNetworkManager.h
//  YYNetwork
//
//  Created by HouEmba on 2019/7/25.
//  Copyright © 2019 HouEmba. All rights reserved.
//

#import <AFNetworking.h>

#import "YYParameterModel.h"

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
- (void)GetWithUrlString:(NSString *)urlstring parameters:(id)params success:(void(^)(id))success failure:(void(^)(NSError *error))failure;

/**
 *  POST请求
 *
 *  @param urlstring    请求的url
 *  @param params       请求的参数
 *  @param success      下载文件成功的回调
 *  @param failure      下载文件失败的回调
 */
- (void)PostWithUrlString:(NSString *)urlstring parameters:(id)params success:(void(^)(id))success failure:(void(^)(NSError *error))failure;

/**
 *  上传单张图片
 *
 *  @param params       请求的参数
 *  @param uploadParams 上传文件的参数
 *  @param urlstring    请求的url
 *  @param success      下载文件成功的回调
 *  @param failure      下载文件失败的回调
 */
- (void)uploadImageWithUrlString:(NSString *)urlstring parameters:(id)params uploadParameter:(YYParameterModel *)uploadParams success:(void(^)(id))success failure:(void(^)(NSError *error))failure;

/**
 *  文件下载
 *
 *  @param urlstring    请求的url
 *  @param success      下载文件成功的回调
 *  @param failure      下载文件失败的回调
 *  @param progress     下载文件的进度显示
 */
- (void)downloadWithUrl:(NSString *)urlstring progress:(void(^)(NSProgress *downloadProgress))progress success:(void(^)(id))success failure:(void(^)(NSError *error))failure;

@end


