//
//  NSArray+HZExtend.m
//  HZFoundation <https://github.com/GeniusBrother/HZFoundation>
//
//  Created by GeniusBrother on 15/7/20.
//  Copyright (c) 2015 GeniusBrother. All rights reserved.
//

#import "NSArray+HZExtend.h"
@implementation NSArray (HZExtend)

- (id)objectAtSafeIndex:(NSInteger)index
{
    if (self.count == 0 || index == NSNotFound || (index >(self.count-1)) || index < 0)
    {
        return nil;
    }
    
    return [self objectAtIndex:index];
}

- (NSArray *)subarrayWithSafeRange:(NSRange)range
{
    if ( 0 == self.count )
        return nil;
    
    if ( range.location >= self.count )
        return nil;
    
    if ( range.location + range.length >= self.count )
        return nil;
    
    return [self subarrayWithRange:NSMakeRange(range.location, range.length)];
}

- (NSArray *)map:(id  _Nonnull (^)(id _Nonnull))block
{
    __block NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [array addObject:block(obj)];
    }];
    return array;
}


- (NSArray *)reversedArray
{
    return self.reverseObjectEnumerator.allObjects;
}

- (NSString *)jsonString
{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}

@end


@implementation NSMutableArray (HZExtend)

- (void)addSafeObject:(id)object
{
    if (!object || [object isKindOfClass:[NSNull class]]) return;
    
    [self addObject:object];
}

- (void)safeRemoveObjectAtIndex:(NSInteger)index
{
    if (index >(self.count-1) || index < 0)
    {
        NSAssert(NO, @"out of bound");
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

@end

@implementation NSMutableArray (HZDeprecated)

- (void)appendPageArray:(NSArray *)pageArray pageNumber:(NSInteger)pageNumber pageSize:(NSInteger)pageSize
{
    if (!pageArray.isNoEmpty) return;
    if (pageNumber == 1) {  //1.第一页时对数组进行初始化
        [self setArray:pageArray];
    }else if (pageNumber >1) {  //2.大于第一页时如果有缓存数据去掉缓存数据
        NSInteger preCount = (pageNumber - 1) * pageSize;
        if (self.count > preCount) {
            [self removeObjectsInRange:NSMakeRange(preCount, self.count - preCount)];
        }
        //3.追加数据
        [self addObjectsFromArray:pageArray];
    }
}

- (void)removeDataForPage:(NSInteger)page pageSize:(NSInteger)pageSize
{
    NSInteger reserverCount = (page - 1) * pageSize;
    if (self.count > reserverCount && reserverCount >= 0) {
        NSArray *reserveArray = [self subarrayWithRange:NSMakeRange(0, reserverCount)];
        [self setArray:reserveArray];
    }
}

@end
