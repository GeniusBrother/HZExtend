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

/**
 *	追加分页数据,若currentPageNumber=1,则receiver的元素跟pageArray元素相同,否则都追加到后面。不会追加重复的缓存数据
 *
 *	@param pageArray  需要追加的分页数据
 *  @param currentPageNumber 当前页数
 *  @param pageSize 每页数据的数量
 */
- (void)appendPageArray:(NSArray *)pageArray pageNumber:(NSInteger)currentPageNumber pageSize:(NSInteger)pageSize;

@end

NS_ASSUME_NONNULL_END
