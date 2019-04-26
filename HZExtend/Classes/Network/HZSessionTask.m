//
//  HZSessionTask.m
//  HZNetwork
//
//  Created by xzh. on 15/8/17.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "HZNetworkConst.h"
#import "HZSessionTask.h"
#import "HZNetworkConfig.h"
#import "HZNetworkAction.h"
#import "NSDictionary+Helper.h"
#import "NSString+URL.h"

@interface HZSessionTask ()

@property(nonatomic, copy) NSString *taskIdentifier;
@property(nonatomic, assign) BOOL isUpload; //标识是否为上传任务
@property(nonatomic, assign) HZSessionTaskState state;
@property(nonatomic, assign) HZSessionTaskCacheImportState cacheImportState;
@property(nonatomic, copy) NSString *method;
@property(nonatomic, strong) NSMutableDictionary <NSString *, NSString *> *mutableRequestHeader;

@property(nonatomic, strong) id responseObject;
@property(nonatomic, strong) NSError *error;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, strong) NSProgress *progress;

@property(nonatomic, assign) BOOL hasImportCache;


@end

@implementation HZSessionTask
#pragma mark - Initialization
+ (instancetype)taskWithMethod:(NSString *)method
                          path:(NSString *)path
                        params:(NSDictionary *)params
                      delegate:(id<HZSessionTaskDelegate>)delegate taskIdentifier:(NSString *)taskIdentifier
{
    NSAssert(taskIdentifier, @"HZSessionTask:taskIdentifier必须不能为空");
    HZSessionTask *task = [[self alloc] init];
    task.method = method;
    task.path = path;
    task.params = params?[NSMutableDictionary dictionaryWithDictionary:params]:nil;
    task.delegate = delegate;
    task.taskIdentifier = taskIdentifier;
    task.cached = [HZNetworkConfig sharedConfig].taskShouldCache;
    task.isUpload = NO;
    return task;
}

+ (instancetype)taskWithMethod:(NSString *)method
                          path:(NSString *)path
                    pathValues:(NSArray *)pathValues
                      delegate:(id<HZSessionTaskDelegate>)delegate
                   taskIdentifier:(NSString *)taskIdentifier
{
    HZSessionTask *task = [self taskWithMethod:method path:path params:nil delegate:delegate taskIdentifier:taskIdentifier];
    task.pathValues = pathValues?[NSMutableArray arrayWithArray:pathValues]:nil;
    return task;
}

+ (nullable instancetype)taskWithMethod:(NSString *)method
                              URLString:(NSString *)URLString
                                 params:(nullable NSDictionary<NSString *,id> *)params
                               delegate:(id<HZSessionTaskDelegate>)delegate
                         taskIdentifier:(NSString *)taskIdentifier
{
    NSURL *url = [NSURL URLWithString:URLString];
    if (!url) return nil;
    
    NSString *path = url.path;
    NSString *baseURL = [NSString stringWithFormat:@"%@://%@%@",url.scheme,url.host,url.port?[NSString stringWithFormat:@":%@",url.port]:@""];
    HZSessionTask *task = [self taskWithMethod:method path:path params:params delegate:delegate taskIdentifier:taskIdentifier];
    task.baseURL = baseURL;
    
    return task;
}

+ (instancetype)uploadTaskWithPath:(NSString *)path
                            params:(NSDictionary<NSString *,id> *)params
                          delegate:(id<HZSessionTaskDelegate>)delegate
                    taskIdentifier:(NSString *)taskIdentifier
{
    HZSessionTask *task = [self taskWithMethod:@"POST" path:path params:params delegate:delegate taskIdentifier:taskIdentifier];
    task.cached = NO;
    task.isUpload = YES;
    return task;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mutableRequestHeader = [NSMutableDictionary dictionary];
        _importCacheOnce = YES;
        _state = HZSessionTaskStateRunable;
        _cacheImportState = HZSessionTaskCacheImportStateNone;
        _isFirstRequest = YES;
    }
    return self;
}

