//
//  HZViewModel.m
//  ZHFramework
//
//  Created by xzh. on 15/8/19.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "HZViewModel.h"
#import "UploadSessionTask.h"
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
- (void)loadDataWithTask:(SessionTask *)task type:(NSString *)type {}
- (void)requestFailWithTask:(SessionTask *)task type:(NSString *)type {}

#pragma mark - Page
- (void)pageIncrease:(SessionTask *)task
{
    NSNumber *oldNumber = [task.params objectForKey:kNetworkPage];
    
    if (oldNumber) {
        [task.params setObject:@(oldNumber.integerValue+1) forKey:kNetworkPage];
    }
    
}

- (void)pageDecrease:(SessionTask *)task
{
    NSNumber *oldNumber = [task.params objectForKey:kNetworkPage];
    
    if (oldNumber.integerValue >=2) {
        [task.params setObject:@(oldNumber.integerValue-1) forKey:kNetworkPage];
    }
}

- (void)pageOrigin:(SessionTask *)task
{
    [task.params setObject:@1 forKey:kNetworkPage];
}

- (void)pageArray:(NSString *)pageArrayName appendArray:(NSArray *)appendArray task:(SessionTask *)task;
{
    if (appendArray.isNoEmpty){
        NSInteger pageNumber = task.page;
        if (pageNumber == 1) {  //1.第一页时对数组进行初始化
            [self setValue:[NSMutableArray arrayWithCapacity:appendArray.count] forKey:pageArrayName];
        }else if (pageNumber >1) {  //2.大于第一页时如果有缓存数据去掉缓存数据
            NSMutableArray *pageArray = [self valueForKey:pageArrayName];
            NSInteger preCount = (pageNumber-1)*task.pageSize;
            if (pageArray.count > preCount) {
                [pageArray removeObjectsInRange:NSMakeRange(preCount-1, pageArray.count-preCount)];
            }
        }
        
        //3.追加数据
        [[self valueForKey:pageArrayName] addObjectsFromArray:appendArray];
    }
}

#pragma mark - Network
- (void)sendTask:(SessionTask *)sessionTask
{    
    [[HZNetwork sharedNetwork] send:sessionTask];
}

- (void)uploadTask:(UploadSessionTask *)sessionTask progress:(void (^)(NSProgress *))uploadProgressBlock
{
    return [[HZNetwork sharedNetwork] upload:sessionTask progress:uploadProgressBlock];
}

- (void)cancelTask:(SessionTask *)sessionTask
{
    [[HZNetwork sharedNetwork] cancel:sessionTask];
}

#pragma mark - SessionTaskDelegate
/**
 *  主要实现了回调
 */
- (void)taskConnected:(SessionTask *)task
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

- (void)taskSending:(SessionTask *)task
{
    if (task.cacheSuccess) [self loadDataWithTask:task type:task.requestType];
    
    if ([self.delegate respondsToSelector:@selector(viewModelSendingNotifyForTask:type:)]) {
        [self.delegate viewModelSendingNotifyForTask:task type:task.requestType];
    }
}

- (void)taskLosted:(SessionTask *)task
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
