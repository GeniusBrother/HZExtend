//
//  NSArray+HzExtend.h
//  ZHFramework
//
//  Created by xzh. on 15/7/20.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+HZExtend.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (HZExtend)

//数字排序
+ (nullable NSArray *)sortedWithArray:(NSArray *)numbers;

//防止越界
- (nullable id)objectAtSafeIndex:(NSInteger)index;

//倒序数组
- (NSArray *)reversedArray;

/**
 *	返回字符串格式的json数据,即json字符串
 */
- (NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
