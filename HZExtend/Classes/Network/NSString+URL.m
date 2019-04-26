//
//  NSString+URL.m
//  AFNetworking
//
//  Created by xzh on 2017/12/21.
//

#import "NSString+URL.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation NSString (URL)

- (NSString *)hzn_urlEncode
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"-_.!*'();:@$,[]"]];
}

- (NSString *)hzn_md5String
{
    const char *str = [self UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *MD5 = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                     r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                     r[11], r[12], r[13], r[14], r[15]];
    
    return MD5;
}

@end
