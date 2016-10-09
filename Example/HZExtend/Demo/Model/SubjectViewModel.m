//
//  SubjectViewModel.m
//  HZExtend-Demo
//
//  Created by xzh on 16/2/13.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "SubjectViewModel.h"
#import "SubjectDay.h"
@implementation SubjectViewModel

- (void)loadViewModel
{
    [super loadViewModel];
    
    _task = [HZSessionTask taskWithMethod:@"GET" path:@"/subject/recommend" params:[NSMutableDictionary dictionaryWithObjectsAndKeys:@0,kNetworkPage,@1,kNetworkPageSize, nil] delegate:self taskIdentifier:@"subject"];
    self.task.importCacheOnce = NO;  //默认为导入一次,但在分页模型中多次尝试导入缓存来使每次分页数据都能从缓存中读取
    self.task.pathkeys = @[kNetworkPage,kNetworkPageSize];//设置后支持支持http://baseURL/path/value1/value2类型请求
    _subjectArray = [NSMutableArray arrayWithCapacity:20];
}

//加载数据的回调
- (void)taskDidFetchData:(HZSessionTask *)task type:(NSString *)type
{
    if([type isEqualToString:@"subject"]) {
        _subjectList = [SubjectList modelWithDic:[task.responseObject objectForKey:@"data"]];
        [self.subjectArray appendPageArray:self.subjectList.list pageNumber:task.page pageSize:task.pageSize];
    }
}

//请求失败的回调,请求失败，无网失败<br/>
- (void)taskDidFail:(HZSessionTask *)task type:(NSString *)type
{
    [task minusPage];//将当前页减一
}

- (void)saveSubject
{
    SubjectDay *day = [self.subjectList.list firstObject];
    [SubjectDay open];
    SubjectDay *existDay = [SubjectDay modelWithSql:@"select *from SubjectDay where title = ?" withParameters:@[day.title]];
    if (!existDay) {
        [day safeSave];
    }
    [SubjectDay close];
}
@end
