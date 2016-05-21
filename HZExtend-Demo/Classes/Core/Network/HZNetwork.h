//
//  HZNetwork.h
//  ZHFramework
//
//  Created by xzh. on 15/8/17.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "NetworkConfig.h"
#import "SessionTask.h"
#import "UploadSessionTask.h"
/**
 *  任务的执行器
 */
@class HZNetwork;
@interface HZNetwork : NSObject
singleton_h(Network)

/**
 *  GET或POST
 */
- (void)send:(SessionTask *)sessionTask;

/**
 *  上传任务
 */
- (void)upload:(UploadSessionTask *)sessionTask progress:(void (^)(NSProgress *uploadProgress))uploadProgressBlock;

/**
 *  取消
 */
- (void)cancel:(SessionTask *)sessionTask;



@end
