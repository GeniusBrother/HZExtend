//
//  NSDictionary+HZExtend.h
//  ZHFramework
//
//  Created by xzh. on 15/7/26.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+HZExtend.h"
@interface NSDictionary (HZExtend)

/**
 *  @{ @“person”:@{@"name":@"GeniusBrotherHZExtend"}}
 *  keyPath = @"person/name" 返回@“GeniusBrotherHZExtend”;
 */
- (id)objectAtKeyPath:(NSString *)keyPath;

/**
 *  不存在,则返回other
 */
- (id)objectAtKeyPath:(NSString *)path  otherwise:(NSObject *)other;

//查询字符串
- (NSString *)keyValueString;   //返回简单的查询字符串 如:?name=xzh&age=21

//jsonString
- (NSString *)jsonString;

@end

@interface NSMutableDictionary (HZExtend)


@end