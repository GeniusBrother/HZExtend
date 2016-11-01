//
//  HZNetwork.h
//  ZHFramework
//
//  Created by xzh. on 15/8/17.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZSingleton.h"

@class HZNetwork,HZSessionTask;
/****************     任务的执行器     ****************/

NS_ASSUME_NONNULL_BEGIN

@interface HZNetwork : NSObject
singleton_h(Network)

/**
 *	配置默认的请求头
 *  所有的请求任务都会被追加默认的请求头
 *
 *	@param requestHeaders  默认的请求头
 */
- (void)configDefaultRequestHeader:(NSDictionary<NSString *, NSString *> *)requestHeaders;

/**
 *	执行普通请求任务
 *
 *	@param task  普通请求任务
 *  @param completion 请求完成后的回调
 */
- (void)performTask:(HZSessionTask *)task completion:(void(^)(HZNetwork *performer, id __nullable responseObject, NSError * __nullable error))completion;

/**
 *	执行上传请求任务
 *
 *	@param uploadTask  上传类型的请求任务
 *	@param uploadProgressBlock  上传过程的回调
 *  @param completion 请求完成后的回调
 */
- (void)performUploadTask:(HZSessionTask *)uploadTask progress:(void (^)(NSProgress *uploadProgress))uploadProgressBlock completion:(void(^)(HZNetwork *performer, id __nullable responseObject, NSError * __nullable error))completion;

/**
 *	取消执行请求任务
 *
 *	@param task  请求任务
 */
- (void)cancelTask:(HZSessionTask *)task;

@end

NS_ASSUME_NONNULL_END
