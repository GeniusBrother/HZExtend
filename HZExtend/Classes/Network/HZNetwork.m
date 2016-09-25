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

#import <AFNetworking/AFNetworking.h>
#import <TMCache/TMCache.h>

@interface HZNetwork ()

@property(nonatomic, strong) NSMutableDictionary<NSString *, id> *defaultFields;   //默认添加的请求头，以便还原
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
    _defaultFields = [NSMutableDictionary dictionary];
    [self.defaultFields addEntriesFromDictionary:[HZNetworkConfig sharedConfig].defaultHeaderFields];
    
    _sessionManager = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityConfigModel = [AFSecurityPolicy policyWithPinningMode:[HZNetworkConfig sharedConfig].SSLPinningMode];
    securityConfigModel.allowInvalidCertificates = [HZNetworkConfig sharedConfig].allowInvalidCertificates;
    self.sessionManager.securityPolicy = securityConfigModel;
}

- (void)httpSetup:(HZSessionTask *)sessionTask
{
    //1.重置自身数据
    [self rest];
    
    //2.配置新数据
    /**
     *  httpRequestFields
     */
    NSDictionary *fields = sessionTask.httpRequestFields;
    if (fields.isNoEmpty) {
        [fields enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self.sessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    //3.清空原任务数据
    [sessionTask restAllOutput];
    [sessionTask absoluteURL];  //刷新absoluteURL
}

- (void)rest
{
    self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.defaultFields enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self.sessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
}

#pragma mark - Action

- (void)send:(HZSessionTask *)sessionTask
{
    NSString *path = sessionTask.path;
    HZAssertNoReturn(!path.isNoEmpty, @"path nil")
    HZAssertNoReturn(sessionTask.state != HZSessionTaskStateRunable, @"task has run already")
    
    //启动前还原配置
    [self httpSetup:sessionTask];
    
    if ([HZNetworkConfig sharedConfig].reachable) {
        NSString *method = sessionTask.method?:@"GET";
        if ([method caseInsensitiveCompare:@"GET"] == NSOrderedSame) {
            [self GET:sessionTask];
        }else if ([method caseInsensitiveCompare:@"POST"] == NSOrderedSame) {
            [self POST:sessionTask];
        }
    }else {
        [sessionTask noReach];
    }
}

- (void)GET:(HZSessionTask *)sessionTask
{
    /**************启动任务**************/
    BOOL pathSchema = sessionTask.pathkeys.isNoEmpty;
    id params = pathSchema?nil:sessionTask.params;
    NSString *urlstring = pathSchema?sessionTask.absoluteURL:sessionTask.absoluteURL.allPath;
    NSURLSessionDataTask *dataTask = [self.sessionManager GET:urlstring parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        [self sucess:sessionTask response:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self fail:sessionTask error:error];
    }];
    [dataTask resume];
    [self.dataTasks setObject:dataTask forKey:sessionTask.cacheKey];
    [sessionTask startSession];
}

- (void)POST:(HZSessionTask *)sessionTask
{
    /**************启动任务**************/
    NSString *urlstring = sessionTask.absoluteURL.allPath;
    NSURLSessionDataTask *dataTask = [self.sessionManager POST:urlstring parameters:sessionTask.params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self sucess:sessionTask response:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self fail:sessionTask error:error];
    }];
    
    //开始请求
    [dataTask resume];
    [self.dataTasks setObject:dataTask forKey:sessionTask.cacheKey];
    [sessionTask startSession];
}

- (void)upload:(HZUploadSessionTask *)sessionTask progress:(void (^)(NSProgress *uploadProgress))uploadProgressBlock
{
//    if (sessionTask.fileName.isEmpty || sessionTask.formName.isEmpty) return; AFN已经做了
    NSString *path = sessionTask.path;
    HZAssertNoReturn(!path.isNoEmpty, @"path nil")
    HZAssertNoReturn(sessionTask.state != HZSessionTaskStateRunable, @"task has run already")
    
    //启动前参数配置
    [self httpSetup:sessionTask];
    
    NSMutableURLRequest *request = [self.sessionManager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:sessionTask.absoluteURL parameters:sessionTask.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (sessionTask.fileData) {
            [formData appendPartWithFileData:sessionTask.fileData name:sessionTask.formName fileName:sessionTask.fileName mimeType:sessionTask.mimeType];
        }else {
            [formData appendPartWithFileURL:sessionTask.fileURL name:sessionTask.formName fileName:sessionTask.fileName mimeType:sessionTask.mimeType error:nil];
        }
    } error:nil];
    
    NSURLSessionUploadTask *dataTask = [self.sessionManager uploadTaskWithStreamedRequest:request progress:uploadProgressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [self fail:sessionTask error:error];
        }else {
            [self sucess:sessionTask response:responseObject];
        }
    }];
    
    //开始请求
    [dataTask resume];
    [self.dataTasks setObject:dataTask forKey:sessionTask.cacheKey];
    [sessionTask startSession];
}


/**
 *  取消任务
 */
- (void)cancel:(HZSessionTask *)sessionTask
{
    NSURLSessionTask *task = [self.dataTasks objectForKey:sessionTask.cacheKey];
    if(task) [task cancel];
}

#pragma mark - CallBack
/**
 *  成功后的默认处理
 */
- (void)sucess:(HZSessionTask *)sessionTask response:(id)responseObject
{
    //移掉该任务
    [self.dataTasks removeObjectForKey:sessionTask.cacheKey];
    
    //配置输出
    [sessionTask responseSessionWithResponseObject:responseObject error:nil];
}

/**
 *  失败后的默认处理
 */
- (void)fail:(HZSessionTask *)sessionTask error:(NSError *)error
{
    HZLog(HZ_REQUEST_LOG_FORMAT,sessionTask.absoluteURL,error.localizedDescription);
    
    [self.dataTasks removeObjectForKey:sessionTask.cacheKey];
    [sessionTask responseSessionWithResponseObject:nil error:error];
}

@end
