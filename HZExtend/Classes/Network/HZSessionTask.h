//
//  SessionTask.h
//  ZHFramework
//
//  Created by xzh. on 15/8/17.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZNetworkConfig.h"
#import "HZNetworkConst.h"

@class HZSessionTask;

/****************     具体的请求任务,配置参数,输出数据     ****************/

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, HZSessionTaskState) {
    HZSessionTaskStateRunable            = 1 <<  0,//初始状态
    HZSessionTaskStateRunning            = 1 <<  1,//执行状态
    HZSessionTaskStateCancel             = 1 <<  2,//任务取消
    HZSessionTaskStateSuccess            = 1 <<  3,//任务成功
    HZSessionTaskStateFail               = 1 <<  4,//业务错误||请求失败
    HZSessionTaskStateNoReach            = 1 <<  5,//无法连接
    HZSessionTaskStateCacheSuccess       = 1 <<  6,//获取到正确数据的缓存
    HZSessionTaskStateCacheFail          = 1 <<  7,//无缓存数据
    HZSessionTaskStateCacheNoTry         = 1 <<  8,//不尝试导入缓存
};

//请求数据的状态回调
@protocol HZSessionTaskDelegate<NSObject>

/**
 *  请求完成后调用，state:SessionTaskStateSuccess 或 SessionTaskStateFail
 */
- (void)taskComplted:(HZSessionTask *)task;

/**
 *  请求过程中调用 state:SessionTaskStateRunning|SessionTaskStateCacheSuccess 或 SessionTaskStateRunning|SessionTaskStateCacheFail 或 SessionTaskStateRunning|SessionTaskStateCacheNoTry 或 SessionTaskStateCancel
 */
- (void)taskSending:(HZSessionTask *)task;

/**
 *  无网情况下调用 state:SessionTaskStateNoReach|SessionTaskStateCacheSuccess 或 SessionTaskStateNoReach| SessionTaskStateCacheFail 或 SessionTaskStateNoReach| SessionTaskStateCacheNoTry
 */
- (void)taskLosted:(HZSessionTask *)task;



@end

@interface HZSessionTask : NSObject

+ (instancetype)taskWithMethod:(NSString *)method
                          path:(NSString *)path
                        params:(nullable NSMutableDictionary<NSString *, id> *)params
                      delegate:(id<HZSessionTaskDelegate>)delegate
                   taskIdentifier:(NSString *)taskIdentifier;

+ (instancetype)taskWithMethod:(NSString *)method
                          path:(NSString *)path
                        params:(nullable NSMutableDictionary<NSString *, id> *)params
                      pathKeys:(NSArray<NSString *> *)keys
                      delegate:(id<HZSessionTaskDelegate>)delegate
                   taskIdentifier:(NSString *)taskIdentifier;

@property(nonatomic, weak) id<HZSessionTaskDelegate> delegate;

/**
 *  不设置则每个session默认为HZNetworkConfig的baseURL为基本的路径
 */
@property(nullable, nonatomic, copy) NSString *baseURL;

/**
 *  baseURL+path+params构成完整的请求
 *  如baseURL:http://abc path:/a paramas(拼接成查询字符串的形式):?key=value
 */
@property(nonatomic, copy) NSString *path;
@property(nonatomic, copy) NSString *method;

/**
 *  pathKeys不为空则表示为http://abc/a/value1/value2/...的格式。pathkeys=@[key1,key2....]
 */
@property(nullable, nonatomic, copy) NSArray *pathkeys;

/**
 *  请求参数
 */
@property(nullable, nonatomic, strong) NSMutableDictionary<NSString *, id> *params;

/**
 *  分页模型中的快捷参数
 */
@property(nonatomic, assign) NSUInteger page;
@property(nonatomic, assign) NSUInteger pageSize;

/**
 *  是否对正确返回数据缓存 deafult YES,upload no
 */
@property(nonatomic, assign, getter=isCached) BOOL cached;

/**
 *  是否尝试导入缓存,是否有缓存由cached的判断
 *  默认为YES,分页时应设置成NO来解决上拉加载来导入缓存
 */
@property(nonatomic, assign) BOOL importCacheOnce;

/**
 *  判断请求成功的业务逻辑是否正确,deafult YES,适用于有返回code码
 */
@property(nonatomic, assign, getter=isCached) BOOL shouldCheckCode;

/**
 *  任务标识
 */
@property(nonatomic, copy) NSString *taskIdentifier;

/**
 *  返回数据模型
 */
@property(nullable, nonatomic, strong, readonly) NSDictionary *responseObject;

/**
 *  请求时发生的错误，无网有数据情况下也有缓存。
 */
@property(nullable, nonatomic, strong, readonly) NSError *error;      //(无网情况下有error)

/**
 *  请求反馈消息,在设置Error或者responseObject设置
 */
@property(nullable, nonatomic, copy, readonly) NSString *message;

/**
 *  GET的请求格式 每次准备请求时刷新
 */
@property(nonatomic, copy, readonly) NSString *absoluteURL;

/**
 *  absoluteURL的MD5值
 */
@property(nonatomic, copy, readonly) NSString *cacheKey;

/**
 *  状态码，由服务器返回(如0表示没有错误)
 */
@property(nonatomic, assign, readonly) NSInteger codeKey;

/**
 *  请求状态
 */
@property(nonatomic, assign, readonly) HZSessionTaskState state;

/**
 *  请求头设置，或者在HZNetworkConfig设置全局的
 */
- (void)setValue:(id)value forHeaderField:(NSString *)key;
- (NSDictionary<NSString *, id> *)httpRequestFields;

- (BOOL)runable;                //表明任务可运行
- (BOOL)succeed;                //网络请求数据成功
- (BOOL)failed;                 //网络请求数据失败
- (BOOL)running;                //正在运行状态
- (BOOL)cacheSuccess;           //缓存数据成功
- (BOOL)cacheFail;              //缓存数据失败
- (BOOL)isCancel;

/**
 *  在每次请求时调用，清空输出
 */
- (void)restAllOutput;

/**
 *  开始请求调用
 *  1.设置基本数据:state
 *  2.导入缓存
 */
- (void)startSession;   //任务开始

/**
 *  请求任务结束调用
 *  1.设置基本数据:responseObject|error|state
 *  2.缓存数据
 *  3.通知
 */
- (void)responseSessionWithResponseObject:(nullable NSDictionary<NSString *, id> *)responseObject error:(nullable NSError *)error;

/**
 *  配置任务无法连接的输出
 *  1.基本输出:state,数据结果(message,error,responseObject)
 *  2.通知完用户后并准备重新运行
 */
- (void)noReach;

/**
 *  将page+1,若无设置page参数，则什么都不做
 */
- (void)addPage;

/**
 *  将page-1,若无设置page参数，则什么都不做
 */
- (void)minusPage;

/**
 *  将page重置为1,若无设置page参数，则什么都不做
 */
- (void)revertPage;

@end

NS_ASSUME_NONNULL_END
