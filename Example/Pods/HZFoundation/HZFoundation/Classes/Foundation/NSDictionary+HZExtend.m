//
//  NSDictionary+HzExtend.m
//  ZHFramework
//
//  Created by xzh. on 15/7/26.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "NSDictionary+HZExtend.h"

@implementation NSDictionary (HZExtend)

- (id)objectForKeyPath:(NSString *)keyPath
{
    if (!keyPath.isNoEmpty) return nil;
    
    NSObject *result = [self valueForKeyPath:keyPath];
    return result;
}

- (id)objectForKeyPath:(NSString *)keyPath otherwise:(id)other
{
    NSObject *obj = [self objectForKeyPath:keyPath];
    
    if ([obj isKindOfClass:[NSNull class]] || obj == nil) {
        return other;
    }
    
    return obj;
}

- (NSString *)keyValueString
{
    if (!self.isNoEmpty) return nil;
    
    NSMutableString *string = [NSMutableString string];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [string appendFormat:@"%@=%@&",key,obj];
    }];
    
    NSRange range = [string rangeOfString:@"&" options:NSBackwardsSearch];
    [string deleteCharactersInRange:range];
    
    return string;
}

- (NSString *)jsonString
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSInteger)integerValueForKeyPath:(NSString *)keyPath default:(NSInteger)def
{
    id value = [self objectForKeyPath:keyPath];
    
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value integerValue];
    }else {
        return def;
    }
}

- (long)longLongValueForKey:(NSString *)keyPath default:(long)def
{
    id value = [self objectForKeyPath:keyPath];
    
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value longLongValue];
    }else {
        return def;
    }
}

- (BOOL)boolValueForKeyPath:(NSString *)keyPath default:(BOOL)def
{
    id value = [self objectForKeyPath:keyPath];

    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value boolValue];
    }else {
        return def;
    }
}

- (double)doubleValueForKeyPath:(NSString *)keyPath default:(double)def
{
    id value = [self objectForKeyPath:keyPath];
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value doubleValue];
    }else {
        return def;
    }
}

- (float)floatValueForKey:(NSString *)keyPath default:(float)def
{
    id value = [self objectForKeyPath:keyPath];
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value floatValue];
    }else {
        return def;
    }
}

@end

@implementation NSMutableDictionary (HZExtend)


@end
