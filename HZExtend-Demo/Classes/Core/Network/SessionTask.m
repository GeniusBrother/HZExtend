//
//  SessionTask.m
//  ZHFramework
//
//  Created by xzh. on 15/8/17.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "SessionTask.h"
#import "HZConst.h"
#import "NetworkConfig.h"
#import "NSString+HZExtend.h"
#import "NSDictionary+HZExtend.h"
#import "TMCache.h"
@interface SessionTask ()
#pragma mark - Input
@property(nonatomic, strong) NSMutableDictionary *httpRequestFields;

#pragma mark - Output
@property(nonatomic, strong) NSDictionary *responseObject;
@property(nonatomic, strong) NSError *error;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, copy) NSString *cacheKey;
@property(nonatomic, copy) NSString *absoluteURL;
@property(nonatomic, assign) NSInteger codeKey;
@property(nonatomic, assign) SessionTaskState state;

@property(nonatomic, assign) BOOL hasImportCache;

@end

@implementation SessionTask
#pragma mark - Init
+ (instancetype)taskWithMethod:(NSString *)method
                          path:(NSString *)path
                        params:(NSMutableDictionary *)params
                      delegate:(id<SessionTaskDelegate>)delegate requestType:(NSString *)type
{

    SessionTask *task = [[self alloc] init];
    task.method = method;
    task.path = path;
    task.params = params;
    task.delegate = delegate;
    task.requestType = type;
    return task;
}

+ (instancetype)taskWithMethod:(NSString *)method
                          path:(NSString *)path
                        params:(NSMutableDictionary *)params
                      pathKeys:(NSArray *)keys
                      delegate:(id<SessionTaskDelegate>)delegate
                   requestType:(NSString *)type
{
    SessionTask *task = [self taskWithMethod:method path:path params:params delegate:delegate requestType:type];
    task.pathkeys = keys;
    return task;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self restAllOutput];
        _httpRequestFields = [NSMutableDictionary dictionary];
        _cached = YES;
        _importCacheOnce = YES;
        _shouldCheckCode = YES;
        _state = SessionTaskStateRunable;
    }
    return self;
}

- (void)restAllOutput
{
    _responseObject = nil;
    _error = nil;
    _message = nil;
    _codeKey = INT_MAX;
    _absoluteURL = nil;
}

- (void)makeTaskReady
{
    self.state = SessionTaskStateRunable;
}

#pragma mark - Output
- (NSString *)cacheKey
{
    if (_cacheKey == nil) {
        
        if(![self.method isEqualToString:@"GET"] && self.params.isNoEmpty){
            _cacheKey = [self.absoluteURL stringByAppendingString:self.params.keyValueString].md5;
        }else {
            _cacheKey = self.absoluteURL.md5;
        }
    }
    return _cacheKey;
}

- (NSDictionary *)httpRequestFields
{
    return _httpRequestFields;
}

/** 配置sessionAddress & absoluteURL
 *  正常模式:baseURL+path
 *  path模式(GET):baseURL+path/v1/v2...
 */

- (NSString *)absoluteURL
{
    if (_absoluteURL == nil) {
        
        if (!self.path.isNoEmpty) {
            _absoluteURL = @"";
        }else {
            NSString *baseURL = self.baseURL?:[NetworkConfig sharedConfig].baseURL;
            _absoluteURL = [baseURL stringByAppendingString:self.path];
            if (self.params.isNoEmpty) {
                if([self.method isEqualToString:@"GET"] && self.pathkeys.isNoEmpty) {
                    NSMutableString *pathStr = [NSMutableString string];
                    [self.pathkeys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [pathStr appendFormat:@"/%@",[self.params objectForKey:obj]];
                    }];
                    _absoluteURL = [_absoluteURL stringByAppendingString:pathStr];  //路径格式
                    
                }else {
                    _absoluteURL = [_absoluteURL stringByAppendingFormat:@"%@",self.params.keyValueString]; //查询字符串
                }
            }
        }
        _cacheKey = nil;
    }
    return _absoluteURL;
}

