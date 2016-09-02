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
@end
