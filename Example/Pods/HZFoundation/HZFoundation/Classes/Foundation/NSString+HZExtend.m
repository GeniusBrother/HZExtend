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

- (NSString *)stringByTrim
{
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

#pragma mark - URL
- (NSString *)urlEncode
{
    if (self.length == 0) return @"";
    
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)urlDecode
{
    if (self.length == 0) return @"";
    
    return self.stringByRemovingPercentEncoding;
}

- (NSString *)md5String
{
    NSData *value = [[NSData dataWithBytes:[self UTF8String] length:[self length]] md5Data];
    
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

+ (NSString *)UUIDString
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}



@end
