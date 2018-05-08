//
//  NSArray+HZExtend.h
//  HZFoundation <https://github.com/GeniusBrother/HZFoundation>
//
//  Created by GeniusBrother on 15/7/20.
//  Copyright (c) 2015 GeniusBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+HZExtend.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for `NSArray`.
 */
@interface NSArray (HZExtend)

/**
 Returns the object located at index, or return nil when out of bounds
 
 @param index index of the object
 */
- (nullable id)objectAtSafeIndex:(NSInteger)index;

/**
 Returns a new array containing the receiving array’s elements that fall within the limits specified by a given range, or return nil if range isn’t within the receiving array’s range of elements.
 
 @param A range within the receiving array’s range of elements.
 */
- (nullable NSArray *)subarrayWithSafeRange:(NSRange)range;

/**
 Applies the callback to the elements of the given arrays.
 
 @return an new array containing all the elements of receiver after applying the callback function to each one.
 */
- (NSArray *)map:(id (^)(id obj))block;

/**
 Returns a reversed Array
 */
- (NSArray *)reversedArray;

/**
 Converts receiver to json string. return nil if an error occurs.
 */
- (NSString *)jsonString;

@end



typedef NSComparisonResult	(^NSMutableArrayCompareBlock)(id left, id right);
@interface NSMutableArray (HZExtend)

/**
 Inserts a given object at the end of the array.
 
 @discussion The object to add to the end of the array’s content. Doing nothing if object is nil or null
 
 @param object the object to be added.
 */
- (void)addSafeObject:(id)object;

/**
 Removes the object located at index.
 
 @discussion If index is out of bounds, the method has no effect and never throw exception.

 @param index index of the object
 */
- (void)safeRemoveObjectAtIndex:(NSInteger)index;

/**
 Adds unique objects.
 
 @param object the object to be added.
 @param compare A comparator block.
 */
- (void)addUniqueObject:(id)object compare:(NSMutableArrayCompareBlock)compare;

@end



/**
 Provide some some common method for `NSMutableArray`.
 */
@interface NSMutableArray (HZDeprecated)

- (void)appendPageArray:(NSArray *)pageArray pageNumber:(NSInteger)currentPageNumber pageSize:(NSInteger)pageSize __deprecated_msg("已经废弃");

- (void)removeDataForPage:(NSInteger)page pageSize:(NSInteger)pageSize __deprecated_msg("已经废弃");

@end

NS_ASSUME_NONNULL_END
