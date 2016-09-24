//
//  HZViewModel.m
//  ZHFramework
//
//  Created by xzh. on 15/8/19.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "HZViewModel.h"
#import "HZUploadSessionTask.h"
#import "NSObject+HZExtend.h"
@interface HZViewModel ()


@end

@implementation HZViewModel

#pragma mark - Init
+ (instancetype)viewModelWithDelegate:(id<HZViewModelDelegate>)delegate
{
    HZViewModel *viewModel = [[self alloc] init];
    viewModel.delegate = delegate;
    return viewModel;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadViewModel];
    }
    return self;
}

- (void)loadViewModel {}
- (void)loadDataWithTask:(HZSessionTask *)task type:(NSString *)type {}
- (void)requestFailWithTask:(HZSessionTask *)task type:(NSString *)type {}

#pragma mark - Page
- (void)pageIncrease:(HZSessionTask *)task
{
    NSNumber *oldNumber = [task.params objectForKey:kNetworkPage];
    
    if (oldNumber) {
        [task.params setObject:@(oldNumber.integerValue+1) forKey:kNetworkPage];
    }
    
}

- (void)pageDecrease:(HZSessionTask *)task
{
    NSNumber *oldNumber = [task.params objectForKey:kNetworkPage];
    
    if (oldNumber.integerValue >=2) {
        [task.params setObject:@(oldNumber.integerValue-1) forKey:kNetworkPage];
    }
}

- (void)pageOrigin:(HZSessionTask *)task
{
    [task.params setObject:@1 forKey:kNetworkPage];
}

#pragma mark - Network
- (void)sendTask:(HZSessionTask *)sessionTask
{    
    [[HZNetwork sharedNetwork] send:sessionTask];
}

- (void)uploadTask:(HZUploadSessionTask *)sessionTask progress:(void (^)(NSProgress *))uploadProgressBlock
{
    return [[HZNetwork sharedNetwork] upload:sessionTask progress:uploadProgressBlock];
}

- (void)cancelTask:(HZSessionTask *)sessionTask
{
    [[HZNetwork sharedNetwork] cancel:sessionTask];
}

#pragma mark - SessionTaskDelegate
/**
 *  主要实现了回调
 */
- (void)taskConnected:(HZSessionTask *)task
{
    if (task.succeed) {
        [self loadDataWithTask:task type:task.requestType];
    }else {
        [self requestFailWithTask:task type:task.requestType];
    }
    
    if ([self.delegate respondsToSelector:@selector(viewModelConnetedNotifyForTask:type:)]) {
        [self.delegate viewModelConnetedNotifyForTask:task type:task.requestType];
    }
}

- (void)taskSending:(HZSessionTask *)task
{
    if (task.cacheSuccess) [self loadDataWithTask:task type:task.requestType];
    
    if ([self.delegate respondsToSelector:@selector(viewModelSendingNotifyForTask:type:)]) {
        [self.delegate viewModelSendingNotifyForTask:task type:task.requestType];
    }
}

- (void)taskLosted:(HZSessionTask *)task
{
    if (task.cacheSuccess) {
        [self loadDataWithTask:task type:task.requestType];
    }else if(task.cacheFail) {
        [self requestFailWithTask:task type:task.requestType];
    }
    
    if ([self.delegate respondsToSelector:@selector(viewModelLostedNotifyForTask:type:)]) {
        [self.delegate viewModelLostedNotifyForTask:task type:task.requestType];
    }
}

@end
