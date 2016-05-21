//
//  NetworkConfig.m
//  ZHFramework
//
//  Created by xzh on 16/1/9.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "NetworkConfig.h"
#import "AFNetworking.h"
#import "NSDictionary+HZExtend.h"
#import "NSString+HZExtend.h"
@interface NetworkConfig ()

@property(nonatomic, copy) NSMutableDictionary *headerFields;

@end

@implementation NetworkConfig
singleton_m(Config)

- (instancetype)init
{
    self = [super init];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _headerFields = [NSMutableDictionary dictionary];
        });
    }
    return self;
}

- (void)setupBaseURL:(NSString *)baseURL
           userAgent:(NSString *)userAgent
{
    [self setupBaseURL:baseURL codeKeyPath:nil msgKeyPath:nil userAgent:userAgent rightCode:0];
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
    _userAgent = userAgent;
    
    if (userAgent.isNoEmpty)
        [self.headerFields setObject:userAgent forKey:@"User-Agent"];
}

- (void)addDefaultHeaderFields:(NSDictionary *)headerFields
{
    if (headerFields.isNoEmpty)
    [self.headerFields addEntriesFromDictionary:headerFields];
}

- (NSDictionary *)defaultHeaderFields
{
    return self.headerFields;
}

- (BOOL)reachable
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

@end
