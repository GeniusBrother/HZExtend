//
//  HZSessionTask.h
//  HZNetwork
//
//  Created by xzh. on 15/8/17.
//  Copyright (c) 2015年 xzh. All rights reserved.
//
/****************     具体的请求任务,配置参数,输出数据     ****************/

#import <Foundation/Foundation.h>
#import "HZNetworkConfig.h"
#import "HZNetworkConst.h"
#import "HZSessionTaskDelegate.h"
@class HZSessionTask;

NS_ASSUME_NONNULL_BEGIN

typedef void(^HZSessionTaskDidCompletedBlock)(HZSessionTask *task);
typedef void(^HZSessionTaskDidSendBlock)(HZSessionTask *task);
typedef void(^HZSessionTaskDidCancelBlock)(HZSessionTask *task);
typedef void(^HZSessionTaskUploadProgressBlock)(HZSessionTask *task, NSProgress *progress);
typedef NS_ENUM(NSUInteger, HZSessionTaskState) {   //The execution state of the task.
    HZSessionTaskStateRunable = 0,                  //Runable.
    HZSessionTaskStateRunning = 1,                  //In execution.
    HZSessionTaskStateCancel = 2,                   //Task cancled.
    HZSessionTaskStateSuccess = 3,                  //Task is successful.
    HZSessionTaskStateFail = 4,                     //Task failed.
};

typedef NS_ENUM(NSUInteger, HZSessionTaskCacheImportState) {  //The importing state of cache.
    HZSessionTaskCacheImportStateNone = 0,          //Not imported, initial state.
    HZSessionTaskCacheImportStateSuccess = 1,       //The cache is imported successfully.
    HZSessionTaskCacheImportStateFail = 2,          //The cache is imported failed. May no cache exists or already impored cache.
};

/**
 HZSessionTask represents the specific request task. You can use it to config parameters for request and get response data from it.
 */
@interface HZSessionTask : NSObject

/**
 Creates and returns a task.

 @param method The request method, currently only GET/POST is supported.
 @param path The path of URL. e.g /GeniusBrother/HZExtend
 @param params The parameters for http query string.
 @param delegate The task's delegate object. You can get execution state of task by it.
 @param taskIdentifier The UUID of task.
 
 @return new instance of `HZSessionTask` with specified http parameters.
 */
+ (instancetype)taskWithMethod:(NSString *)method
                          path:(NSString *)path
                        params:(nullable NSDictionary<NSString *, id> *)params
                      delegate:(nullable id<HZSessionTaskDelegate>)delegate
                taskIdentifier:(nullable NSString *)taskIdentifier;

/**
 Creates and returns a task.
 
 @param method The request method, currently only GET/POST is supported.
 @param path The path of URL. e.g /user/:uid/book/:bookId
 @param delegate The task's delegate object. You can get execution state of task by it.
 @param taskIdentifier The UUID of task.
 @param pathValues An array consists of path parameters.
 
 @discussion If set the pathValues not empty, the path value will be appended to path. Like URL https://example.com/user/13/book/1005
 
 @return new instance of `HZSessionTask` with specified http parameters.
 */
+ (instancetype)taskWithMethod:(NSString *)method
                          path:(NSString *)path
                        pathValues:(nullable NSArray<NSString *> *)pathValues
                      delegate:(nullable id<HZSessionTaskDelegate>)delegate
                taskIdentifier:(nullable NSString *)taskIdentifier;

/**
 Creates and returns a task.
 
 @param method The request method, currently only GET/POST is supported.
 @param URLString The URL for http execpt query string. e.g https://github.com/GeniusBrother/HZExtend
 @param delegate The task's delegate object. You can get execution state of task by it.
 @param taskIdentifier The UUID of task.
 
 @return new instance of `HZSessionTask` with specified http parameters or nil if URLString is invalid.
 */
+ (nullable instancetype)taskWithMethod:(NSString *)method
                     URLString:(NSString *)URLString
                        params:(nullable NSDictionary<NSString *, id> *)params
                      delegate:(nullable id<HZSessionTaskDelegate>)delegate
                taskIdentifier:(NSString *)taskIdentifier;

/**
 Creates and returns a upload task.
 
 @param path The path of URL.
 @param params The parameters for http query string.
 @param delegate The task's delegate object. You can get execution state of task by it.
 @param taskIdentifier The UUID of task.

 @return new instance of `HZSessionTask` with specified http parameters.
 */
