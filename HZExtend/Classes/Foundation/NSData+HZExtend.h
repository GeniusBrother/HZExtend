//
//  NSData+HZExtend.h
//  HZFoundation <https://github.com/GeniusBrother/HZFoundation>
//
//  Created by GeniusBrother on 15/7/26.
//  Copyright (c) 2015 GeniusBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+HZExtend.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions method for `NSData`.
 */
@interface NSData (HZExtend)

/**
 Returns an NSData for md5 hash.
 */
- (NSData *)md5Data;

/**
 Returns a NSString for md5 hash.
 */
- (NSString *)md5String;

/**
 Returns an NSData for sha1 hash.
 */
- (NSData *)sha1Data;

/**
 Returns a lowercase NSString for sha1 hash.
 */
- (NSString *)sha1String;

/**
 Returns an NSData for hmac using algorithm sha1 with key.
 @param key  The hmac key.
 */
- (NSData *)hmacSHA1DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha1 with key.
 @param key  The hmac key.
 */
- (NSString *)hmacSHA1StringWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