#pragma mark - Public Method
- (void)setValue:(NSString *)value forHeaderField:(NSString *)key
{
    BOOL invalid = !(key.length > 0) || (value == nil);
    if (invalid) return;
    
    [self.mutableRequestHeader setValue:value forKey:key];
}

#pragma mark - Public Method
- (void)startWithHandler:(void (^)(HZSessionTask * _Nonnull, NSError * _Nullable))handler
{
    if (self.state != HZSessionTaskStateRunable) {
//        HZLog(@"%@",@"task has run already");
        return;
    }
    [self resetAllOutputData];
    NSString *stopMsg = nil;
    BOOL stop = NO;
    if ([self.delegate respondsToSelector:@selector(taskShouldStop:stopMessage:)]) {
        stop = [self.delegate taskShouldStop:self stopMessage:&stopMsg];
    }
    if (stop) {
        self.error = [NSError errorWithDomain:@"com.HZNetwork" code:NSURLErrorBadURL userInfo:@{@"NSLocalizedDescription":stopMsg}];
        if (handler) { handler(self, self.error); }
        [self prepareToRunable];
        return;
    }
    
    if (handler) { handler(self, self.error); }
    __weak typeof(self) weakSelf = self;
    if (self.isUpload) {
        [[HZNetworkAction sharedAction] performUploadTask:self progress:^(NSProgress * _Nonnull uploadProgress) {
            
            if (weakSelf.uploadProgressBlock) {
                weakSelf.uploadProgressBlock(weakSelf, uploadProgress);
            }
        } completion:^(HZNetworkAction * _Nonnull performer, id  _Nullable responseObject, NSError * _Nullable error) {
            [weakSelf taskCompletionWithResponseObject:responseObject error:error];
        }];
    }else {
        [[HZNetworkAction sharedAction] performTask:self completion:^(HZNetworkAction * _Nonnull performer, id  _Nullable responseObject, NSError * _Nullable error) {
            [weakSelf taskCompletionWithResponseObject:responseObject error:error];
        }];
    }
    self.state = HZSessionTaskStateRunning;
    [self loadCacheData];
    [self callBackTaskStatus];
}

- (void)start
{
    [self startWithHandler:nil];
}

- (void)startWithCompletion:(HZSessionTaskDidCompletedBlock)completion didSend:(HZSessionTaskDidSendBlock)didSend
{
    self.taskDidCompletedBlock = completion;
    self.taskDidSendBlock = didSend;
    [self start];
}

- (void)startWithCompletion:(HZSessionTaskDidCompletedBlock)completion
{
    [self startWithCompletion:completion didSend:nil];
}

- (void)cancel
{
    [[HZNetworkAction sharedAction] cancelTask:self];
    self.state = HZSessionTaskStateCancel;
    self.error = [NSError errorWithDomain:@"com.HZNetwork" code:NSURLErrorCancelled userInfo:nil];
    [self callBackTaskStatus];
    [self prepareToRunable];
}

#pragma mark - Private Method
//准备重新运行
- (void)prepareToRunable
{
    _isFirstRequest = NO;
    self.state = HZSessionTaskStateRunable;
}

- (void)resetAllOutputData
{
    self.responseObject = nil;
    self.error = nil;
    self.message = nil;
    self.progress = nil;
}

- (void)loadCacheData
{
    //没有缓存数据就不导入缓存
    if (!self.isCached) {
        self.cacheImportState = HZSessionTaskCacheImportStateFail;
        return;
    }
    //在没有导过缓存和可以多次导入缓存的情况下尝试导入缓存
    if (!self.hasImportCache || self.importCacheOnce == NO ) {
        id<HZNetworkCache> cacheHandler = [HZNetworkConfig sharedConfig].cacheHandler;
        id responseObject = nil;
        if ([cacheHandler respondsToSelector:@selector(cacheForKey:)]) {
            responseObject = [[HZNetworkConfig sharedConfig].cacheHandler cacheForKey:self.cacheKey];
        }
        if (responseObject) {
            self.responseObject = responseObject;
            self.cacheImportState =  HZSessionTaskCacheImportStateSuccess;
        }else {
            self.cacheImportState = HZSessionTaskCacheImportStateFail;
        }
        _hasImportCache = YES;
    }else {
        self.cacheImportState = HZSessionTaskCacheImportStateFail;
    }
}

