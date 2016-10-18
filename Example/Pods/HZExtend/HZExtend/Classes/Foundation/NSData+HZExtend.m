//
//  NSData+HzExtend.m
//  ZHFramework
//
//  Created by xzh. on 15/7/26.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "NSData+HZExtend.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSData (HZExtend)

- (NSData *)md5
{
    unsigned char	md5Result[CC_MD5_DIGEST_LENGTH + 1];
    CC_LONG			md5Length = (CC_LONG)[self length];
    CC_MD5( [self bytes], md5Length, md5Result );
    
    NSMutableData * retData = [[NSMutableData alloc] init];
    [retData appendBytes:md5Result length:CC_MD5_DIGEST_LENGTH];
    return retData;
}

- (NSString *)md5String
{
    NSData * value = [self md5];
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

@end
