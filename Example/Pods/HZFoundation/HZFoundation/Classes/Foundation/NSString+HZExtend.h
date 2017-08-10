//
//  NSString+HZExtend.h
//  HZFoundation <https://github.com/GeniusBrother/HZFoundation>
//
//  Created by GeniusBrother on 15/7/20.
//  Copyright (c) 2015 GeniusBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+HZExtend.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HZExtend)

/**
 Trim blank characters (space and newline) in head and tail.
 
 @return the trimmed string.
 */
- (NSString *)stringByTrim;

/**
 Returns a NSString for md5 hash.
 */
- (NSString *)md5String;

/**
 Returns a new UUID NSString. e.g. "C3278C30-2B3D-4E1E-7AC2-B6FFB24A07C1"
 */
+ (NSString *)UUIDString;

/**
 URL encode a string in utf-8.
 
 @return the encode string.
 */
- (NSString *)urlEncode;

/**
 URL decode a string in utf-8.
 
 @return the decoded string.
 */
- (NSString *)urlDecode;

/**
 Converts json string to json object. return nil if an error occurs.
 NSArray/NSDictionary
 */
- (nullable id)jsonObject;

/**
 Whether it can match the regular expression.
 
 @param regex  The regular expression
 @param options The matching options to report.
 @return YES if can match the regex; otherwise, NO.
 */
- (BOOL)matchesRegx:(NSString *)regex options:(NSRegularExpressionOptions)options;

/**
 Returns NSMakeRange(0, self.length).
 */
- (NSRange)rangeOfAll;


@end

NS_ASSUME_NONNULL_END
