//
//  HZNetworkConfig.h
//  HZNetwork
//
//  Created by xzh. on 16/1/9.
//  Copyright (c) 2016年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZNetworkCache.h"
typedef NS_ENUM(NSUInteger, HZSSLPinningMode) {
    HZSSLPinningModeNone,       //验证返回的证书是否由受信任的机构颁发
    HZSSLPinningModePublicKey,  //验证返回的证书的公钥是否与本地的副本一致
    HZSSLPinningModeCertificate,//验证返回的证书是否过去，全部内容是否与本地一致
};

NS_ASSUME_NONNULL_BEGIN

/**
 Provides config for HZNetwork.
 */
@interface HZNetworkConfig : NSObject

/** The default base URL for 'HZSessiontask'.*/
@property(nonatomic, copy, readonly) NSString *baseURL;

/** The path of status code which is used by 'HZSessiontask' to get status code from response data.*/
@property(nullable, nonatomic, copy, readonly) NSString *codeKeyPath;

/** The path of tip message which is used by 'HZSessiontask' to get tip message from response data. */
@property(nullable, nonatomic, copy, readonly) NSString *msgKeyPath;

/** Sets the default User-Agent for http. */
@property(nullable, nonatomic, copy, readonly) NSString *userAgent;

/** The value of success code. it is used to determine whether the task is successful. */
@property(nonatomic, assign, readonly) NSUInteger rightCode;

/** The default http header field. */
@property(nonatomic, copy, readonly) NSDictionary<NSString *, NSString *> *defaultHeaderFields;

/**  Whether or not to trust servers with an invalid or expired SSL certificates. Defaults to `NO`. */
@property(nonatomic, assign) BOOL allowInvalidCertificates;

/** 
 The criteria by which server trust should be evaluated against the pinned SSL certificates. Defaults to `HZSSLPinningModeNone`.
 */
@property(nonatomic, assign) HZSSLPinningMode SSLPinningMode;

/** The tip message when network can't connect.*/
@property(nonatomic, copy) NSString *networkLostErrorMsg;

/** The handler is used to set/get cache data for 'HZSessiontask'. */
@property(nonatomic, strong, readonly) id<HZNetworkCache> cacheHandler;

/** 
 Sets the default cache behavior of task.
 You also can specify it for task alone.
 */
@property(nonatomic, assign) BOOL taskShouldCache;

/**
 Returns global HZNetworkConfig instance.
 
 @return HZNetworkConfig shared instance
 */
+ (instancetype)sharedConfig;

/**
 Configs data.
 
 @param baseURL The default base URL for 'HZSessiontask'.
 @param userAgent the default User-Agent for http.
 @param codeKeyPath The path of status code which is used by 'HZSessiontask' to get status code from response data.
 @param msgKeyPath The path of tip message which is used by 'HZSessiontask' to get tip message from response data.
 @param rightCode The value of success code.
 */
- (void)setupBaseURL:(NSString *)baseURL
           userAgent:(nullable NSString *)userAgent;
- (void)setupBaseURL:(NSString *)baseURL
         codeKeyPath:(nullable NSString *)codeKeyPath
          msgKeyPath:(nullable NSString *)msgKeyPath
           userAgent:(nullable NSString *)userAgent
           rightCode:(NSUInteger)rightCode;

/**
 Adds default http header field for 'HZSessionTask'.
 */
- (void)addDefaultHeaderFields:(NSDictionary<NSString *, NSString *> *)headerFields;

- (void)registerCacheHandler:(id<HZNetworkCache>)cacheHandler;

@end


NS_ASSUME_NONNULL_END
