//
//  NSObject+HZORMModel.h
//  HZORM <https://github.com/GeniusBrother/HZORM>
//
//  Created by GeniusBrother on 17/8/15.
//  Copyright (c) 2017 GeniusBrother. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 ORMModel should implement theses methods to provide the structure of table.
 */
@interface NSObject (HZORMModel)

/**
 Returns the name of table. Defaults to class name.
 */
+ (NSString *)getTabelName;

/**
 Returns the mapping of fields and attributes. Defaults to same name.
 */
+ (NSDictionary<NSString *, NSString *> *)getColumnMap;

/**
 Returns the primary key of table. Defaults to "id"
 */
+ (NSArray<NSString *> *)getPrimaryKeys;

/**
 Returns whether the primary key is auto-increment. Default is YES
 */
+ (BOOL)isIncrementing;

/**
 Returns the attributes that should be cast to native types.
 */
+ (NSDictionary<NSString *, NSString *> *)getCasts;

/** Executes before insert. */
- (void)beforeInsert;

/** Executes after insert successfully. */
- (void)sucessInsert;

/** Executes before update. */
- (void)beforeUpdate;

/** Executes after update successfully. */
- (void)sucessUpdate;

/** Executes before remove. */
- (void)beforeRemove;

/** Executes after remove successfully. */
- (void)sucessRemove;

@end

NS_ASSUME_NONNULL_END
