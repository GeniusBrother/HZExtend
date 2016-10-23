//
//  HZObserver.h
//  HZNetworkDemo
//
//  Created by xzh on 16/3/21.
//  Copyright © 2016年 xzh. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DidChangeBlock)(id object, id value);
@interface HZObserver : NSObject

/**
 *  被观察的对象
 */
@property(nonatomic, strong, readonly) id object;

/**
 *  被观察的属性
 */
@property(nonatomic, copy, readonly) NSString *objectKeyPath;

/**
 *  属性改变时调用
 */
@property(nonatomic, copy) DidChangeBlock didChange;


- (instancetype)init NS_UNAVAILABLE;

/**
 *  创建观察者
 *  didChange在值改变时调用
 */
+ (instancetype)observeObject:(id)object
                      keyPath:(NSString *)keyPath
                       change:(DidChangeBlock)didChange;

/**
 *  创建观察者
 *  didChange在观察者返回之前先调用一次
 */
+ (instancetype)observeOriginalObject:(id)object
                              keyPath:(NSString *)keyPath
                               change:(DidChangeBlock)didChange;

@end

NS_ASSUME_NONNULL_END
