//
//  SessionTask.m
//  ZHFramework
//
//  Created by xzh. on 15/8/17.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <TMCache/TMCache.h>

#import "HZMacro.h"
#import "HZNetworkConst.h"
#import "NSString+HZExtend.h"
#import "NSDictionary+HZExtend.h"
#import "HZSessionTask.h"
#import "HZNetworkConfig.h"
#import "HZNetwork.h"

@interface HZSessionTask ()

@property(nonatomic, copy) NSString *taskIdentifier;
@property(nonatomic, assign) BOOL isUpload; //标识是否为上传任务
@property(nonatomic, assign) HZSessionTaskState state;
@property(nonatomic, assign) HZSessionTaskCacheImportState cacheImportState;
@property(nonatomic, copy) NSString *method;
@property(nonatomic, strong) NSMutableDictionary <NSString *, NSString *> *mutableRequestHeader;

@property(nonatomic, strong) NSDictionary *responseObject;
@property(nonatomic, strong) NSError *error;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, strong) NSProgress *progress;

@property(nonatomic, assign) BOOL hasImportCache;


@end

@implementation HZSessionTask
#pragma mark - Initialization
+ (instancetype)taskWithMethod:(NSString *)method
                          path:(NSString *)path
                        params:(NSMutableDictionary *)params
                      delegate:(id<HZSessionTaskDelegate>)delegate taskIdentifier:(NSString *)taskIdentifier
{
    NSAssert(taskIdentifier.isNoEmpty, @"HZSessionTask:taskIdentifier必须不能为空");
    HZSessionTask *task = [[self alloc] init];
    task.method = method;
    task.path = path;
    task.params = params;
    task.delegate = delegate;
    task.taskIdentifier = taskIdentifier;
    task.cached = YES;
    task.isUpload = NO;
    return task;
}

+ (instancetype)taskWithMethod:(NSString *)method
                          path:(NSString *)path
                        params:(NSMutableDictionary *)params
                      pathKeys:(NSArray *)keys
                      delegate:(id<HZSessionTaskDelegate>)delegate
                   taskIdentifier:(NSString *)taskIdentifier
{
    HZSessionTask *task = [self taskWithMethod:method path:path params:params delegate:delegate taskIdentifier:taskIdentifier];
    task.pathkeys = keys;
    return task;
}

+ (instancetype)uploadTaskWithPath:(NSString *)path
                            params:(NSMutableDictionary<NSString *,id> *)params
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
    BOOL resulte = !key.isNoEmpty || (value == nil);
    HZAssertNoReturn(resulte, @"header error")
    
    [self.mutableRequestHeader setValue:value forKey:key];
}

