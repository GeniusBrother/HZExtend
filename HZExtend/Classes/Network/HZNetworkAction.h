//
//  HZNetworkAction.h
//  HZNetwork
//
//  Created by xzh. on 15/8/17.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HZNetworkAction,HZSessionTask;

NS_ASSUME_NONNULL_BEGIN
/**
 HZNetworkAction is used by `HZSessionTask` to perform request task.
 Typically, you should not use this class directly.
 */
@interface HZNetworkAction : NSObject

/**
 Returns global HZNetworkAction instance.
 
 @return HZNetworkAction shared instance
 */
+ (instancetype)sharedAction;

/**
 Configs default http header of all request.
 
 @param requestHeaders The default http header to be set.
 */
- (void)configDefaultRequestHeader:(NSDictionary<NSString *, NSString *> *)requestHeaders;

/**
 Performs GET/POST http sessionTask.
 
 @param task The sessionTask to be performed.
 @param completion The block to execute after a response is received.
 */
- (void)performTask:(HZSessionTask *)task completion:(void(^)(HZNetworkAction *performer, id __nullable responseObject, NSError * __nullable error))completion;

/**
 Performs upload sessionTask.

 @param uploadTask The sessionTask to be performed.
 @param uploadProgressBlock The block to be executed when the upload progress is updated. Note this block is called on the session queue, not the main queue.
 @param completion The block to execute after a response is received.
 */
- (void)performUploadTask:(HZSessionTask *)uploadTask progress:(void (^)(NSProgress *uploadProgress))uploadProgressBlock completion:(void(^)(HZNetworkAction *performer, id __nullable responseObject, NSError * __nullable error))completion;

/**
 Cancles the sessionTask in execution.
 
 @param task The sessionTask in execution.
 */
- (void)cancelTask:(HZSessionTask *)task;

@end

NS_ASSUME_NONNULL_END
