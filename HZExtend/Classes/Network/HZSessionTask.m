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

@property(nonatomic, copy) NSString *method;
@property(nonatomic, copy) NSString *path;
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
- (void)setFileName:(NSString *)fileName formName:(NSString *)formName mimeType:(NSString *)mimeType
{
    self.formName = formName;
    self.fileName = fileName;
    self.mimeType = mimeType;
}

- (void)setFileData:(NSData *)fileData formName:(NSString *)formName fileName:(NSString *)fileName mimeType:(NSString *)mimeType
{
    self.fileData = fileData;
    self.formName = formName;
    self.fileName = fileName;
    self.mimeType = mimeType;
}

- (void)start
{
    NSAssert(self.path.isNoEmpty, @"path nil");
    HZAssertNoReturn(self.state == HZSessionTaskStateRunable, @"task has run already");
    
    [self resetAllOutputData];
    BOOL shouldPerform = YES;
    if ([self.delegate respondsToSelector:@selector(taskShouldPerform:)]) {
        shouldPerform = [self.delegate taskShouldPerform:self];
    }
    if (!shouldPerform) {
        self.state = HZSessionTaskStateRunning | HZSessionTaskStateCancel;
        [self callBackTaskStatus];
        [self prepareToRunable];
        return;
    }
    
    if ([HZNetworkConfig sharedConfig].reachable) {
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
    }else {
        self.state = HZSessionTaskStateLost;
        self.error = [NSError errorWithDomain:@"com.HZNetwork" code:2 userInfo:@{@"NSLocalizedDescription":@"似乎已断开与互联网的连接"}];
        [self loadCacheData];
        [self callBackTaskStatus];
        [self prepareToRunable];
    }
}

- (void)startWithCompletionCallBack:(HZSessionTaskDidCompletedBlock)completionCallBack
                    sendingCallBack:(HZSessionTaskSendingBlock)sendingCallBack
                       lostCallBack:(HZSessionTaskDidLoseBlock)lostCallBack
{
    self.taskDidCompletedBlock = completionCallBack;
    self.taskSendingBlock = sendingCallBack;
    self.taskDidLoseBlock = lostCallBack;
    [self start];
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
    self.state = HZSessionTaskStateRunning | HZSessionTaskStateCancel;
    self.error = [NSError errorWithDomain:@"com.HZNetwork" code:3 userInfo:@{@"NSLocalizedDescription":@"用户取消"}];
    [self callBackTaskStatus];
    [self prepareToRunable];
}

#pragma mark - Private Method
//准备重新运行
- (void)prepareToRunable
{
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
        self.state = HZSessionTaskStateLost | HZSessionTaskStateCacheNoTry;
        return;
    }
    //在没有导过缓存和可以多次导入缓存的情况下尝试导入缓存
    if (!self.hasImportCache || self.importCacheOnce == NO ) {
        NSDictionary *responseObject = [[TMCache sharedCache] objectForKey:self.cacheKey];
        if (responseObject.isNoEmpty) {
            self.responseObject = responseObject;
            self.state = self.state | HZSessionTaskStateCacheSuccess;
        }else {
            self.state = self.state | HZSessionTaskStateCacheFail;
        }
        _hasImportCache = YES;
    }else {
        self.state = self.state | HZSessionTaskStateCacheNoTry;
    }
}

- (void)taskCompletionWithResponseObject:(id)responseObject error:(NSError *)error
{
    if (self.error) {
        self.state = HZSessionTaskStateCompleted | HZSessionTaskStateFail;
        self.error = error;
        HZLog(HZ_RESPONSE_LOG_FORMAT,self.absoluteURL,self.message);
    }else {
        self.responseObject = responseObject;
        BOOL codeRight = [self codeIsRight];
        if (codeRight) {
            self.state = HZSessionTaskStateCompleted | HZSessionTaskStateSuccess;
            self.error = nil;
            //对有效数据进行缓存
            if (self.isCached && self.cacheKey.isNoEmpty) {
                [[TMCache sharedCache] setObject:responseObject forKey:self.cacheKey block:^(TMCache *cache, NSString *key, id object) {
                    //HZLog(@"%@ has cached",key);
                }];
            }
        }else {
            self.state = HZSessionTaskStateCompleted | HZSessionTaskStateFail;
            self.error = [NSError errorWithDomain:@"com.HZNetwork" code:1 userInfo:@{@"NSLocalizedDescription":self.message}];;
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
    
    return [[self.responseObject objectForKeyPath:codeKeyPath] integerValue] == [HZNetworkConfig sharedConfig].rightCode;
}

- (void)callBackTaskStatus
{
    if ([self isLost]) {
        if ([self.delegate respondsToSelector:@selector(taskDidLose:)]) {
            [self.delegate taskDidLose:self];
        }
        if (self.taskDidLoseBlock) {
            self.taskDidLoseBlock(self);
        }
    }else if (self.isRunning) {
        if ([self.delegate respondsToSelector:@selector(taskSending:)]) {
            [self.delegate taskSending:self];
        }
        if (self.taskSendingBlock) {
            self.taskSendingBlock(self);
        }
    }else if([self isCompleted]) {
        if ([self.delegate respondsToSelector:@selector(taskDidCompleted:)]) {
            [self.delegate taskDidCompleted:self];
        }
        if (self.taskDidCompletedBlock) {
            self.taskDidCompletedBlock(self);
        }
    }
}

#pragma mark - State
- (BOOL)isSuccess
{
    return self.state & HZSessionTaskStateSuccess;
}

- (BOOL)isFail
{
    return self.state & HZSessionTaskStateFail;
}

- (BOOL)isCompleted
{
    return self.state & HZSessionTaskStateCompleted;
}

- (BOOL)isRunning
{
    return self.state & HZSessionTaskStateRunning;
}

- (BOOL)isLost
{
    return self.state & HZSessionTaskStateLost;
}

- (BOOL)isCacheSuccess
{
    return self.state & HZSessionTaskStateCacheSuccess;
}

- (BOOL)isCacheFail
{
    return self.state & HZSessionTaskStateCacheFail;
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

- (void)dealloc
{
    HZLog(@"%@释放了",self);
}

@end
