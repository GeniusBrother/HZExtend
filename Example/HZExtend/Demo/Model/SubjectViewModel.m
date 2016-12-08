//
//  SubjectViewModel.m
//  HZExtend-Demo
//
//  Created by xzh on 16/2/13.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "SubjectViewModel.h"
#import "SubjectDay.h"
#import "HZSessionTask+Params.h"
#import "NetworkPath.h"
@implementation SubjectViewModel

- (void)loadViewModel
{
    [super loadViewModel];
    
    _task = [HZSessionTask taskWithMethod:@"POST" path:kRecommendPath params:[NSMutableDictionary dictionaryWithObjectsAndKeys:@0,kNetworkPage,@1,kNetworkPageSize, nil] delegate:self taskIdentifier:kRecommendPath];
    self.task.importCacheOnce = NO;  //默认为导入一次,但在分页模型中多次尝试导入缓存来使每次分页数据都能从缓存中读取
//    self.task.pathkeys = @[kNetworkPage,kNetworkPageSize];//设置后支持支持http://baseURL/path/value1/value2类型请求
    _subjectArray = [NSMutableArray arrayWithCapacity:20];
}

- (void)taskDidFetchData:(HZSessionTask *)task taskIdentifier:(nonnull NSString *)taskIdentifier
{
    if([taskIdentifier isEqualToString:kRecommendPath]) {
        _subjectList = [SubjectList modelWithDic:[task.responseObject objectForKey:@"data"]];
        [self.subjectArray appendPageArray:self.subjectList.list pageNumber:task.page pageSize:task.pageSize];
    }
}

- (void)taskDidFail:(HZSessionTask *)task taskIdentifier:(nonnull NSString *)taskIdentifier
{
    [task minusPage];//将当前页减一
}

- (NSString *)taskShouldPerform:(HZSessionTask *)task taskIdentifier:(NSString *)taskIdentifier
{
    return task.page == 3?@"第三页的时候我就会拦截你":nil;
}

- (void)saveSubject
{
    SubjectDay *day = [self.subjectList.list firstObject];
    SubjectDay *existDay = [SubjectDay modelInDBWithKey:@"title" value:day.title];
    if (!existDay) {
        [day safeSave];
    }

}
@end