- (void)taskCompletionWithResponseObject:(id)responseObject error:(NSError *)error
{
    if (error) {
        self.responseObject = responseObject;
        if (error.code == NSURLErrorNotConnectedToInternet) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
            NSString *networkLostErrorMsg = [HZNetworkConfig sharedConfig].networkLostErrorMsg;
            if (networkLostErrorMsg) {
                [userInfo setObject:networkLostErrorMsg forKey:NSLocalizedDescriptionKey];
            }
            self.error = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
        }else {
            self.error = error;
        }
        self.state = HZSessionTaskStateFail;
#if DEBUG
        NSLog(HZ_RESPONSE_LOG_FORMAT,self.absoluteURL,[self.params hzn_jsonString],self.message);
#endif
    }else {
        self.responseObject = responseObject;
        BOOL codeRight = [self codeIsRight];
        if (codeRight) {
            self.state = HZSessionTaskStateSuccess;
            self.error = nil;
            //对有效数据进行缓存
            if (self.isCached && self.cacheKey) {
                id<HZNetworkCache> cacheHandler = [HZNetworkConfig sharedConfig].cacheHandler;
                if ([cacheHandler respondsToSelector:@selector(setCache:forKey:)]) {
                    [cacheHandler setCache:responseObject forKey:self.cacheKey];
                }
            }
        }else {
            self.state = HZSessionTaskStateFail;
            NSNumber *errorCode = @(NSURLErrorBadServerResponse);
            NSString *codeKeyPath = [HZNetworkConfig sharedConfig].codeKeyPath;
            if (codeKeyPath) {
                id error = [self.responseObject valueForKeyPath:codeKeyPath];
                if ([error isKindOfClass:[NSNumber class]]) {
                    errorCode = error;
                }
            }
            self.error = [NSError errorWithDomain:@"com.HZNetwork" code:errorCode.integerValue userInfo:@{@"NSLocalizedDescription":self.message}];
#if DEBUG
    NSLog(HZ_RESPONSE_LOG_FORMAT,self.absoluteURL,[self.params hzn_jsonString],self.message);
#endif
        }
    }
    [self callBackTaskStatus];
    [self prepareToRunable];
}

/** 判断业务逻辑是否成功 **/
- (BOOL)codeIsRight
{
    //没有设置状态码路径或者不需要checkCode返回YES
    NSString *codeKeyPath = [HZNetworkConfig sharedConfig].codeKeyPath;
    if (!codeKeyPath) return YES;
    
    return self.responseObject && [[self.responseObject valueForKeyPath:codeKeyPath] integerValue] == [HZNetworkConfig sharedConfig].rightCode;
}

- (void)callBackTaskStatus
{
    if (self.state == HZSessionTaskStateRunning) {
        if ([self.delegate respondsToSelector:@selector(taskDidSend:)]) {
            [self.delegate taskDidSend:self];
        }
        if (self.taskDidSendBlock) {
            self.taskDidSendBlock(self);
        }
    }else if(self.state == HZSessionTaskStateSuccess || self.state == HZSessionTaskStateFail) {
        if ([self.delegate respondsToSelector:@selector(taskDidCompleted:)]) {
            [self.delegate taskDidCompleted:self];
        }
        if (self.taskDidCompletedBlock) {
            self.taskDidCompletedBlock(self);
        }
    }else if (self.state == HZSessionTaskStateCancel) {
        if ([self.delegate respondsToSelector:@selector(taskDidCancel:)]) {
            [self.delegate taskDidCancel:self];
        }
        if (self.taskDidCancelBlock) {
            self.taskDidCancelBlock(self);
        }
    }
}

