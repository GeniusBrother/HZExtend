//
//  NSData+HZExtend.m
//  HZFoundation <https://github.com/GeniusBrother/HZFoundation>
//
//  Created by GeniusBrother on 15/7/26.
//  Copyright (c) 2015 GeniusBrother. All rights reserved.
//

#import "NSData+HZExtend.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation NSData (HZExtend)
- (NSData *)md5Data
{
    unsigned char	md5Result[CC_MD5_DIGEST_LENGTH + 1];
    CC_LONG			md5Length = (CC_LONG)[self length];
    CC_MD5( [self bytes], md5Length, md5Result );
    
    NSMutableData * retData = [[NSMutableData alloc] init];
    [retData appendBytes:md5Result length:CC_MD5_DIGEST_LENGTH];
    return retData;
}

- (NSData *)sha1Data
{
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)sha1String
{
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

- (NSString *)hmacSHA1StringWithKey:(NSString *)key
{
    return [self hmacStringUsingAlg:kCCHmacAlgSHA1 withKey:key];
}

- (NSData *)hmacSHA1DataWithKey:(NSData *)key
{
    return [self hmacDataUsingAlg:kCCHmacAlgSHA1 withKey:key];
}

- (NSString *)md5String
{
    NSData * value = [self md5Data];
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

#pragma mark - Private Method
- (NSData *)hmacDataUsingAlg:(CCHmacAlgorithm)alg withKey:(NSData *)key
{
    size_t size;
    switch (alg) {
        case kCCHmacAlgMD5: size = CC_MD5_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA1: size = CC_SHA1_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA224: size = CC_SHA224_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA256: size = CC_SHA256_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA384: size = CC_SHA384_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA512: size = CC_SHA512_DIGEST_LENGTH; break;
        default: return nil;
    }
    unsigned char result[size];
    CCHmac(alg, [key bytes], key.length, self.bytes, self.length, result);
    return [NSData dataWithBytes:result length:size];
}

- (NSString *)hmacStringUsingAlg:(CCHmacAlgorithm)alg withKey:(NSString *)key
{
    size_t size;
    switch (alg) {
        case kCCHmacAlgMD5: size = CC_MD5_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA1: size = CC_SHA1_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA224: size = CC_SHA224_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA256: size = CC_SHA256_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA384: size = CC_SHA384_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA512: size = CC_SHA512_DIGEST_LENGTH; break;
        default: return nil;
    }
    unsigned char result[size];
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    CCHmac(alg, cKey, strlen(cKey), self.bytes, self.length, result);
    NSMutableString *hash = [NSMutableString stringWithCapacity:size * 2];
    for (int i = 0; i < size; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

@end
