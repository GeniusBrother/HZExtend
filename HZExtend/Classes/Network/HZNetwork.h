//
//  HZNetwork.h
//  ZHFramework
//
//  Created by xzh. on 15/8/17.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZSingleton.h"
#import "HZUploadSessionTask.h"

@class HZNetwork;

/****************     任务的执行器     ****************/

NS_ASSUME_NONNULL_BEGIN

@interface HZNetwork : NSObject
singleton_h(Network)

/**
 *	执行普通请求任务
 *
 *	@param task  普通请求任务
 */
- (void)performTask:(HZSessionTask *)task;

/**
 *	执行上传请求任务
 *
 *	@param uploadTask  上传类型的请求任务
 */
- (void)performUploadTask:(HZUploadSessionTask *)uploadTask progress:(void (^)(NSProgress *uploadProgress))uploadProgressBlock;

/**
 *	取消执行请求任务
 *
 *	@param task  请求任务
 */
- (void)cancelTask:(HZSessionTask *)task;

@end

NS_ASSUME_NONNULL_END
