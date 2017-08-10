//
//  NSDictionary+HZExtend.h
//  HZFoundation <https://github.com/GeniusBrother/HZFoundation>
//
//  Created by GeniusBrother on 15/7/26.
//  Copyright (c) 2015 GeniusBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+HZExtend.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions method for `NSDictionary`.
 */
@interface NSDictionary (HZExtend)

/**
 Returns the Object specified by the given keyPath.
 
 @param keyPath A key path of the form relationship.property (with one or more relationships); for example “department.name” or “department.manager.lastName”.
 */
- (nullable id)objectForKeyPath:(NSString *)keyPath;

/**
 Returns the Object specified by the given keyPath. return def object if no object is found.
 
 @param keyPath A key path of the form relationship.property (with one or more relationships); for example “department.name” or “department.manager.lastName”.
 @param def Returns def if no object is found.
 */
- (nullable id)objectForKeyPath:(NSString *)keyPath otherwise:(id)def;

/**
 Returns the integer value specified by the given keyPath. return def if no value is found.
 
 @param keyPath A key path of the form relationship.property (with one or more relationships); for example “department.name” or “department.manager.lastName”.
 @param def Returns def if no object is found.
 */
- (NSInteger)integerValueForKeyPath:(NSString *)keyPath default:(NSInteger)def;

/**
 Returns the double value specified by the given keyPath. return def if no value is found.
 
 @param keyPath A key path of the form relationship.property (with one or more relationships); for example “department.name” or “department.manager.lastName”.
 @param def Returns def if no object is found.
 */
- (double)doubleValueForKeyPath:(NSString *)keyPath default:(double)def;
- (float)floatValueForKey:(NSString *)keyPath default:(float)def;

/**
 Returns the bool value specified by the given keyPath. return def if no value is found.
 
 @param keyPath A key path of the form relationship.property (with one or more relationships); for example “department.name” or “department.manager.lastName”.
 @param def Returns def if no object is found.
 */
- (BOOL)boolValueForKeyPath:(NSString *)keyPath default:(BOOL)def;

/**
 Returns the long long value specified by the given keyPath. return def if no value is found.
 
 @param keyPath A key path of the form relationship.property (with one or more relationships); for example “department.name” or “department.manager.lastName”.
 @param def Returns def if no object is found.
 */
- (long)longLongValueForKey:(NSString *)keyPath default:(long)def;


/**
 Returns a new dictionary containing the entries for keys.
 return nil if the keys is empty or nil.
 
 @param keys The keys.
 */
- (nullable NSDictionary *)entriesForKeys:(NSArray *)keys;

/**
 Returns a string in key1=value1&key2=value2... format. return nil if an empty dictionary.
 */
- (nullable NSString *)keyValueString;

/**
 Converts dictionary to json string. return nil if an error occurs.
 */
- (nullable NSString *)jsonString;


@end

NS_ASSUME_NONNULL_END
