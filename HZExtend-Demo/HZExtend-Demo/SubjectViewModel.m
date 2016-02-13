//
//  SubjectViewModel.m
//  HZExtend-Demo
//
//  Created by xzh on 16/2/13.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "SubjectViewModel.h"

@implementation SubjectViewModel

- (void)loadViewModel
{
    [super loadViewModel];
    
    _task = [SessionTask taskWithMethod:@"GET" path:@"/subject/recommend" params:[NSMutableDictionary dictionaryWithObjectsAndKeys:@0,kNetworkPage,@1,kNetworkPageSize, nil] delegate:self requestType:@"subject"];
    self.task.importCacheOnce = NO;  //默认为导入一次,但在分页模型中多次尝试导入缓存来使每次分页数据都能从缓存中读取
    self.task.pathkeys = @[kNetworkPage,kNetworkPageSize];//设置后支持支持http://baseURL/path/value1/value2类型请求
}

//加载数据的回调
- (void)loadDataWithTask:(SessionTask *)task type:(NSString *)type
{
    if([type isEqualToString:@"subject"]) {
        _subjectList = [SubjectList modelWithDic:[task.responseObject objectForKey:@"data"]];
        [self pageArray:@"subjectArray" appendArray:self.subjectList.list task:task];  //追加分页数据
    }
}

//请求失败的回调,请求失败，无网失败<br/>
- (void)requestFailWithTask:(SessionTask *)task type:(NSString *)type
{
    [self pageDecrease:task]; //将当前页减一
}
@end
