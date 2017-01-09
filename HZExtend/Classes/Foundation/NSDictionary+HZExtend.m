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

- (id)objectForKeyPath:(NSString *)keyPath otherwise:(NSObject *)other
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
    
    NSMutableString *string = [NSMutableString stringWithString:@"?"];
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

- (NSInteger)integerValueForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    }else {
        return 0;
    }
}

- (BOOL)boolValueForKey:(NSString *)key
{
    id value = [self objectForKey:key];

    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value boolValue];
    }else {
        return NO;
    }
}

- (double)doubleValueForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value doubleValue];
    }else {
        return 0.0;
    }
}

@end

@implementation NSMutableDictionary (HZExtend)


@end
