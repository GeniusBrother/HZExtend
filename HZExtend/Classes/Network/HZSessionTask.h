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
typedef void(^HZSessionTaskDidCompletedBlock)(HZSessionTask *task);
typedef void(^HZSessionTaskSendingBlock)(HZSessionTask *task);
typedef void(^HZSessionTaskDidLoseBlock)(HZSessionTask *task);
typedef void(^HZSessionTaskDidCancelBlock)(HZSessionTask *task);
typedef void(^HZSessionTaskUploadProgressBlock)(HZSessionTask *task, NSProgress *progress);
typedef NS_OPTIONS(NSUInteger, HZSessionTaskState) {
    HZSessionTaskStateRunable            = 1 <<  0,//初始状态
    HZSessionTaskStateRunning            = 1 <<  1,//请求中状态
    HZSessionTaskStateCompleted          = 1 <<  2,//完成状态
    HZSessionTaskStateLost               = 1 <<  3,//无法连接状态
    HZSessionTaskStateCancel             = 1 <<  4,//任务取消
    HZSessionTaskStateSuccess            = 1 <<  5,//任务成功
    HZSessionTaskStateFail               = 1 <<  6,//业务错误||请求失败
    HZSessionTaskStateCacheSuccess       = 1 <<  7,//获取到正确数据的缓存
    HZSessionTaskStateCacheFail          = 1 <<  8,//无缓存数据
    HZSessionTaskStateCacheNoTry         = 1 <<  9,//不导入缓存
};

@protocol HZSessionTaskDelegate<NSObject>

/**
 *  task请求完成后调用,此时state:SessionTaskStateSuccess 或 SessionTaskStateFail
 */
- (void)taskDidCompleted:(HZSessionTask *)task;

/**
 *  task进入请求中调用 此时state:SessionTaskStateRunning|SessionTaskStateCacheSuccess 或 SessionTaskStateRunning|SessionTaskStateCacheFail 或 SessionTaskStateRunning|SessionTaskStateCacheNoTry 或 SessionTaskStateCancel
 */
- (void)taskSending:(HZSessionTask *)task;

/**
 *  task无法连接时调用 此时state:SessionTaskStateNoReach|SessionTaskStateCacheSuccess 或 SessionTaskStateNoReach| SessionTaskStateCacheFail 或 SessionTaskStateNoReach| SessionTaskStateCacheNoTry
 */
- (void)taskDidLose:(HZSessionTask *)task;

/**
 *  task将要请求时调用,返回NO则取消请求,在该方法里需要设置取消原因error
 */
- (BOOL)taskShouldPerform:(HZSessionTask *)task;

@end

@interface HZSessionTask : NSObject
/**
 *	创建请求任务
 *
 *	@param method  请求类型 目前只支持GET/POST
 *  @param path  URL中的path
 *  @param params  请求参数
 *  @param delegate  代理
 *  @param taskIdentifier 任务标识,必须指定,推荐用把所有的path放到一个文件里用作标识
 *  @param pathKeys 路径参数数组
 */
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

/**
 *	创建上传请求任务
 */
+ (instancetype)uploadTaskWithPath:(NSString *)path
                              params:(nullable NSMutableDictionary<NSString *, id> *)params
                            delegate:(id<HZSessionTaskDelegate>)delegate
                      taskIdentifier:(NSString *)taskIdentifier;

/** 任务的唯一标识 */
@property(nonatomic, copy, readonly) NSString *taskIdentifier;

/** 请求状态 */
@property(nonatomic, assign, readonly) HZSessionTaskState state;

/** 表示请求是否成功*/
@property(nonatomic, assign, readonly) BOOL isSuccess;

/** 表示请求是否请求中 */
@property(nonatomic, assign, readonly) BOOL isRunning;

/** 表示请求是否失败 */
@property(nonatomic, assign, readonly) BOOL isFail;

/** 表示请求是否取得缓存成功 */
@property(nonatomic, assign, readonly) BOOL isCacheSuccess;

/** 表示请求是否取得缓存失败*/
@property(nonatomic, assign, readonly) BOOL isCacheFail;

@property(nonatomic, weak) id<HZSessionTaskDelegate> delegate;

