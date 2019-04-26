//
//  HZNetworkConfig.m
//  HZNetwork
//
//  Created by xzh. on 16/1/9.
//  Copyright (c) 2016年 xzh. All rights reserved.
//

#import "HZNetworkConfig.h"
#import "AFNetworking.h"
#import "HZNetworkAction.h"

@interface HZNetworkConfig ()

@property(nonatomic, copy) NSMutableDictionary *headerFields;
@property(nonatomic, copy) NSString *userAgent;
@property(nonatomic, strong) id<HZNetworkCache> cacheHandler;

@end

@implementation HZNetworkConfig
#pragma mark - Initialization
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

+ (instancetype)sharedConfig
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
            _headerFields = [NSMutableDictionary dictionary];
            _SSLPinningMode = HZSSLPinningModeNone;
            _allowInvalidCertificates = NO;
            _validatesDomainName = true;
        });
    }
    return self;
}

#pragma mark - Public Method
- (void)setupBaseURL:(NSString *)baseURL
           userAgent:(NSString *)userAgent
{
    [self setupBaseURL:baseURL codeKeyPath:nil msgKeyPath:nil userAgent:userAgent rightCode:NSNotFound];
}

-  (void)setupBaseURL:(NSString *)baseURL
          codeKeyPath:(NSString *)codeKeyPath
           msgKeyPath:(NSString *)msgKeyPath
            userAgent:(NSString *)userAgent
            rightCode:(NSUInteger)rightCode;
{
    _baseURL = baseURL;
    _codeKeyPath = codeKeyPath;
    _msgKeyPath = msgKeyPath;
    _rightCode = rightCode;
    self.userAgent = userAgent;
    
    if ([userAgent isKindOfClass:[NSString class]] && userAgent.length > 0) {
        [self addDefaultHeaderFields:@{@"User-Agent":userAgent}];
    }
}

- (void)addDefaultHeaderFields:(NSDictionary *)headerFields
{
    if ([headerFields isKindOfClass:[NSDictionary class]] && headerFields.count > 0) {
        [self.headerFields addEntriesFromDictionary:headerFields];
        self.userAgent = [self.headerFields objectForKey:@"User-Agent"];
        
        [[HZNetworkAction sharedAction] configDefaultRequestHeader:headerFields];
    }
}

- (NSDictionary *)defaultHeaderFields
{
    return self.headerFields;
}

- (void)registerCacheHandler:(id<HZNetworkCache>)cacheHandler
{
    self.cacheHandler = cacheHandler;
}

#pragma mark - Setter
- (void)setUserAgent:(NSString *)userAgent
{
    _userAgent = userAgent;
    
    if ([userAgent isKindOfClass:[NSString class]] && userAgent.length > 0) {
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":userAgent}];
    }
}

@end
