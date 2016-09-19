//
//  NSArray+HzExtend.m
//  ZHFramework
//
//  Created by xzh. on 15/7/20.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "NSArray+HZExtend.h"
#import "HZMacro.h"
@implementation NSArray (HZExtend)

- (id)objectAtSafeIndex:(NSInteger)index
{
    if (index >(self.count-1) || index < 0)
    {
        HZLog(@"out of bound");
        return nil;
    }
    
    return [self objectAtIndex:index];
}

- (NSArray *)reversedArray
{
    return self.reverseObjectEnumerator.allObjects;
}

- (NSString *)jsonString
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
