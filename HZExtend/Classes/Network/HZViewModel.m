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

/** 发送失败的原因字典*/
@property(nonatomic, strong) NSMutableDictionary *reasonDic;

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

- (void)loadViewModel
{
    _reasonDic = [NSMutableDictionary dictionary];
}

- (void)taskDidFetchData:(HZSessionTask *)task taskIdentifier:(NSString *)taskIdentifier {}
- (void)taskDidFail:(HZSessionTask *)task taskIdentifier:(NSString *)taskIdentifier {}
- (NSString *)networkLostErrorMsg { return nil; }

- (BOOL)shouldSendTask:(HZSessionTask *)task reasonDic:(NSMutableDictionary *)reasonDic
{
    if (![HZNetworkConfig sharedConfig].reachable) {
        NSString *errorMsg = [self networkLostErrorMsg]?:([HZNetworkConfig sharedConfig].networkLostErrorMsg?:@"");
        [reasonDic setObject:errorMsg forKey:task.taskIdentifier];
        return NO;
    }
    return YES;
}

#pragma mark - Public Method
- (void)sendTask:(HZSessionTask *)sessionTask handle:(HZNetworkSendTaskHandleBlock)handleBlock
{
    NSAssert(sessionTask, @"%@不能发送空的请求任务",self);
    BOOL result = [self shouldSendTask:sessionTask reasonDic:self.reasonDic];
    if (!result) {
        [[HZNetwork sharedNetwork] send:sessionTask];
        if (handleBlock) handleBlock(nil);
    }else {
        if (handleBlock) handleBlock([NSError errorWithDomain:@"com.HZNetwork" code:400 userInfo:@{@"NSLocalizedDescription":[self failSendReasonForTask:sessionTask]?:@"error"}]);
    }
}

- (void)sendTaskWithName:(NSString *)taskName handle:(nonnull HZNetworkSendTaskHandleBlock)handleBlock
{
    NSAssert([self respondsToSelector:NSSelectorFromString(taskName)], @"%@:无该请求任务%@",self,taskName);
    HZSessionTask *task = [self valueForKey:taskName];
    [self sendTask:task handle:handleBlock];
}

- (void)sendUploadTask:(HZUploadSessionTask *)sessionTask progress:(void (^)(NSProgress *))uploadProgressBlock handle:(nonnull HZNetworkSendTaskHandleBlock)handleBlock
{
    NSAssert(sessionTask, @"%@不能发送空的请求任务",self);
    BOOL result = [self shouldSendTask:sessionTask reasonDic:self.reasonDic];
    if (!result) {
        [[HZNetwork sharedNetwork] upload:sessionTask progress:uploadProgressBlock];
        if (handleBlock) handleBlock(nil);
    }else {
        if (handleBlock) handleBlock([NSError errorWithDomain:@"com.HZNetwork" code:400 userInfo:@{@"NSLocalizedDescription":[self failSendReasonForTask:sessionTask]?:@"error"}]);
    }
}

- (void)cancelTask:(HZSessionTask *)sessionTask
{
    [[HZNetwork sharedNetwork] cancel:sessionTask];
}

- (NSString *)failSendReasonForTask:(HZSessionTask *)task
{
    return [self.reasonDic objectForKey:task.taskIdentifier];
}

#pragma mark - SessionTaskDelegate
/**
 *  主要实现了回调
 */
- (void)taskComplted:(HZSessionTask *)task
{
    if (task.succeed) {
        [self taskDidFetchData:task taskIdentifier:task.taskIdentifier];
    }else {
        [self taskDidFail:task taskIdentifier:task.taskIdentifier];
    }
    
    if ([self.delegate respondsToSelector:@selector(viewModel:taskDidCompleted:type:)]) {
        [self.delegate viewModel:self taskDidCompleted:task taskIdentifier:task.taskIdentifier];
    }
}

- (void)taskSending:(HZSessionTask *)task
{
    if (task.cacheSuccess) [self taskDidFetchData:task taskIdentifier:task.taskIdentifier];
    
    if ([self.delegate respondsToSelector:@selector(viewModel:taskSending:type:)]) {
        [self.delegate viewModel:self taskSending:task taskIdentifier:task.taskIdentifier];
    }
}

- (void)taskLosted:(HZSessionTask *)task
{
    if (task.cacheSuccess) {
        [self taskDidFetchData:task taskIdentifier:task.taskIdentifier];
    }else if(task.cacheFail) {
        [self taskDidFail:task taskIdentifier:task.taskIdentifier];
    }
    
    if ([self.delegate respondsToSelector:@selector(viewModel:taskDidLose:type:)]) {
        [self.delegate viewModel:self taskDidLose:task taskIdentifier:task.taskIdentifier];
    }
}

@end
