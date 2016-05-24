//
//  NSMutableArray+HZExtend.h
//  HZNetworkDemo
//
//  Created by xzh on 16/2/1.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+HZExtend.h"
NS_ASSUME_NONNULL_BEGIN
@interface NSMutableArray (HZExtend)

/**
 *  若下标越界时,则什么也不做
 */
- (void)safeRemoveObjectAtIndex:(NSInteger)index;

@end
NS_ASSUME_NONNULL_END