/** task完成时调用 */
@property(nonatomic, copy) HZSessionTaskDidCompletedBlock taskDidCompletedBlock;

/** task进入请求中调用 */
@property(nonatomic, copy) HZSessionTaskSendingBlock taskSendingBlock;

/** task无法连接时调用 */
@property(nonatomic, copy) HZSessionTaskDidLoseBlock taskDidLoseBlock;

/** task取消请求时调用 */
@property(nonatomic, copy) HZSessionTaskDidCancelBlock taskDidCancleBlock;

/** 上传过程中会调用 */
@property(nonatomic, copy) HZSessionTaskUploadProgressBlock uploadProgressBlock;


/** 不设置则每个session默认为HZNetworkConfig的baseURL为基本的路径 */
@property(nullable, nonatomic, copy) NSString *baseURL;

/** URL中的path */
@property(nonatomic, copy, readonly) NSString *path;

/** 请求参数 */
@property(nullable, nonatomic, strong) NSMutableDictionary<NSString *, id> *params;

@property(nonatomic, copy, readonly) NSString *method;

/** 请求头 */
@property(nullable, nonatomic, readonly) NSDictionary <NSString *, NSString *> *requestHeader;

/** pathKeys不为空则URL为http://abc/a/value1/value2/...的格式。pathkeys=@[key1,key2....] value1,value2通过params设置*/
@property(nullable, nonatomic, copy) NSArray *pathkeys;

/** 分页模型中的快捷参数 */
@property(nonatomic, assign) NSUInteger page;
@property(nonatomic, assign) NSUInteger pageSize;

/** 是否对正确返回数据缓存 默认为为YES,HZUploadSessionTask默认为NO */
@property(nonatomic, assign, getter=isCached) BOOL cached;

/** 设置每次只导入缓存一次，默认为YES,分页时应设置成NO来解决上拉加载来导入缓存 */
@property(nonatomic, assign) BOOL importCacheOnce;

/** 上传文件的类型 */
@property(nonatomic, copy, nullable) NSString *mimeType;

/** 上传文件的名称 */
@property(nonatomic, copy, nullable) NSString *fileName;

/** 上传文件的表单名称 */
@property(nonatomic, copy, nullable) NSString *formName;

/** 上传文件的二进制数据 */
@property(nonatomic, strong, nullable) NSData *fileData;

/** 服务器返回的json对象 */
@property(nullable, nonatomic, strong, readonly) NSDictionary *responseObject;

@property(nullable, nonatomic, strong, readonly) NSError *error;

/** 服务器反馈消息 */
@property(nullable, nonatomic, copy, readonly) NSString *message;

/** 请求的绝对路径 */
@property(nonatomic, copy, readonly) NSString *absoluteURL;

/**
 *	设置请求头，或者在HZNetworkConfig设置通用的请求头
 */
- (void)setValue:(NSString *)value forHeaderField:(NSString *)key;

/**
 *  文件参数设置
 */
- (void)setFileName:(NSString *)fileName
           formName:(NSString *)formName
           mimeType:(NSString *)mimeType;

- (void)setFileData:(NSData *)fileData
           formName:(NSString *)formName
           fileName:(NSString *)fileName
           mimeType:(NSString *)mimeType;

/**
 *	开始请求任务
 *
 *	@param completionCallBack  task完成时的回调
 *	@param sendingCallBack  task进入请求中状态时回调
 *	@param lostCallBack task无法连接时的回调
 *	@param uploadCallBack task上传过程中的回调
 */
- (void)start;
- (void)startWithCompletionCallBack:(HZSessionTaskDidCompletedBlock)completionCallBack
                    sendingCallBack:(HZSessionTaskSendingBlock)sendingCallBack
                       lostCallBack:(HZSessionTaskDidLoseBlock)lostCallBack;

/**
 *	开始上传请求任务
 *  上传请求任务请用该方法启动
 *	@param completionCallBack  task完成时的回调
 *  @param uploadCallBack task上传过程中的回调
 */
- (void)startUploadWithCompletionCallBack:(HZSessionTaskDidCompletedBlock)completionCallBack
                     uploadCallBack:(HZSessionTaskUploadProgressBlock)uploadCallBack;

/**
 *	取消请求任务
 */
- (void)cancel;
@end

NS_ASSUME_NONNULL_END
