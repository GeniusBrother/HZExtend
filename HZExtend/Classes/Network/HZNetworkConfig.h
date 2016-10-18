//
//  HZNetworkConfig.h
//  ZHFramework
//
//  Created by xzh on 16/1/9.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZSingleton.h"
typedef NS_ENUM(NSUInteger, HZSSLPinningMode) {
    HZSSLPinningModeNone,       //验证返回的证书是否由受信任的机构颁发
    HZSSLPinningModePublicKey,  //验证返回的证书的公钥是否与本地的副本一致
    HZSSLPinningModeCertificate,//验证返回的证书是否过去，全部内容是否与本地一致
};

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kNetworkPage;
extern NSString *const kNetworkPageSize;

@interface HZNetworkConfig : NSObject
singleton_h(Config)

/**
 *  公共的相同URL部分
 */
@property(nonatomic, copy, readonly) NSString *baseURL;

/**
 *  状态码路径,供task取得数据
 */
@property(nullable, nonatomic, copy, readonly) NSString *codeKeyPath;

/**
 *  消息码路径,供task取得数据
 */
@property(nullable, nonatomic, copy, readonly) NSString *msgKeyPath;

/**
 *  客户端标识，用于设置请求头
 */
@property(nullable, nonatomic, copy, readonly) NSString *userAgent;

/**
 *  正确的状态码
 */
@property(nonatomic, assign, readonly) NSUInteger rightCode;

/**
 *  默认的公共请求头
 */
@property(nonatomic, copy, readonly) NSDictionary<NSString *, id> *defaultHeaderFields;

/** 是否允许信任非信任机构的证书，默认为NO */
@property(nonatomic, assign) BOOL allowInvalidCertificates;

/** 验证证书方式，默认为HZSSLPinningModeNone */
@property(nonatomic, assign) HZSSLPinningMode SSLPinningMode;

/** 网络无法连接,默认提示的文案 */
@property(nonatomic, copy) NSString *networkLostErrorMsg;

/**
 *  配置公共参数
 *  只设置共同URL等
 */
- (void)setupBaseURL:(NSString *)baseURL
           userAgent:(nullable NSString *)userAgent;

/**
 *  配置公共参数
 *  有状态码、消息码路径
 */
- (void)setupBaseURL:(NSString *)baseURL
         codeKeyPath:(nullable NSString *)codeKeyPath
          msgKeyPath:(nullable NSString *)msgKeyPath
           userAgent:(nullable NSString *)userAgent
           rightCode:(NSUInteger)rightCode;

/**
 *  添加公共请求头
 */
- (void)addDefaultHeaderFields:(NSDictionary<NSString *, id> *)headerFields;

@end


NS_ASSUME_NONNULL_END
