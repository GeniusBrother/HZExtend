//
//  UIColor+HZExtend.h
//  HZFoundation <https://github.com/GeniusBrother/HZFoundation>
//
//  Created by GeniusBrother on 2015/7/20.
//  Copyright (c) 2015 GeniusBrother. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 Provides extensions method for `UIColor`.
 */
@interface UIColor (HZExtend)

/**
 Creates and returns a color object using the specified RGB hex value.
 
 @param rgbHex The rgb value such as 0x66CCFF.
 
 @return The color object. The color information represented by this object is in the device RGB colorspace.
 */
+ (UIColor *)colorForHex:(NSInteger)rgbHex;

/**
 Creates and returns a color object using the specified opacity and RGB hex value.
 
 @param rgbHex The rgb value such as 0x66CCFF.
 @param alpha The opacity value of the color object,specified as a value from 0.0 to 1.0.
 
 @return The color object. The color information represented by this object is in the device RGB colorspace.
 */
+ (UIColor *)colorForHex:(NSInteger)rgbHex alpha:(CGFloat)alpha;

/**
 Creates and returns a color object from hex string. e.g @"#F0F", @"#66ccff 0.9"
 
 @param string  The hex and alpha string value for the new color.
 @return An UIColor object from string, or nil if an error occurs.
 */
+ (nullable UIColor *)colorForString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
