//
//  HZNetworkAction.m
//  HZNetwork
//
//  Created by xzh. on 15/8/17.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "HZNetworkAction.h"
#import "HZSessionTask.h"
#import <AFNetworking/AFNetworking.h>
    

@interface HZNetworkAction ()

@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property(nonatomic, strong) NSMutableDictionary<NSString *, __kindof NSURLSessionTask *> *dataTasks;    //任务集合
@end

@implementation HZNetworkAction
#pragma mark - Initializtion
static id _instance;
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return _instance;
}

+ (instancetype)sharedAction
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

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
    if (!([requestHeaders isKindOfClass:[NSDictionary class]] && requestHeaders.count > 0)) return;
    
    //设置默认的请求头
    [requestHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [self.sessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
}

- (void)performTask:(HZSessionTask *)task completion:(nonnull void (^)(HZNetworkAction * _Nonnull, id _Nullable, NSError * _Nullable))completion
{
    NSString *method = task.method?:@"GET";
    NSURLSessionDataTask *dataTask = [self dataTaskWithMethod:method URLString:task.requestPath params:task.params task:task completion:completion];
    [dataTask resume];
    [self.dataTasks setObject:dataTask forKey:task.taskIdentifier];
}

- (void)performUploadTask:(HZSessionTask *)sessionTask progress:(void (^)(NSProgress *uploadProgress))uploadProgressBlock completion:(nonnull void (^)(HZNetworkAction * _Nonnull, id _Nullable, NSError * _Nullable))completion
{
    NSDictionary *fileDic = sessionTask.fileParams;
    NSData *fileData = [fileDic objectForKey:kHZFileData];
    NSString *fileName = [fileDic objectForKey:kHZFileName];
    NSString *filePath = [fileDic objectForKey:kHZFileURL];
    
    NSAssert( !filePath || !fileData, @"HZNetwork 上传文件不能为空");
    
    NSString *mineType = [fileDic objectForKey:kHZFileMimeType];
    NSString *formName = [fileDic objectForKey:kHZFileFormName];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.sessionManager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:sessionTask.requestPath parameters:sessionTask.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (fileData) {
            [formData appendPartWithFileData:fileData name:formName fileName:fileName mimeType:mineType];
        }else {
            
            NSURL *fileURL =[NSURL URLWithString:filePath?:@""];
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
    __weak typeof(self) weakSelf = self;
    NSURLSessionUploadTask *dataTask = [self.sessionManager uploadTaskWithStreamedRequest:request progress:uploadProgressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        __strong typeof(weakSelf) strong_self = weakSelf;
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
//创建NSURLSessionTask
- (NSURLSessionDataTask *)dataTaskWithMethod:(NSString *)method URLString:(NSString *)URLString params:(NSDictionary *)params task:(HZSessionTask *)sessionTask completion:(void(^)(HZNetworkAction *performer, id __nullable responseObject, NSError * __nullable error))completion;
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
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [self.sessionManager dataTaskWithRequest:request
                                                               uploadProgress:nil
                                                             downloadProgress:nil
                                                            completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                                                                
                                                                if (completion) {
                                                                    completion(weakSelf,responseObject,error);
                                                                }
                                                                
                                                                if (sessionTask.taskIdentifier) {
                                                                    [weakSelf.dataTasks removeObjectForKey:sessionTask.taskIdentifier];
                                                                }
                                                                
                                                            }];
    return dataTask;
}

@end
