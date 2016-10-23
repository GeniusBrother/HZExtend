//
//  HZObserver.m
//  HZNetworkDemo
//
//  Created by xzh on 16/3/21.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "HZObserver.h"
#import "NSObject+HZExtend.h"
#import "HZMacro.h"
#import "HZMacro.h"
@interface HZObserver ()

@property(nonatomic, strong) id object;
@property(nonatomic, copy) NSString *objectKeyPath;

@end

@implementation HZObserver

#pragma mark - Init
+ (instancetype)observeObject:(id)object
                      keyPath:(NSString *)keyPath
                      options:(NSKeyValueObservingOptions)options
                      context:(void *)context
                       change:(DidChangeBlock)didChange
{
    if (object && !keyPath.isNoEmpty) return nil;
    
    HZObserver *observer = [[self alloc] init];
    observer.didChange = didChange;
    observer.object = object;
    observer.objectKeyPath = keyPath;
    [object addObserver:observer forKeyPath:keyPath options:options context:context];
    return observer;
    
}

+ (instancetype)observeObject:(id)object
                      keyPath:(NSString *)keyPath
                       change:(DidChangeBlock)didChange
{
    return [self observeObject:object keyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL change:didChange];
}

+ (instancetype)observeOriginalObject:(id)object
                              keyPath:(NSString *)keyPath
                               change:(DidChangeBlock)didChange
{
    return [self observeObject:object keyPath:keyPath options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial) context:NULL change:didChange];
}

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (self.didChange) {
        self.didChange(object,[change objectForKey:NSKeyValueChangeNewKey]);
    }
}

- (void)dealloc
{
    @try {
        //观察者无观察该keyPath,调用会crash
        [self.object removeObserver:self forKeyPath:self.objectKeyPath];
        HZLog(@"%@销毁了",self);
    } @catch (NSException *exception) {
        NSAssert(NO, @"removeObserver Error");  //处理绝不会发生的情况使用断言，提前捕获脏数据，否则不稳定
    }

}

@end
