//
//  NSMutableArray+HZExtend.m
//  HZNetworkDemo
//
//  Created by xzh on 16/2/1.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "NSMutableArray+HZExtend.h"
#import "HZMacro.h"
@implementation NSMutableArray (HZExtend)

- (void)safeRemoveObjectAtIndex:(NSInteger)index
{
    if (index >(self.count-1) || index < 0)
    {
        HZLog(@"out of bound");
        return;
    }
    [self removeObjectAtIndex:index];
}

- (void)addUniqueObject:(id)object compare:(NSMutableArrayCompareBlock)compare
{
    __block BOOL isUnique = YES;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (compare) {
            
            NSComparisonResult result = compare(obj,object);
            if (NSOrderedSame == result)
            {
                isUnique = NO;
                *stop = YES;
            }
        }else if ([obj class] == [object class] && [obj respondsToSelector:@selector(compare:)]) {
            
            NSComparisonResult result = [obj compare:object];
            if (NSOrderedSame == result)
            {
                isUnique = NO;
                *stop = YES;
            }
        }
    }];

    if (isUnique) [self addObject:object];
}

- (void)appendPageArray:(NSArray *)pageArray pageNumber:(NSInteger)pageNumber pageSize:(NSInteger)pageSize
{
    if (!pageArray.isNoEmpty) return;
    if (pageNumber == 1) {  //1.第一页时对数组进行初始化
        [self setArray:pageArray];
    }else if (pageNumber >1) {  //2.大于第一页时如果有缓存数据去掉缓存数据
        NSInteger preCount = (pageNumber - 1) * pageSize;
        if (self.count > preCount) {
            [self removeObjectsInRange:NSMakeRange(preCount-1, self.count - preCount)];
        }
        //3.追加数据
        [self addObjectsFromArray:pageArray];
    }
}

@end
