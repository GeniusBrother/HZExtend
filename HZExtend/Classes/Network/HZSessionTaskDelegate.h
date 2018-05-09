//
//  HZSessionTaskDelegate.h
//  HZNetwork
//
//  Created by xzh on 2017/12/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HZSessionTask;
@protocol HZSessionTaskDelegate<NSObject>

/**
 Calls after completion of task.
 
 @discussion At this point, the state of task may be HZSessionTaskStateSuccess or HZSessionTaskStateFail.
 */
- (void)taskDidCompleted:(HZSessionTask *)task;

/**
 Calls after task is send.
 
 @discussion At this point, the state of task is SessionTaskStateRunning.
 
 Befor the method is called, the task has already loaded cache data. So you can use `responseObject` property to get cache data.
 */
- (void)taskDidSend:(HZSessionTask *)task;

/**
 Calls after task is cancled.
 
 @discussion At this point, the state of task is HZSessionTaskStateCancel.
 */
- (void)taskDidCancel:(HZSessionTask *)task;

/**
 Calls when the task is to be executed.
 
 @params message Sets the value and find it by 'error' property.
 @return YES if the task should be stop or NO if allow.
 */
- (BOOL)taskShouldStop:(HZSessionTask *)task stopMessage:(NSString *_Nullable __autoreleasing *_Nullable)message;

@end

NS_ASSUME_NONNULL_END

