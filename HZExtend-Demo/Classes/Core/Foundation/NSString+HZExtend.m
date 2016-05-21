//
//  NSString+HzExtend.m
//  ZHFramework
//
//  Created by xzh. on 15/7/20.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "NSString+HZExtend.h"
#import "NSData+HZExtend.h"
@implementation NSString (HZExtend)

#pragma mark - URL
- (NSString *)urlEncode
{
    if (self.length == 0) return @"";
    
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    /*
    NSString *encodedValue = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                                  (CFStringRef)string, nil,
                                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return encodedValue;
     */
}

- (NSString *)urlDecode
{
    if (self.length == 0) return @"";
    
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)scheme
{
    NSRange range = [self rangeOfString:@"://"];
    if (range.length == 0) return @"";
    
    NSString *scheme = [self substringToIndex:range.location];
    return scheme;
}

- (NSString *)host
{
    NSString *scheme = self.scheme;
    if (!scheme.isNoEmpty) return @"";  //无schema该情况下无host
    
    NSString *noScheme = [self stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@://",scheme] withString:@""];
    
    NSRange range = [noScheme rangeOfString:@"/"];
    if (range.length == 0) {    //无path
        NSRange queryRange = [noScheme rangeOfString:@"?"];
        //无查询字符串
        if(queryRange.length == 0) {
            return noScheme;
        }else {//有查询字符串
            return [noScheme substringToIndex:queryRange.location];
        }
    }else {
        return [noScheme substringToIndex:range.location];
    }
    
    return @"";
}

- (NSString *)keyValues
{
    NSString *scheme = self.scheme;
    if (!scheme.isNoEmpty) return @"";
    
    NSRange range = [self rangeOfString:@"?"];
    if (range.length == 0) return @"";
    
    return [self substringFromIndex:range.location+1];
}

- (NSDictionary *)queryDic
{
    NSString *keyValues = self.keyValues;
    if (!keyValues.isNoEmpty) return @{};
    
    return [self queryDicWithKeysValues:keyValues];
}

- (NSString *)path
{
    NSString *scheme = self.scheme;
    if (!scheme.isNoEmpty) return @"";
    
    NSString *path = nil;
    NSString *host = self.host;
    if (host.isNoEmpty) path = [self stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@://%@",scheme,host] withString:@""];
    
    NSString *keyValue = self.keyValues;
    if (keyValue.isNoEmpty) path = [path stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"?%@",keyValue] withString:@""];
    
    return path;
}

- (NSString *)allPath
{
    NSString *scheme = self.scheme;
    if (!scheme.isNoEmpty) return @"";
    
    NSString *keyValue = self.keyValues;
    if (keyValue.isNoEmpty) return [self stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"?%@",keyValue] withString:@""];
    
    return self;
}

#pragma mark - Security
- (NSString *)md5
{
    NSData *value = [[NSData dataWithBytes:[self UTF8String] length:[self length]] md5];
    
    if (value)
    {
        char			tmp[16];
        unsigned char *	hex = (unsigned char *)malloc( 2048 + 1 );
        unsigned char *	bytes = (unsigned char *)[value bytes];
        unsigned long	length = [value length];
        
        hex[0] = '\0';
        
        for ( unsigned long i = 0; i < length; ++i )
        {
            sprintf( tmp, "%02X", bytes[i] );
            strcat( (char *)hex, tmp );
        }
        
        NSString * result = [NSString stringWithUTF8String:(const char *)hex];
        free( hex );
        return result;
    }
    else
    {
        return nil;
    }
}

#pragma mark - Private
//从k=v中获取键值
- (NSString *)valueFromKeyValue:(NSString *)keyValue atIndex:(NSUInteger)index
{
    return [[keyValue componentsSeparatedByString:@"="] objectAtIndex:index];
}

- (NSDictionary *)queryDicWithKeysValues:(NSString *)keysValues
{
    if (!keysValues.isNoEmpty) return @{};
    
    NSArray *pairArray = [keysValues componentsSeparatedByString:@"&"];  //键值对字符串
    NSMutableDictionary *queryDic= [NSMutableDictionary dictionaryWithCapacity:pairArray.count];
    NSString *key = nil;
    NSString *obj = nil;
    if (pairArray.count > 1)
    {
        for (NSString *pair in pairArray)
        {
            key = [self valueFromKeyValue:pair atIndex:0];
            obj = [self valueFromKeyValue:pair atIndex:1];
            [queryDic setObject:obj forKey:key];
        }
    }
    else if (pairArray.count == 1)
    {
        key = [self valueFromKeyValue:keysValues atIndex:0];
        obj = [self valueFromKeyValue:keysValues atIndex:1];
        [queryDic setObject:obj forKey:key];
    }
    
    return queryDic;
}
@end
