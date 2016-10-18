//
//  HZViewModel.h
//  ZHFramework
//
//  Created by xzh. on 15/8/19.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZNetwork.h"
#import "HZSessionTask.h"
@class HZViewModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^HZNetworkSendTaskHandleBlock)(NSError *__nullable error,HZSessionTask *task);
@protocol HZViewModelDelegate<NSObject>
@optional
/**
 *  task请求完成时调用
 *	@param task  请求任务
 *  @param taskIdentifier  请求任务的标识
 */
- (void)viewModel:(HZViewModel *)viewModel taskDidCompleted:(HZSessionTask *)task taskIdentifier:(nullable NSString *)taskIdentifier;

/**
 *  task进入请求中调用
 *	@param task  请求任务
 *  @param taskIdentifier  请求任务的标识
 */
- (void)viewModel:(HZViewModel *)viewModel taskSending:(HZSessionTask *)task taskIdentifier:(nullable NSString *)taskIdentifier;

/**
 *  task请求无法连接时调用
 *	@param task  请求任务
 *  @param taskIdentifier  请求任务的标识
 */
- (void)viewModel:(HZViewModel *)viewModel taskDidLose:(HZSessionTask *)task taskIdentifier:(nullable NSString *)taskIdentifier;

/**
 *  task被取消时调用
 *	@param task  请求任务
 *  @param taskIdentifier  请求任务的标识
 */
- (void)viewModel:(HZViewModel *)viewModel taskDidCancel:(HZSessionTask *)task taskIdentifier:(nullable NSString *)taskIdentifier;

@end

@interface HZViewModel : NSObject<HZSessionTaskDelegate>

@property(nonatomic, weak) id<HZViewModelDelegate> delegate;

+ (instancetype)viewModelWithDelegate:(id<HZViewModelDelegate>)delegate;

#pragma mark - 子类重写回调
/**
 *  初始化ViewModel时调用,可以在这里对数据进行初始化
 */
- (void)loadViewModel;

/**
 *	task获取到数据时调用,此时task的状态为请求中取得缓存成功,请求成功,在这里设置数据模型，自定义时不需要调用父类的该方法
 *
 *	@param task  对应的请求任务
 *  @param taskIdentifier  请求任务的标识
 *
 */
- (void)taskDidFetchData:(HZSessionTask *)task taskIdentifier:(NSString *)taskIdentifier;

/**
 *	task请求失败时调用,此时task状态为请求失败或者无法连接,在这里做一些失败处理,自定义时不需要调用父类的该方法
 *
 *	@param task  对应的请求任务
 *  @param taskIdentifier  请求任务的标识
 *
 */
- (void)taskDidFail:(HZSessionTask *)task taskIdentifier:(NSString *)taskIdentifier;

/**
 *	task被取消时调用，自定义时不需要调用父类的该方法
 *
 *	@param task  对应的请求任务
 *  @param taskIdentifier  请求任务的标识
 *
 */
- (void)taskDidCancel:(HZSessionTask *)task taskIdentifier:(NSString *)taskIdentifier;

/**
 *	task将要开始执行时调用，自定义时不需要调用父类的该方法
 *
 *	@param task  对应的请求任务
 *  @param taskIdentifier  请求任务的标识
 *  @return 需要返回取消信息,return nil则不取消
 */
- (NSString *)taskShouldPerform:(HZSessionTask *)task taskIdentifier:(NSString *)taskIdentifier;

@end

NS_ASSUME_NONNULL_END
