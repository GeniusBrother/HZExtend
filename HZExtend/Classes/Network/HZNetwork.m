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
#import "UploadSessionTask.h"
#import "AFNetworking.h"
#import "TMCache.h"
#import "NSString+HZExtend.h"
@interface HZNetwork ()

@property(nonatomic, strong) NSMutableDictionary<NSString *, id> *defaultFields;   //默认添加的请求头，以便还原
@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property(nonatomic, strong) NSMutableDictionary<NSString *, __kindof NSURLSessionTask *> *dataTasks;    //任务集合
@end

@implementation HZNetwork
#pragma mark - Init
singleton_m(Network)

- (instancetype)init
{
    self = [super init];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sessionManager = [AFHTTPSessionManager manager];
            _dataTasks = [NSMutableDictionary dictionary];
            _defaultFields = [NSMutableDictionary dictionary];
            
            [self.defaultFields addEntriesFromDictionary:[NetworkConfig sharedConfig].defaultHeaderFields];
        });
    }
    return self;
}

- (void)httpSetup:(SessionTask *)sessionTask
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

#pragma mark- Action
/**
 *  发送GET/POST任务
 */
- (void)send:(SessionTask *)sessionTask
{
    NSString *path = sessionTask.path;
    HZAssertNoReturn(!path.isNoEmpty, @"path nil")
    HZAssertNoReturn(sessionTask.state != SessionTaskStateRunable, @"task has run already")
    
    //启动前还原配置
    [self httpSetup:sessionTask];
    
    if ([NetworkConfig sharedConfig].reachable) {
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

/**
 *  GET
 */
- (void)GET:(SessionTask *)sessionTask
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

/**
 *  POST
 */
- (void)POST:(SessionTask *)sessionTask
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

/**
 *  upload
 */
- (void)upload:(UploadSessionTask *)sessionTask progress:(void (^)(NSProgress *uploadProgress))uploadProgressBlock
{
//    if (sessionTask.fileName.isEmpty || sessionTask.formName.isEmpty) return; AFN已经做了
    NSString *path = sessionTask.path;
    HZAssertNoReturn(!path.isNoEmpty, @"path nil")
    HZAssertNoReturn(sessionTask.state != SessionTaskStateRunable, @"task has run already")
    
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
- (void)cancel:(SessionTask *)sessionTask
{
    NSURLSessionTask *task = [self.dataTasks objectForKey:sessionTask.cacheKey];
    if(task) [task cancel];
}

#pragma mark - CallBack
/**
 *  成功后的默认处理
 */
- (void)sucess:(SessionTask *)sessionTask response:(id)responseObject
{
    //移掉该任务
    [self.dataTasks removeObjectForKey:sessionTask.cacheKey];
    
    //配置输出
    [sessionTask responseSessionWithResponseObject:responseObject error:nil];
}

/**
 *  失败后的默认处理
 */
- (void)fail:(SessionTask *)sessionTask error:(NSError *)error
{
    HZLog(@"%@",error);
    [self.dataTasks removeObjectForKey:sessionTask.cacheKey];
    [sessionTask responseSessionWithResponseObject:nil error:error];
}

@end
