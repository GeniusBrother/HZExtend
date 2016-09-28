//
//  HZViewModel.h
//  ZHFramework
//
//  Created by xzh. on 15/8/19.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZNetwork.h"

@class HZViewModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^HZNetworkSendTaskHandleBlock)(NSError *__nullable error,HZSessionTask *task);
@protocol HZViewModelDelegate<NSObject>
@optional
/**
 *  task请求完成时调用,此时task的状态可能成功或失败
 *	@param task  请求任务
 *  @param taskIdentifier  请求任务的标识
 */
- (void)viewModel:(HZViewModel *)viewModel taskDidCompleted:(HZSessionTask *)task taskIdentifier:(nullable NSString *)taskIdentifier;

/**
 *  task进入请求中调用,此时task的状态可能为请求中取得缓存成功,请求中取得缓存失败,请求中不尝试导入缓存,请求中取消请求
 *	@param task  请求任务
 *  @param taskIdentifier  请求任务的标识
 */
- (void)viewModel:(HZViewModel *)viewModel taskSending:(HZSessionTask *)task taskIdentifier:(nullable NSString *)taskIdentifier;

/**
 *  task请求无法连接时调用此时task的状态可能为无法连接取得缓存成功,无法连接取得缓存失败,无法连接不尝试导入缓存
 *	@param task  请求任务
 *  @param taskIdentifier  请求任务的标识
 */
- (void)viewModel:(HZViewModel *)viewModel taskDidLose:(HZSessionTask *)task taskIdentifier:(nullable NSString *)taskIdentifier;

@end

@interface HZViewModel : NSObject<HZSessionTaskDelegate>

@property(nonatomic, weak) id<HZViewModelDelegate> delegate;

+ (instancetype)viewModelWithDelegate:(id<HZViewModelDelegate>)delegate;

/**
 *	返回task发送失败的原因
 *
 *	@param task  请求任务
 *
 *  @return 若task成功发送或者未执行发送，则返回nil,否则返回失败发送的原因
 */
- (NSString *)failSendReasonForTask:(HZSessionTask *)task;

#pragma mark - 操作请求
/**
 *	发送请求任务
 *
 *	@param task  请求任务
 *  @param handleBlock handleBlock会回调是否成功发送任务，即task是否已经交给HZNetwork处理
 */
- (void)sendTask:(HZSessionTask *)task handle:(nullable HZNetworkSendTaskHandleBlock)handleBlock;

/**
 *	发送请求任务
 *
 *	@param taskName  请求任务的名称
 *  @param handleBlock handleBlock会回调是否成功发送任务，即task是否已经交给HZNetwork处理
 */
- (void)sendTaskWithName:(NSString *)taskName handle:(nullable HZNetworkSendTaskHandleBlock)handleBlock;

/**
 *	发送上传的请求任务
 *
 *	@param task  请求任务
 *  @param uploadProgressBlock  进度回调block
 *  @param handleBlock handleBlock会回调是否成功发送任务，即task是否已经交给HZNetwork处理
 */
- (void)sendUploadTask:(HZSessionTask *)task progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgressBlock  handle:(nullable HZNetworkSendTaskHandleBlock)handleBlock;

/**
 *	取消请求任务
 *
 *	@param task  请求任务
 */
- (void)cancelTask:(HZSessionTask *)task;

#pragma mark - 子类重写回调
/**
 *  初始化ViewModel时调用,可以在这里对数据进行初始化
 */
- (void)loadViewModel;

/**
 *	请求任务请求成功，请求中取得缓存成功，无法连接取得缓存成功时调用，在这里设置数据模型，自定义时不需要调用父类的该方法
 *
 *	@param task  对应的请求任务
 *  @param taskIdentifier  请求任务的标识
 *
 */
- (void)taskDidFetchData:(HZSessionTask *)task taskIdentifier:(NSString *)taskIdentifier;

/**
 *	请求失败，无法连接取得缓存失败时调用,在这里做一些失败处理，自定义时不需要调用父类的该方法
 *
 *	@param task  对应的请求任务
 *  @param taskIdentifier  请求任务的标识
 *
 */
- (void)taskDidFail:(HZSessionTask *)task taskIdentifier:(NSString *)taskIdentifier;


/**
 *  子类返回网络无法连接时提示的文案
 */
- (NSString *)networkLostErrorMsg;

/**
 *  是否发送请求任务,父类的默认实现为若网络无法连接返回NO
 *
 *	@param task 请求任务
 *  @param reasonDic 如果不能发送,利用reasonDic设置不能发送的原因 即key=taskIdentifier,value = msg
 *
 *  @return 一个bool值，YES可以发送请求任务
 */
- (BOOL)shouldSendTask:(HZSessionTask *)task reasonDic:(NSMutableDictionary *)reasonDic;

@end

NS_ASSUME_NONNULL_END
