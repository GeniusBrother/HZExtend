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
- (void)taskDidFetchData:(HZSessionTask *)task {}
- (void)taskDidFail:(HZSessionTask *)task {}

#pragma mark - HZSessionTaskDelegate
- (void)taskDidCompleted:(HZSessionTask *)task
{
    if (task.state == HZSessionTaskStateSuccess) {
        [self taskDidFetchData:task];
    }else {
        [self taskDidFail:task];
    }
    
    if ([self.delegate respondsToSelector:@selector(viewModel:taskDidCompleted:)]) {
        [self.delegate viewModel:self taskDidCompleted:task];
    }
}

- (void)taskSending:(HZSessionTask *)task
{
    if (task.cacheImportState == HZSessionTaskCacheImportStateSuccess) [self taskDidFetchData:task];
    
    if ([self.delegate respondsToSelector:@selector(viewModel:taskSending:)]) {
        [self.delegate viewModel:self taskSending:task];
    }
}

- (void)taskDidCancel:(HZSessionTask *)task
{
    if ([self.delegate respondsToSelector:@selector(viewModel:taskDidCancel:)]) {
        [self.delegate viewModel:self taskDidCancel:task];
    }
}

- (NSString *)taskShouldPerform:(HZSessionTask *)task { return nil; }

@end