- (NSString *)keyValueStringWithDic:(NSDictionary *)dic
{
    if (!(![dic isKindOfClass:[NSNull class]] && dic.count > 0)) return nil;
    
    NSMutableString *string = [NSMutableString string];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [string appendFormat:@"%@=%@&",key,obj];
    }];
    
    NSRange range = [string rangeOfString:@"&" options:NSBackwardsSearch];
    [string deleteCharactersInRange:range];
    
    return string;
}


#pragma mark - Setter
- (void)setResponseObject:(id)responseObject
{
    _responseObject = responseObject;
    
    NSString * msgKeyPath = [HZNetworkConfig sharedConfig].msgKeyPath;
    if (msgKeyPath) {
        _message = [responseObject valueForKeyPath:msgKeyPath]?:@"";
    }else {
        _message = @"";
    }
}

- (void)setError:(NSError *)error
{
    _error = error;
    
    if(_error.userInfo) {
        _message = [_error.userInfo objectForKey:@"NSLocalizedDescription"]?:@"";
    }
}

#pragma mark - Getter
- (NSDictionary<NSString *,NSString *> *)requestHeader
{
    return [NSDictionary dictionaryWithDictionary:self.mutableRequestHeader];
}

- (NSString *)cacheKey
{
    NSString *identifierURL = @"";
    NSString *headerKeyValue = [self keyValueStringWithDic:self.requestHeader];
    if([self.method caseInsensitiveCompare:@"GET"] == NSOrderedSame){
        identifierURL = self.absoluteURL;
    }else if ([self.method caseInsensitiveCompare:@"POST"] == NSOrderedSame){
        identifierURL = [self.absoluteURL stringByAppendingFormat:@"?%@",self.params?[self keyValueStringWithDic:self.params]:@""];
    }
    
    if (headerKeyValue) {
        identifierURL = [identifierURL stringByAppendingString:headerKeyValue];
    }
    
    NSString *cacheKey = [identifierURL hzn_md5String];
    return cacheKey;
}

- (NSString *)absoluteURL
{
    NSString *absoluteURL = self.requestPath;
    
    if ([self.method caseInsensitiveCompare:@"GET"] == NSOrderedSame && self.params.count > 0) {
        NSString *separator = [absoluteURL rangeOfString:@"?"].length == 0?@"?":@"&";
        absoluteURL = [absoluteURL stringByAppendingFormat:@"%@%@",separator,[self keyValueStringWithDic:self.params]]; //查询字符串格式
    }
    
    return absoluteURL;
}

- (NSString *)requestPath
{
    NSString *baseURL = self.baseURL?:[HZNetworkConfig sharedConfig].baseURL;
    NSAssert(baseURL, @"请设置baseURL 推荐使用HZNetworkConfig来设置统一baseURL");
    
    NSString *requestPath = baseURL;
    if (self.path) requestPath = [requestPath stringByAppendingString:self.path];
    
    if(self.pathValues && self.path) {
        NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@":\\w+" options:0 error:nil];
        NSArray* matches = [reg matchesInString:requestPath options:0 range:NSMakeRange(0, requestPath.length)];
        if (matches.count == self.pathValues.count) {
            for (NSInteger idx = matches.count - 1; idx>=0; idx--) {
                id replaceValue = [self.pathValues objectAtIndex:idx];
                if ([replaceValue isKindOfClass:[NSString class]]) replaceValue = [(NSString *)replaceValue hzn_urlEncode];
                    
                NSTextCheckingResult* result = matches[idx];
                requestPath = [requestPath stringByReplacingCharactersInRange:result.range withString:[NSString stringWithFormat:@"%@",replaceValue]];
            }
        }else {
           NSAssert(NO, @"Missing path value");
        }
    }
    
    return requestPath;
}

- (NSMutableDictionary<NSString *,id> *)params
{
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}

@end