#pragma mark - Public Method
- (void)startWithHandler:(void (^)(HZSessionTask * _Nonnull, NSError * _Nullable))handler
{
    NSAssert(self.path.isNoEmpty, @"path nil");
    HZAssertNoReturn(self.state != HZSessionTaskStateRunable, @"task has run already");
    
    [self resetAllOutputData];
    NSString *cancelMsg = nil;
    if ([self.delegate respondsToSelector:@selector(taskShouldPerform:)]) {
        cancelMsg = [self.delegate taskShouldPerform:self];
    }
    if (cancelMsg) {
        self.error = [NSError errorWithDomain:@"com.HZNetwork" code:NSURLErrorBadURL userInfo:@{@"NSLocalizedDescription":cancelMsg}];
        if (handler) { handler(self, self.error); }
        [self prepareToRunable];
        return;
    }
    
    if (handler) { handler(self, self.error); }
    HZWeakObj(self);
    if (self.isUpload) {
        [[HZNetwork sharedNetwork] performUploadTask:self progress:^(NSProgress * _Nonnull uploadProgress) {
            HZStrongObj(self);
            if (strong_self.uploadProgressBlock) {
                strong_self.uploadProgressBlock(strong_self, uploadProgress);
            }
        } completion:^(HZNetwork * _Nonnull performer, id  _Nullable responseObject, NSError * _Nullable error) {
            HZStrongObj(self);
            [strong_self taskCompletionWithResponseObject:responseObject error:error];
        }];
    }else {
        [[HZNetwork sharedNetwork] performTask:self completion:^(HZNetwork * _Nonnull performer, id  _Nullable responseObject, NSError * _Nullable error) {
            HZStrongObj(self);
            [strong_self taskCompletionWithResponseObject:responseObject error:error];
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

- (void)startWithCompletionCallBack:(HZSessionTaskDidCompletedBlock)completionCallBack
                    sendingCallBack:(HZSessionTaskSendingBlock)sendingCallBack
{
    self.taskDidCompletedBlock = completionCallBack;
    self.taskSendingBlock = sendingCallBack;
    [self start];
}


- (void)startWithCompletion:(HZSessionTaskDidCompletedBlock)completion
{
    [self startWithCompletionCallBack:completion sendingCallBack:nil];
}

- (void)startUploadWithCompletionCallBack:(HZSessionTaskDidCompletedBlock)completionCallBack
                           uploadCallBack:(HZSessionTaskUploadProgressBlock)uploadCallBack
{
    self.taskDidCompletedBlock = completionCallBack;
    self.uploadProgressBlock = uploadCallBack;
    [self start];
}

- (void)cancel
{
    [[HZNetwork sharedNetwork] cancelTask:self];
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
        NSDictionary *responseObject = [[TMCache sharedCache] objectForKey:self.cacheKey];
        if (responseObject.isNoEmpty) {
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
        if (error.code == NSURLErrorNotConnectedToInternet) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
            NSString *networkLostErrorMsg = [HZNetworkConfig sharedConfig].networkLostErrorMsg;
            if (networkLostErrorMsg.isNoEmpty) {
                [userInfo setObject:networkLostErrorMsg forKey:NSLocalizedDescriptionKey];
            }
            self.error = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
        }else {
            self.error = error;
        }
        self.state = HZSessionTaskStateFail;

        HZLog(HZ_RESPONSE_LOG_FORMAT,self.absoluteURL,self.message);
    }else {
        self.responseObject = responseObject;
        BOOL codeRight = [self codeIsRight];
        if (codeRight) {
            self.state = HZSessionTaskStateSuccess;
            self.error = nil;
            //对有效数据进行缓存
            if (self.isCached && self.cacheKey.isNoEmpty) {
                [[TMCache sharedCache] setObject:responseObject forKey:self.cacheKey block:^(TMCache *cache, NSString *key, id object) {
                    //HZLog(@"%@ has cached",key);
                }];
            }
        }else {
            self.state = HZSessionTaskStateFail;
            id error = [self.responseObject objectForKeyPath:[HZNetworkConfig sharedConfig].codeKeyPath];
            NSNumber *errorCode = @(NSURLErrorBadServerResponse);
            if ([error isKindOfClass:[NSNumber class]]) {
                errorCode = error;
            }
            self.error = [NSError errorWithDomain:@"com.HZNetwork" code:errorCode.integerValue userInfo:@{@"NSLocalizedDescription":self.message}];;
            HZLog(HZ_RESPONSE_LOG_FORMAT,self.absoluteURL,self.message);
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
    if (!codeKeyPath.isNoEmpty) return YES;
    
    return self.responseObject.isNoEmpty && [[self.responseObject objectForKeyPath:codeKeyPath] integerValue] == [HZNetworkConfig sharedConfig].rightCode;
}

- (void)callBackTaskStatus
{
    if (self.state == HZSessionTaskStateRunning) {
        if ([self.delegate respondsToSelector:@selector(taskSending:)]) {
            [self.delegate taskSending:self];
        }
        if (self.taskSendingBlock) {
            self.taskSendingBlock(self);
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

#pragma mark - Setter
- (void)setResponseObject:(NSDictionary *)responseObject
{
    _responseObject = responseObject;
    
    NSString * msgKeyPath = [HZNetworkConfig sharedConfig].msgKeyPath;
    if (msgKeyPath.isNoEmpty) {
        _message = [responseObject objectForKeyPath:msgKeyPath]?:@"";
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
    NSString *cacheKey = @"";
    if([self.method caseInsensitiveCompare:@"GET"] == NSOrderedSame){
        cacheKey = self.absoluteURL.md5;
    }else if ([self.method caseInsensitiveCompare:@"POST"] == NSOrderedSame){
        cacheKey = self.params.isNoEmpty?[self.absoluteURL stringByAppendingString:self.params.keyValueString].md5:self.absoluteURL;
    }
    return cacheKey;
}

- (NSString *)absoluteURL
{
    NSString *absoluteURL = @"";
    if (self.path.isNoEmpty) {
            NSString *baseURL = self.baseURL?:[HZNetworkConfig sharedConfig].baseURL;
            NSAssert(baseURL, @"请设置请求任务的baseURL,推荐使用HZNetworkConfig来设置");
            absoluteURL = [baseURL stringByAppendingString:self.path];
            if ([self.method isEqualToString:@"GET"] && self.params.isNoEmpty) {
                if(self.pathkeys.isNoEmpty) {
                    NSMutableString *pathStr = [NSMutableString string];
                    [self.pathkeys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [pathStr appendFormat:@"/%@",[self.params objectForKey:obj]];
                    }];
                    absoluteURL = [absoluteURL stringByAppendingString:pathStr];  //路径格式
                }else {
                    absoluteURL = [absoluteURL stringByAppendingFormat:@"%@",self.params.keyValueString]; //查询字符串格式
                }
            }
    }
    return absoluteURL;
}

- (NSMutableDictionary<NSString *,id> *)params
{
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}

- (void)dealloc
{
    HZLog(@"%@释放了",self);
}

@end
