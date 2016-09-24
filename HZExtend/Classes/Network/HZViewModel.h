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

/**********发送请求**********/
- (void)sendTask:(HZSessionTask *)task;    //GET或POST
- (void)uploadTask:(HZSessionTask *)task progress:(void (^)(NSProgress *uploadProgress))uploadProgressBlock;   //upload
- (void)cancelTask:(HZSessionTask *)task;

/**********子类重写回调**********/

/**
 *  初始化ViewModel,可在这里初始化task
 */
- (void)loadViewModel;

/**
 *  加载数据模型，数据返回时会调用(请求数据，缓存数据)
 *  type:即task的任务标识，requestType
 */
- (void)loadDataWithTask:(HZSessionTask *)task type:(nullable NSString *)type;

/**
 *  做一些失败处理,如页数减一,请求失败或者无网无缓存时调用
 */
- (void)requestFailWithTask:(HZSessionTask *)task type:(nullable NSString *)type;

@end

NS_ASSUME_NONNULL_END
