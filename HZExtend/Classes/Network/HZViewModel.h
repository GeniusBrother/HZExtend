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

@protocol HZViewModelDelegate<NSObject>
@optional
/**
 *  task请求完成时调用,此时task的状态可能成功或失败
 *	@param task  请求任务
 *  @param type  请求任务的标识
 */
- (void)viewModel:(HZViewModel *)viewModel taskDidCompleted:(HZSessionTask *)task type:(nullable NSString *)type;

/**
 *  task进入请求中调用,此时task的状态可能为请求中取得缓存成功,请求中取得缓存失败,请求中不尝试导入缓存,请求中取消请求
 *	@param task  请求任务
 *  @param type  请求任务的标识
 */
- (void)viewModel:(HZViewModel *)viewModel taskSending:(HZSessionTask *)task type:(nullable NSString *)type;

/**
 *  task请求无法连接时调用此时task的状态可能为无法连接取得缓存成功,无法连接取得缓存失败,无法连接不尝试导入缓存
 *	@param task  请求任务
 *  @param type  请求任务的标识
 */
- (void)viewModel:(HZViewModel *)viewModel taskDidLose:(HZSessionTask *)task type:(nullable NSString *)type;

@end

@interface HZViewModel : NSObject<HZSessionTaskDelegate>

@property(nonatomic, weak) id<HZViewModelDelegate> delegate;

+ (instancetype)viewModelWithDelegate:(id<HZViewModelDelegate>)delegate;

#pragma mark - 操作请求
- (void)sendTask:(HZSessionTask *)task;    //GET或POST
- (void)uploadTask:(HZSessionTask *)task progress:(void (^)(NSProgress *uploadProgress))uploadProgressBlock;   //upload
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
 *  @param type  请求任务的标识
 *
 */
- (void)taskDidFetchData:(HZSessionTask *)task type:(NSString *)type;

/**
 *	请求失败，无法连接取得缓存失败时调用,在这里做一些失败处理，自定义时不需要调用父类的该方法
 *
 *	@param task  对应的请求任务
 *  @param type  请求任务的标识
 *
 */
- (void)taskDidFail:(HZSessionTask *)task type:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
