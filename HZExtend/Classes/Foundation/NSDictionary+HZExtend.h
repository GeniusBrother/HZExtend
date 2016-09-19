//
//  NSDictionary+HZExtend.h
//  ZHFramework
//
//  Created by xzh. on 15/7/26.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+HZExtend.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (HZExtend)

/**
 *  @{ @“person”:@{@"name":@"GeniusBrotherHZExtend"}}
 *  keyPath = @"person/name" 返回@“GeniusBrotherHZExtend”;
 */
- (nullable id)objectAtKeyPath:(NSString *)keyPath;

/**
 *  不存在,则返回other
 */
- (nullable id)objectAtKeyPath:(NSString *)path otherwise:(NSObject *)other;

/**
 *	查询字符串
 *
 *	@return 返回简单的查询字符串如:?name=xzh&age=21,如果自身为空，则返回nil
 */
- (nullable NSString *)keyValueString;


/**
 *	返回字符串格式的json数据，即json字符串
 */
- (NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
