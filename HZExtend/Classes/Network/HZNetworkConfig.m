//
//  NetworkConfig.m
//  ZHFramework
//
//  Created by xzh on 16/1/9.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "HZNetworkConfig.h"
#import "AFNetworking.h"
#import "NSDictionary+HZExtend.h"
#import "NSString+HZExtend.h"

NSString *const kNetworkPage = @"page";
NSString *const kNetworkPageSize = @"pageSize";

@interface HZNetworkConfig ()

@property(nonatomic, copy) NSMutableDictionary *headerFields;
@property(nonatomic, copy) NSString *userAgent;

@end

@implementation HZNetworkConfig
#pragma mark - Initialization
singleton_m(Config)

- (instancetype)init
{
    self = [super init];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _headerFields = [NSMutableDictionary dictionary];
            _SSLPinningMode = HZSSLPinningModeNone;
            _allowInvalidCertificates = NO;
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
    
    if (userAgent.isNoEmpty)
        [self.headerFields setObject:userAgent forKey:@"User-Agent"];
}

- (void)addDefaultHeaderFields:(NSDictionary *)headerFields
{
    if (headerFields.isNoEmpty) {
        [self.headerFields addEntriesFromDictionary:headerFields];
        self.userAgent = [self.headerFields objectForKey:@"User-Agent"];
    }
    
}

- (NSDictionary *)defaultHeaderFields
{
    return self.headerFields;
}

#pragma mark - Setter
- (void)setUserAgent:(NSString *)userAgent
{
    _userAgent = userAgent;
    
    if (userAgent.isNoEmpty) {
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":userAgent}];
    }
}
@end
