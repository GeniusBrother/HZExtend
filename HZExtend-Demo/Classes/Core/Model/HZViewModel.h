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
- (void)viewModelConnetedNotifyForTask:(SessionTask *)task type:(nullable NSString *)type;

/**
 *  请求过程中调用(有缓存,无缓存,不尝试导入缓存,取消)
 */
- (void)viewModelSendingNotifyForTask:(SessionTask *)task type:(nullable NSString *)type;

/**
 *  无网下调用(有缓存，无缓存，不尝试导入缓存)
 */
- (void)viewModelLostedNotifyForTask:(SessionTask *)task type:(nullable NSString *)type;

@end

@interface HZViewModel : NSObject<SessionTaskDelegate>

@property(nonatomic, weak) id<HZViewModelDelegate> delegate;

+ (instancetype)viewModelWithDelegate:(id<HZViewModelDelegate>)delegate;

/**********发送请求**********/
- (void)sendTask:(SessionTask *)sessionTask;    //GET或POST
- (void)uploadTask:(SessionTask *)sessionTask progress:(void (^)(NSProgress *uploadProgress))uploadProgressBlock;   //upload
- (void)cancelTask:(SessionTask *)sessionTask;

/**********简便分页模型**********/
- (void)pageIncrease:(SessionTask *)task;   //kNetworkPage+1
- (void)pageDecrease:(SessionTask *)task;   //kNetworkPage-1
- (void)pageOrigin:(SessionTask *)task;     //kNetworkPage=1

/**
 *  若为第一页初始化pageArray,追加数据。其它页删除掉缓存数据，追加数据。
 *  pageArray:tableView数据源的名字
 *  appendArray:分页的数据
 *  task:请求的task
 */
- (void)pageArray:(NSString *)pageArray appendArray:(NSArray<id> *)appendArray task:(SessionTask *)task;

/**********子类重写回调**********/
/**
 *  初始化ViewModel,可在这里初始化task
 */
- (void)loadViewModel;

/**
 *  加载数据模型，数据返回时会调用(请求数据，缓存数据)
 *  type:即task的任务标识，requestType
 */
- (void)loadDataWithTask:(SessionTask *)task type:(nullable NSString *)type;

/**
 *  做一些失败处理,如页数减一,请求失败或者无网无缓存时调用
 */
- (void)requestFailWithTask:(SessionTask *)task type:(nullable NSString *)type;

@end

NS_ASSUME_NONNULL_END
