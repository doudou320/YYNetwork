//
//  YYNetworkManager.m
//  YYNetwork
//
//  Created by HouEmba on 2019/7/25.
//  Copyright © 2019 HouEmba. All rights reserved.
//

#import "YYNetworkManager.h"

const NSInteger timeoutIntervel = 10;

static NSString *const baseUrl = HouEMainUrl;

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
        
//        self.responseSerializer = [AFJSONResponseSerializer serializer];//返回格式 JSON
        // 返回格式
        // AFHTTPResponseSerializer           二进制格式
        // AFJSONResponseSerializer           JSON
        // AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
        // AFXMLDocumentResponseSerializer (Mac OS X)
        // AFPropertyListResponseSerializer   PList
        // AFImageResponseSerializer          Image
        // AFCompoundResponseSerializer       组合

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

- (void)GETWithUrlString:(NSString *)urlstring parameters:(id)params success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [self GET:urlstring parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"uploadProgress======%lld",downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(task,result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
}

- (void)POSTWithUrlString:(NSString *)urlstring parameters:(id)params success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [self POST:urlstring parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress======%lld",uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(task,result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
}

- (void)PUTWithUrlString:(NSString *)urlstring parameters:(id)params success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [self PUT:urlstring parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(task,result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
}

- (void)uploadImageWithUrlString:(NSString *)urlstring parameters:(id)params uploadParameter:(YYParameterModel *)uploadParams success:(SuccessBlock)success failure:(FailureBlock)failure
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
        if (responseObject) {
            id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(task,result);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
}

- (void)downloadWithUrl:(NSString *)urlstring progress:(void(^)(NSProgress *downloadProgress))progress success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [self downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlstring]] progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (downloadProgress) {
            progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        success(nil,response);
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fulPath = [caches stringByAppendingString:response.suggestedFilename];
        return [NSURL URLWithString:fulPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        failure(nil,error);
    }];
}

- (void)cancelAllNetworkRequest
{
    [self.operationQueue cancelAllOperations];
}

- (void)cancelNetowrkRequestMethod:(NSString *)method requestUrl:(NSString *)urStr
{
    NSError *error = nil;
    /**根据请求的类型 以及 请求的url创建一个NSMutableURLRequest---通过该url去匹配请求队列中是否有该url,如果有的话 那么就取消该请求*/

    NSString *preCancelUrl = [[[self.requestSerializer requestWithMethod:method URLString:urStr parameters:nil error:&error] URL] path];
    
    NSArray *operations = self.operationQueue.operations;
    for (NSOperation *operation in operations) {
        // 如果是请求队列
        if ([operation isKindOfClass:[NSURLSessionTask class]]) {
            // 请求类型的匹配
            BOOL hasMatchRequestType = [method isEqualToString:[[(NSURLSessionTask *)operation currentRequest] HTTPMethod]];
            
            BOOL hasMatchRequestUrl = [preCancelUrl isEqualToString:[[[(NSURLSessionTask *)operation currentRequest] URL] path]];
            
            if (hasMatchRequestType && hasMatchRequestUrl) {
                [operation cancel];
            }
        }
    }
}

- (void)monitoringNetworkStatus:(NetworkStatusBlock)networkStatus
{
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        networkStatus(status);
    }];
}


- (void)stopmonitoringNetworkStatus
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager stopMonitoring];
}
@end
