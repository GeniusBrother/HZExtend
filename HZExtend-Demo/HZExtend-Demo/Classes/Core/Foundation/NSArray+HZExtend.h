//
//  NSArray+HzExtend.h
//  ZHFramework
//
//  Created by xzh. on 15/7/20.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+HZExtend.h"
@interface NSArray (HZExtend)

//防止越界
- (id)objectAtSafeIndex:(NSInteger)index;

//数字排序
- (NSArray *)sortedWithArray:(NSArray *)numbers;

//倒序数组
- (NSArray *)reverseForArray:(NSArray *)array;

//jsonString
- (NSString *)jsonString;

@end
