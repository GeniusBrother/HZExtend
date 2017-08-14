//
//  NSObject+HZExtend.h
//  HZFoundation <https://github.com/GeniusBrother/HZFoundation>
//
//  Created by GeniusBrother on 15/7/26.
//  Copyright (c) 2015 GeniusBrother. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 Provides extensions method for `NSObject`.
 */
@interface NSObject (HZExtend)

/**
 Returns a BOOL value tells if the object is no empty.
 NSArray/NString/NSDictionary/NSData
 
 */
- (BOOL)isNoEmpty;

/**
 Swap two instance method's implementation in one class.
 
 @param originalSel   Selector 1.
 @param newSel        Selector 2.
 @return              YES if swizzling succeed, otherwise, NO.
 */
+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;


/**
 Swap two class method's implementation in one class.
 
 @param originalSel   Selector 1.
 @param newSel        Selector 2.
 @return              YES if swizzling succeed, otherwise, NO.
 */
+ (BOOL)swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;

@end

NS_ASSUME_NONNULL_END
