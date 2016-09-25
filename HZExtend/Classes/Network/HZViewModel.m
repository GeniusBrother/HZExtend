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
- (void)taskDidFetchData:(HZSessionTask *)task type:(NSString *)type {}
- (void)taskDidFail:(HZSessionTask *)task type:(NSString *)type {}

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
- (void)taskComplted:(HZSessionTask *)task
{
    if (task.succeed) {
        [self taskDidFetchData:task type:task.requestType];
    }else {
        [self taskDidFail:task type:task.requestType];
    }
    
    if ([self.delegate respondsToSelector:@selector(viewModel:taskDidCompleted:type:)]) {
        [self.delegate viewModel:self taskDidCompleted:task type:task.requestType];
    }
}

- (void)taskSending:(HZSessionTask *)task
{
    if (task.cacheSuccess) [self taskDidFetchData:task type:task.requestType];
    
    if ([self.delegate respondsToSelector:@selector(viewModel:taskSending:type:)]) {
        [self.delegate viewModel:self taskSending:task type:task.requestType];
    }
}

- (void)taskLosted:(HZSessionTask *)task
{
    if (task.cacheSuccess) {
        [self taskDidFetchData:task type:task.requestType];
    }else if(task.cacheFail) {
        [self taskDidFail:task type:task.requestType];
    }
    
    if ([self.delegate respondsToSelector:@selector(viewModel:taskDidLose:type:)]) {
        [self.delegate viewModel:self taskDidLose:task type:task.requestType];
    }
}

@end
