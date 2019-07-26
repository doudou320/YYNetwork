//
//  YYNetworkManager.m
//  YYNetwork
//
//  Created by HouEmba on 2019/7/25.
//  Copyright © 2019 HouEmba. All rights reserved.
//

#import "YYNetworkManager.h"

const NSInteger timeoutIntervel = 10;

static NSString *const baseUrl = @"";

static YYNetworkManager *_networkManager = nil;

@interface YYNetworkManager ()

@end

@implementation YYNetworkManager

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    });
    return _networkManager;
}
// 重写父类initWithBaseURL方法
- (instancetype)initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url]) {
        
        /*
         *   请求
         */
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        /*
         *   设置缓存策略
         */
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        /*
         *   设置请求超时的时间
         */
        self.requestSerializer.timeoutInterval = timeoutIntervel;
        /*
         *   复杂的参数类型，需要使用json传值s，设置请求内容的类型
         */
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        /*
         *   设置接受的参数类型
         */
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/json",@"text/plain",@"text/JavaScript",@"application/json",@"image/jpeg",@"image/png",@"application/octet-stream",nil];
    }
    return self;
}

// 防止外部调用alloc 或者 new
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [YYNetworkManager shareManager];
}

- (void)GetWithUrlString:(NSString *)urlstring parameters:(id)params success:(void(^)(id))success failure:(void(^)(NSError *error))failure
{
    [self GET:urlstring parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"uploadProgress======%lld",downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)PostWithUrlString:(NSString *)urlstring parameters:(id)params success:(void(^)(id))success failure:(void(^)(NSError *error))failure
{
    [self POST:urlstring parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress======%lld",uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)uploadImageWithUrlString:(NSString *)urlstring parameters:(id)params uploadParameter:(YYParameterModel *)uploadParams success:(void(^)(id))success failure:(void(^)(NSError *error))failure
{
    [self POST:urlstring parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        /**
         *  FileData:要上传的文件的二进制数据
         *  name:上传参数名称
         *  fileName：上传到服务器的文件名称
         *  mimeType：文件类型
         */
        
        [formData appendPartWithFileData:uploadParams.data name:uploadParams.name fileName:uploadParams.fileName mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress======%lld",uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)downloadWithUrl:(NSString *)urlstring progress:(void(^)(NSProgress *downloadProgress))progress success:(void(^)(id))success failure:(void(^)(NSError *error))failure
{
    [self downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlstring]] progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (downloadProgress) {
            progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        success(response);
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fulPath = [caches stringByAppendingString:response.suggestedFilename];
        return [NSURL URLWithString:fulPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        failure(error);
    }];
}
@end
