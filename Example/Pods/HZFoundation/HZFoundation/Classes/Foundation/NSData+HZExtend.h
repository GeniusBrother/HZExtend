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
 Provide some some common method for `NSData`.
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

@end

NS_ASSUME_NONNULL_END
