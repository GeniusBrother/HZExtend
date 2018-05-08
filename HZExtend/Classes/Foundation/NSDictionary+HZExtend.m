//
//  NSDictionary+HZExtend.m
//  HZFoundation <https://github.com/GeniusBrother/HZFoundation>
//
//  Created by GeniusBrother on 15/7/26.
//  Copyright (c) 2015 GeniusBrother. All rights reserved.
//

#import "NSDictionary+HZExtend.h"

@implementation NSDictionary (HZExtend)

- (id)objectForKeyPath:(NSString *)keyPath
{
    if (!keyPath.isNoEmpty) return nil;
    
    NSArray * array = [keyPath componentsSeparatedByString:@"."];
    if ( 0 == array.count ) return nil;
    
    NSObject * result = nil;
    NSDictionary * dict = self;
    
    for (NSString * subPath in array )
    {
        if (0 == subPath.length) continue;
        
        result = [dict objectForKey:subPath];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            dict = (NSDictionary *)result;
            continue;
        }else if([array lastObject] == subPath){
            return result;
        }else {
            return nil;
        }
    }
    
    return [result isKindOfClass:[NSNull class]]?nil:result;
}

- (id)objectForKeyPath:(NSString *)keyPath otherwise:(id)other
{
    NSObject *obj = [self objectForKeyPath:keyPath];
    
    if ([obj isKindOfClass:[NSNull class]] || obj == nil) {
        return other;
    }
    
    return obj;
}

- (NSDictionary *)entriesForKeys:(NSArray *)keys
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (id key in keys) {
        id value = self[key];
        if (value) dic[key] = value;
    }
    return dic;
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

- (NSInteger)integerValueForKeyPath:(NSString *)keyPath def:(NSInteger)def
{
    id value = [self objectForKeyPath:keyPath];
    
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value integerValue];
    }else {
        return def;
    }
}

- (long)longLongValueForKey:(NSString *)keyPath def:(long)def
{
    id value = [self objectForKeyPath:keyPath];
    
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value longLongValue];
    }else {
        return def;
    }
}

- (BOOL)boolValueForKeyPath:(NSString *)keyPath def:(BOOL)def
{
    id value = [self objectForKeyPath:keyPath];

    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value boolValue];
    }else {
        return def;
    }
}

- (double)doubleValueForKeyPath:(NSString *)keyPath def:(double)def
{
    id value = [self objectForKeyPath:keyPath];
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value doubleValue];
    }else {
        return def;
    }
}

- (float)floatValueForKey:(NSString *)keyPath def:(float)def
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
