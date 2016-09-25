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
 *  最终的请求结果到来调用(成功或失败)
 */
- (void)viewModelConnetedNotifyForTask:(HZSessionTask *)task type:(nullable NSString *)type;

/**
 *  请求过程中调用(有缓存,无缓存,不尝试导入缓存,取消)
 */
- (void)viewModelSendingNotifyForTask:(HZSessionTask *)task type:(nullable NSString *)type;

/**
 *  无网下调用(有缓存，无缓存，不尝试导入缓存)
 */
- (void)viewModelLostedNotifyForTask:(HZSessionTask *)task type:(nullable NSString *)type;

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
- (void)loadDataWithTask:(HZSessionTask *)task type:(nullable NSString *)type;

/**
 *	请求失败，无法连接取得缓存失败时调用,在这里做一些失败处理，自定义时不需要调用父类的该方法
 *
 *	@param task  对应的请求任务
 *  @param type  请求任务的标识
 *
 */
- (void)requestFailWithTask:(HZSessionTask *)task type:(nullable NSString *)type;

@end

NS_ASSUME_NONNULL_END