+ (instancetype)uploadTaskWithPath:(NSString *)path
                              params:(nullable NSDictionary<NSString *, id> *)params
                            delegate:(nullable id<HZSessionTaskDelegate>)delegate
                      taskIdentifier:(NSString *)taskIdentifier;

/** UUID */
@property(nonatomic, copy, readonly) NSString *taskIdentifier;

/** execution state. */
@property(nonatomic, assign, readonly) HZSessionTaskState state;

/** Importing state of cache. */
@property(nonatomic, assign, readonly) HZSessionTaskCacheImportState cacheImportState;

/** Boolean value that indicates whether the task is executed for the first time. */
@property(nonatomic, assign, readonly) BOOL isFirstRequest;

/** The task's delegate object. You can get execution state of task by it. */
@property(nonatomic, weak) id<HZSessionTaskDelegate> delegate;

/** A block to be executed after completion of task. */
@property(nonatomic, copy) HZSessionTaskDidCompletedBlock taskDidCompletedBlock;

/** A block to be executed after sending task. */
@property(nonatomic, copy) HZSessionTaskDidSendBlock taskDidSendBlock;

/** A block to be executed after task is cancled. */
@property(nonatomic, copy) HZSessionTaskDidCancelBlock taskDidCancelBlock;

/** A block to be executed when the upload progress is updated. */
@property(nonatomic, copy) HZSessionTaskUploadProgressBlock uploadProgressBlock;

/**
 The base URL of http URL. e.g https://www.github.com
 
 @discussion Sets the baseURL config of `HZNetworkConfig` to base URL if it not sets.
 */
@property(nullable, nonatomic, copy) NSString *baseURL;

/** The path of http URL. e.g /GeniusBrother/HZExtend */
@property(nonatomic, copy) NSString *path;

/** The parameters for http. */
@property(nonatomic, strong) NSMutableDictionary<NSString *, id> *params;

/** The parameters for file when uploading file. */
@property(nullable, nonatomic, strong) NSMutableDictionary<NSString *, id> *fileParams;

/** The method for http. */
@property(nonatomic, copy, readonly) NSString *method;

/** The http header field. */
@property(nullable, nonatomic, readonly) NSDictionary <NSString *, NSString *> *requestHeader;

/** 
 The patheValues will replace path parameter
 */
@property(nullable, nonatomic, strong) NSMutableArray<NSString *> *pathValues;

/** 
 Boolean value that indicates whether the task should cache response data.
 The default value is equal to [HZNetoworkConfig sharedConfig].taskShouldCache.
 */
@property(nonatomic, assign, getter=isCached) BOOL cached;

/**
 If `YES`, only import cache once when task is executed more than once or import cache everytime.
 The default value is `YES`.
 */
@property(nonatomic, assign) BOOL importCacheOnce;

/** The response data from remote. */
@property(nullable, nonatomic, strong, readonly) id responseObject;

/** The error of task. */
@property(nullable, nonatomic, strong, readonly) NSError *error;

/** 
 The tip message for task.
 You should config key path of message that in response by HZNetworkConfig. see `HZNetworkConfig` for more information.
 */
@property(nullable, nonatomic, copy, readonly) NSString *message;

/** The absoluteURL of http. */
@property(nonatomic, copy) NSString *absoluteURL;

/** The target URL for http. */
@property(nonatomic, readonly) NSString *requestPath;

/**
 Sets the value of the given HTTP header field.
 
 @param value the header field value.
 @param key the header field name.
 */
- (void)setValue:(NSString *)value forHeaderField:(NSString *)key;

/**
 Peforms Task.
 
 @param completion The block to be executed after completion of task.
 @param didSend The block to be executed after sending task
 */
- (void)start;
- (void)startWithCompletion:(HZSessionTaskDidCompletedBlock)completion;
- (void)startWithCompletion:(HZSessionTaskDidCompletedBlock)completion
                    didSend:(nullable HZSessionTaskDidSendBlock)didSend;

/**
 Peforms Task with handler.
 
 @param handler The block to be executed before peforming task. The task will be intercepted if error not nil.
 */
- (void)startWithHandler:(nullable void(^)(HZSessionTask *task, NSError  * _Nullable error))handler;

/**
 Cancles task.
 */
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
