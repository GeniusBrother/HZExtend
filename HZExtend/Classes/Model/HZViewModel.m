//
//  HZViewModel.m
//  ZHFramework
//
//  Created by xzh. on 15/8/19.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "HZViewModel.h"
#import "NSObject+HZExtend.h"

@interface HZViewModel ()


@end

@implementation HZViewModel

#pragma mark - Initialization
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

#pragma mark - Public Method
- (void)loadViewModel {};
- (void)taskDidFetchData:(HZSessionTask *)task taskIdentifier:(NSString *)taskIdentifier {}
- (void)taskDidFail:(HZSessionTask *)task taskIdentifier:(NSString *)taskIdentifier {}

#pragma mark - SessionTaskDelegate
- (void)taskDidCompleted:(HZSessionTask *)task
{
    if (task.isSuccess) {
        [self taskDidFetchData:task taskIdentifier:task.taskIdentifier];
    }else {
        [self taskDidFail:task taskIdentifier:task.taskIdentifier];
    }
    
    if ([self.delegate respondsToSelector:@selector(viewModel:taskDidCompleted:taskIdentifier:)]) {
        [self.delegate viewModel:self taskDidCompleted:task taskIdentifier:task.taskIdentifier];
    }
}

- (void)taskSending:(HZSessionTask *)task
{
    if (task.isCacheSuccess) [self taskDidFetchData:task taskIdentifier:task.taskIdentifier];
    
    if ([self.delegate respondsToSelector:@selector(viewModel:taskSending:taskIdentifier:)]) {
        [self.delegate viewModel:self taskSending:task taskIdentifier:task.taskIdentifier];
    }
}

- (void)taskDidLose:(HZSessionTask *)task
{
    if (task.isCacheSuccess) {
        [self taskDidFetchData:task taskIdentifier:task.taskIdentifier];
    }else if(task.isCacheFail) {
        [self taskDidFail:task taskIdentifier:task.taskIdentifier];
    }
    
    if ([self.delegate respondsToSelector:@selector(viewModel:taskDidLose:taskIdentifier:)]) {
        [self.delegate viewModel:self taskDidLose:task taskIdentifier:task.taskIdentifier];
    }
}

@end
