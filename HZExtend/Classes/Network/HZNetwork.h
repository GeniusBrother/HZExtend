//
//  HZNetwork.h
//  ZHFramework
//
//  Created by xzh. on 15/8/17.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZSingleton.h"
#import "HZNetworkConfig.h"
#import "HZSessionTask.h"
#import "HZUploadSessionTask.h"

@class HZNetwork;

/****************     任务的执行器     ****************/

NS_ASSUME_NONNULL_BEGIN

@interface HZNetwork : NSObject
singleton_h(Network)

/**
 *  GET或POST
 */
- (void)send:(HZSessionTask *)sessionTask;

/**
 *  上传任务
 */
- (void)upload:(HZUploadSessionTask *)sessionTask progress:(void (^)(NSProgress *uploadProgress))uploadProgressBlock;

/**
 *  取消
 */
- (void)cancel:(HZSessionTask *)sessionTask;

@end

NS_ASSUME_NONNULL_END