- (void)setResponseObject:(NSDictionary *)responseObject
{
    _responseObject = responseObject;
    
    NSString * msgKeyPath = [NetworkConfig sharedConfig].msgKeyPath;
    if (msgKeyPath.isNoEmpty) {
        _message = [responseObject objectAtKeyPath:msgKeyPath]?:@"";
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

- (void)setValue:(id)value forHeaderField:(NSString *)key
{
    BOOL resulte = !key.isNoEmpty || (value == nil);
    HZAssertNoReturn(resulte, @"header error")
    
    [self.httpRequestFields setValue:value forKey:key];
}

#pragma mark - Param
- (void)setPage:(NSUInteger)page
{
    [self.params setValue:@(page) forKey:kNetworkPage];
}

- (void)setPageSize:(NSUInteger)pageSize
{
    [self.params setValue:@(pageSize) forKey:kNetworkPageSize];
}

- (NSUInteger)page
{
    NSNumber *page = [self.params objectForKey:kNetworkPage];
    return [page integerValue];
}

- (NSUInteger)pageSize
{
    NSNumber *pageSize = [self.params objectForKey:kNetworkPageSize];
    return [pageSize integerValue];
}

#pragma mark - State
- (BOOL)runable
{
    return SessionTaskStateRunable == _state;
}

- (BOOL)succeed
{
    if (!self.responseObject.isNoEmpty) {
        return NO;
    }
    
    return SessionTaskStateSuccess == _state;
}

- (BOOL)failed
{
    return SessionTaskStateFail == _state;
}

- (BOOL)running
{
    return self.state&SessionTaskStateRunning;
}

- (BOOL)cacheSuccess
{
    if (!self.responseObject.isNoEmpty) {
        return NO;
    }
    
    return self.state&SessionTaskStateCacheSuccess;
}

- (BOOL)cacheFail
{
    return self.state&SessionTaskStateCacheFail;
}

- (BOOL)isCancel
{
    return SessionTaskStateCancel == self.state;
}

#pragma mark - Call-Back
- (void)notifyDataState
{
    if ([NetworkConfig sharedConfig].reachable) {
        if (self.running || self.isCancel) {
            if ([self.delegate respondsToSelector:@selector(taskSending:)]) {
                [self.delegate taskSending:self];
            }
        }else {
        
            if ([self.delegate respondsToSelector:@selector(taskConnected:)]) {
                [self.delegate taskConnected:self];
            }
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(taskLosted:)]) {
            [self.delegate taskLosted:self];
        }
    }
}

#pragma mark - Cache
/**
 *  导入缓存(开始请求时导入缓存或无网情况下直接导入缓存)
 *  1.设置基本数据:responseObject | Error |state
 *  2.通知
 */
- (void)importCache
{
    if (self.isCached) {
        //在没有导过缓存和可以多次导入缓存的情况下尝试导入缓存
        if (!self.hasImportCache || self.importCacheOnce == NO ) {
            if (self.cacheKey.isNoEmpty) {
                NSDictionary *responseObject = [[TMCache sharedCache] objectForKey:self.cacheKey];
                if (responseObject.isNoEmpty) {
                    self.responseObject = responseObject;
                    self.state = self.state | SessionTaskStateCacheSuccess;
                    self.error = [NetworkConfig sharedConfig].reachable?nil:[NSError errorWithDomain:@"HZNetwork" code:1 userInfo:@{@"NSLocalizedDescription":@"似乎已断开与互联网的连接"}];
                }else {
                    self.state = self.state | SessionTaskStateCacheFail;
                    self.error = [NetworkConfig sharedConfig].reachable?nil:[NSError errorWithDomain:@"HZNetwork" code:1 userInfo:@{@"NSLocalizedDescription":@"似乎已断开与互联网的连接"}];
                }
                _hasImportCache = YES;
            }
        }else {
            self.state = self.state | SessionTaskStateCacheNoTry;
            self.error = [NetworkConfig sharedConfig].reachable?[NSError errorWithDomain:@"HZNetwork" code:0 userInfo:@{@"NSLocalizedDescription":@"error"}]:[NSError errorWithDomain:@"HZNetwork" code:1 userInfo:@{@"NSLocalizedDescription":@"似乎已断开与互联网的连接"}];
        }
    }

    [self notifyDataState];
}

#pragma mark - Control
- (void)startSession
{
    self.state = SessionTaskStateRunning;

    [self importCache];
}

- (void)responseSessionWithResponseObject:(NSDictionary *)responseObject error:(NSError *)error
{
    /**************success**************/
    if (responseObject.isNoEmpty) {
        /**************设置输出**************/
        self.responseObject = responseObject;
        BOOL codeRight = [self checkCode];
        self.state = codeRight?SessionTaskStateSuccess:SessionTaskStateFail;
        self.error = codeRight?nil:[NSError errorWithDomain:@"HZNetwork" code:3 userInfo:@{@"NSLocalizedDescription":self.message}];
        
        /**************通知**************/
        [self notifyDataState];
        
        //设置缓存(出错信息没有缓存)
        if (self.isCached && self.cacheKey.isNoEmpty && codeRight) {
            [[TMCache sharedCache] setObject:responseObject forKey:self.cacheKey block:^(TMCache *cache, NSString *key, id object) {
                //                HZLog(@"%@ has cached",key);
            }];
        }
    }else { /**************fail**************/
        
        //**************设置输出**************/
        self.error = error;
        self.state = [self.message isEqualToString:@"cancelled"]?SessionTaskStateCancel:SessionTaskStateFail;
        
        [self notifyDataState];
    }
    
    //准备重新运行
    [self makeTaskReady];
}

- (void)noReach
{
    self.state = SessionTaskStateNoReach;
    
    [self importCache];
    
    [self makeTaskReady];
}

/**
 *  判断业务逻辑是否成功
 */
- (BOOL)checkCode
{
    //没有设置状态码路径则不需要检查
    NSString *codeKeyPath = [NetworkConfig sharedConfig].codeKeyPath;
    if (!codeKeyPath.isNoEmpty) return true;
    
    if (self.shouldCheckCode) {
        self.codeKey = [[self.responseObject objectAtKeyPath:codeKeyPath] integerValue];
        if(self.codeKey == [NetworkConfig sharedConfig].rightCode) {
            return true;
        }else {
            return false;
        }
    }else {
        return true;
    }
}


//- (void)dealloc
//{
//    HZLog(@"%@释放了",self);
//}

@end
