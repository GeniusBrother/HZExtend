//
//  HZNetwork.m
//  ZHFramework
//
//  Created by xzh. on 15/8/17.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "HZNetwork.h"
#import "HZMacro.h"
#import "NSDictionary+HZExtend.h"
#import "NSString+HZExtend.h"
#import "HZSessionTask.h"

#import <AFNetworking/AFNetworking.h>
#import <TMCache/TMCache.h>

@interface HZNetwork ()

@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property(nonatomic, strong) NSMutableDictionary<NSString *, __kindof NSURLSessionTask *> *dataTasks;    //任务集合
@end

@implementation HZNetwork
#pragma mark - Initializtion

singleton_m(Network)

- (instancetype)init
{
    self = [super init];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self setup];
        });
    }
    return self;
}

- (void)setup
{   
    _dataTasks = [NSMutableDictionary dictionary];
    _sessionManager = [AFHTTPSessionManager manager];
    
    //设置证书验证方式配置模型
    AFSecurityPolicy *securityConfigModel = [AFSecurityPolicy policyWithPinningMode:[HZNetworkConfig sharedConfig].SSLPinningMode];
    securityConfigModel.allowInvalidCertificates = [HZNetworkConfig sharedConfig].allowInvalidCertificates;
    self.sessionManager.securityPolicy = securityConfigModel;
}

#pragma mark - Public Method
- (void)configDefaultRequestHeader:(NSDictionary<NSString *,NSString *> *)requestHeaders
{
    if (!requestHeaders.isNoEmpty) return;
    
    //设置默认的请求头
    [requestHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [self.sessionManager.requestSerializer setValue:[obj urlEncode] forHTTPHeaderField:key];
    }];
}

- (void)performTask:(HZSessionTask *)task completion:(nonnull void (^)(HZNetwork * _Nonnull, id _Nullable, NSError * _Nullable))completion
{
    NSString *method = task.method?:@"GET";
    if ([method caseInsensitiveCompare:@"GET"] == NSOrderedSame) {
        [self GET:task completion:completion];
    }else if ([method caseInsensitiveCompare:@"POST"] == NSOrderedSame) {
        [self POST:task completion:completion];
    }
}

- (void)performUploadTask:(HZSessionTask *)sessionTask progress:(void (^)(NSProgress *uploadProgress))uploadProgressBlock completion:(nonnull void (^)(HZNetwork * _Nonnull, id _Nullable, NSError * _Nullable))completion
{
    NSDictionary *fileDic = sessionTask.fileParams;
    NSData *fileData = [fileDic objectForKey:HZ_FILE_MIME_TYPE_KEY];
    NSString *fileName = [fileDic objectForKey:HZ_FILE_NAME_KEY];
    NSAssert( fileName || fileData , @"HZNetwork 上传文件不能为空");
    
    NSString *mineType = [fileDic objectForKey:HZ_FILE_MIME_TYPE_KEY];
    NSString *formName = [fileDic objectForKey:HZ_FILE_FORM_NAME_KEY];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.sessionManager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:sessionTask.absoluteURL parameters:sessionTask.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (fileData.isNoEmpty) {
            [formData appendPartWithFileData:fileData name:formName fileName:fileName mimeType:mineType];
        }else {
            NSURL *fileURL = [[NSBundle mainBundle] URLForResource:fileName.isNoEmpty?fileName:@"" withExtension:nil];
            [formData appendPartWithFileURL:fileURL name:formName fileName:fileName mimeType:mineType error:nil];
        }
    } error:&serializationError];
    if (serializationError) {
        if (completion) {
            completion(self,nil,serializationError);
        }
        return;
    }

    [sessionTask.requestHeader enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    HZWeakObj(self);
    NSURLSessionUploadTask *dataTask = [self.sessionManager uploadTaskWithStreamedRequest:request progress:uploadProgressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        HZStrongObj(self);
        if (completion) {
            completion(strong_self,responseObject,error);
        }
        
        if (sessionTask.taskIdentifier) {
            [strong_self.dataTasks removeObjectForKey:sessionTask.taskIdentifier];
        }

    }];
    
    //开始请求
    [dataTask resume];
    [self.dataTasks setObject:dataTask forKey:sessionTask.taskIdentifier];
}

- (void)cancelTask:(HZSessionTask *)sessionTask
{
    NSURLSessionTask *task = [self.dataTasks objectForKey:sessionTask.taskIdentifier];
    if(task) [task cancel];
}

#pragma mark - Private Method
//开始GET请求
- (void)GET:(HZSessionTask *)sessionTask completion:(void(^)(HZNetwork *performer, id __nullable responseObject, NSError * __nullable error))completion;
{
    //创建请求
    BOOL pathSchema = sessionTask.pathkeys.isNoEmpty;
    NSString *URLString = @"";
    id params = nil;
    if (pathSchema) {
        URLString = sessionTask.absoluteURL;
    }else {
        URLString = sessionTask.absoluteURL.allPath;
        params = sessionTask.params;
    }
    NSURLSessionDataTask *dataTask = [self dataTaskWithMethod:@"GET" URLString:URLString params:params task:sessionTask completion:completion];
    [dataTask resume];
    [self.dataTasks setObject:dataTask forKey:sessionTask.taskIdentifier];
}

//开始POST请求
- (void)POST:(HZSessionTask *)sessionTask completion:(void(^)(HZNetwork *performer, id __nullable responseObject, NSError * __nullable error))completion;
{
    NSString *URLString = sessionTask.absoluteURL;
    NSURLSessionDataTask *dataTask = [self dataTaskWithMethod:@"POST" URLString:URLString params:sessionTask.params task:sessionTask completion:completion];
    [dataTask resume];
    [self.dataTasks setObject:dataTask forKey:sessionTask.taskIdentifier];
}

//创建NSURLSessionTask
- (NSURLSessionDataTask *)dataTaskWithMethod:(NSString *)method URLString:(NSString *)URLString params:(NSDictionary *)params task:(HZSessionTask *)sessionTask completion:(void(^)(HZNetwork *performer, id __nullable responseObject, NSError * __nullable error))completion;
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.sessionManager.requestSerializer requestWithMethod:method URLString:URLString parameters:params error:&serializationError];
    if (serializationError) {
        if (completion) {
            completion(self,nil,serializationError);
        }
        return nil;
    }
    [sessionTask.requestHeader enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    
    HZWeakObj(self);
    NSURLSessionDataTask *dataTask = [self.sessionManager dataTaskWithRequest:request
                                                               uploadProgress:nil
                                                             downloadProgress:nil
                                                            completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                                                                
                                                                HZStrongObj(self);
                                                                if (completion) {
                                                                    completion(strong_self,responseObject,error);
                                                                }
                                                                
                                                                if (sessionTask.taskIdentifier) {
                                                                    [strong_self.dataTasks removeObjectForKey:sessionTask.taskIdentifier];
                                                                }
                                                                
                                                            }];
    return dataTask;
}

@end
