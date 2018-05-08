//
//  NSString+HZExtend.m
//  HZFoundation <https://github.com/GeniusBrother/HZFoundation>
//
//  Created by GeniusBrother on 15/7/20.
//  Copyright (c) 2015 GeniusBrother. All rights reserved.
//


#import "NSString+HZExtend.h"
#import "NSData+HZExtend.h"
@implementation NSString (HZExtend)

- (NSString *)stringByTrim
{
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (NSRange)rangeOfAll
{
    return NSMakeRange(0, self.length);
}

#pragma mark - URL
- (NSString *)urlEncode
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"-_.!*'();:@$,[]"]];
}

- (NSString *)urlDecode
{
    return [self stringByRemovingPercentEncoding];
}

- (NSString *)urlAppendingKeyValue:(NSString *)keyValue
{
    NSString *separator = [self rangeOfString:@"?"].length == 0?@"?":@"&";
    return [self stringByAppendingFormat:@"%@%@",separator,keyValue];
}

- (NSString *)md5String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5String];
}

- (NSString *)sha1String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1String];
}

- (NSString *)hmacSHA1StringWithKey:(NSString *)key
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] hmacSHA1StringWithKey:key];
}

- (id)jsonObject
{
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
}

- (BOOL)matchesRegx:(NSString *)regex options:(NSRegularExpressionOptions)options
{
    if (!regex.isNoEmpty) return NO;
    
    NSError *error;
    NSRegularExpression *rx = [NSRegularExpression regularExpressionWithPattern:regex options:options error:&error];
    if (error) return NO;
    
    NSRange range = [rx rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    return range.length != 0;
}

- (void)enumerateRegexMatches:(NSString *)regex options:(NSRegularExpressionOptions)options usingBlock:(void (^)(NSString * _Nonnull, NSRange, BOOL * _Nonnull))block
{
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
    if (!regExp) return;
    [regExp enumerateMatchesInString:self options:kNilOptions range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        block([self substringWithRange:result.range], result.range, stop);
    }];
}

- (NSString *)stringByReplacingRegex:(NSString *)regex options:(NSRegularExpressionOptions)options withString:(NSString *)replacement
{
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
    if (!pattern) return self;
    return [pattern stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:replacement];
}

+ (NSString *)UUIDString
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}



@end
