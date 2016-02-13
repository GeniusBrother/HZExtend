//
//  NSMutableArray+HZExtend.h
//  HZNetworkDemo
//
//  Created by xzh on 16/2/1.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+HZExtend.h"
@interface NSMutableArray (HZExtend)

/**
 *  防止越界crash
 */
- (void)safeRemoveObjectAtIndex:(NSInteger)index;

@end
