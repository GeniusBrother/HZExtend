//
//  UIColor+HZExtend.m
//  HZFoundation <https://github.com/GeniusBrother/HZFoundation>
//
//  Created by GeniusBrother on 2015/7/20.
//  Copyright (c) 2017 GeniusBrother. All rights reserved.
//

#import "UIColor+HZExtend.h"
@implementation UIColor (HZExtend)
#pragma mark - Public Method
+ (UIColor *)colorForHex:(NSInteger)colorHex
{
    return [UIColor colorWithRed:((float)((colorHex & 0xFF0000) >> 16)) / 0xFF green:((float)((colorHex & 0xFF00) >> 8))  / 0xFF blue:((float)(colorHex & 0xFF)) / 0xFF alpha:1.0f];
}

+ (UIColor *)colorForHex:(NSInteger)colorHex alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((colorHex & 0xFF0000) >> 16)) / 0xFF green:((float)((colorHex & 0xFF00) >> 8))  / 0xFF blue:((float)(colorHex & 0xFF)) / 0xFF alpha:alpha];
}

+ (UIColor *)colorForString:(NSString *)string
{
    if ( nil == string || 0 == string.length )
        return nil;
    
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ( [string hasPrefix:@"rgb("] && [string hasSuffix:@")"] )
    {
        string = [string substringWithRange:NSMakeRange(4, string.length - 5)];
        if ( string && string.length )
        {
            NSArray * elems = [string componentsSeparatedByString:@","];
            if ( elems && elems.count == 3 )
            {
                NSInteger r = [[elems objectAtIndex:0] integerValue];
                NSInteger g = [[elems objectAtIndex:1] integerValue];
                NSInteger b = [[elems objectAtIndex:2] integerValue];
                
                return [UIColor colorWithRed:(r * 1.0f / 255.0f) green:(g * 1.0f / 255.0f) blue:(b * 1.0f / 255.0f) alpha:1.0f];
            }
        }
    }
    
    NSArray *	array = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *	color = [array objectAtIndex:0];
    CGFloat		alpha = 1.0f;
    
    if ( array.count == 2 )
    {
        alpha = [[array objectAtIndex:1] floatValue];
    }
    
    if ( [color hasPrefix:@"#"] ) // #FFF
    {
        color = [color substringFromIndex:1];
        
        if ( color.length == 3 )
        {
            NSUInteger hexRGB = strtol(color.UTF8String , nil, 16);
            return [UIColor fromShortHexValue:hexRGB alpha:alpha];
        }
        else if ( color.length == 6 )
        {
            NSUInteger hexRGB = strtol(color.UTF8String , nil, 16);
            return [UIColor colorForHex:hexRGB alpha:alpha];
        }
    }
    else if ( [color hasPrefix:@"0x"] || [color hasPrefix:@"0X"] ) // #FFF
    {
        color = [color substringFromIndex:2];
        
        if ( color.length == 8 )
        {
            NSUInteger hexRGB = strtol(color.UTF8String , nil, 16);
            return [UIColor colorForHex:hexRGB];
        }
        else if ( color.length == 6 )
        {
            NSUInteger hexRGB = strtol(color.UTF8String , nil, 16);
            return [UIColor colorForHex:hexRGB alpha:1.0f];
        }
    }
    else
    {
        static NSMutableDictionary * __colors = nil;
        
        if ( nil == __colors )
        {
            __colors = [[NSMutableDictionary alloc] init];
            [__colors setObject:[UIColor clearColor]		forKey:@"clear"];
            [__colors setObject:[UIColor clearColor]		forKey:@"transparent"];
            [__colors setObject:[UIColor redColor]			forKey:@"red"];
            [__colors setObject:[UIColor blackColor]		forKey:@"black"];
            [__colors setObject:[UIColor darkGrayColor]		forKey:@"darkgray"];
            [__colors setObject:[UIColor lightGrayColor]	forKey:@"lightgray"];
            [__colors setObject:[UIColor whiteColor]		forKey:@"white"];
            [__colors setObject:[UIColor grayColor]			forKey:@"gray"];
            [__colors setObject:[UIColor greenColor]		forKey:@"green"];
            [__colors setObject:[UIColor blueColor]			forKey:@"blue"];
            [__colors setObject:[UIColor cyanColor]			forKey:@"cyan"];
            [__colors setObject:[UIColor yellowColor]		forKey:@"yellow"];
            [__colors setObject:[UIColor magentaColor]		forKey:@"magenta"];
            [__colors setObject:[UIColor orangeColor]		forKey:@"orange"];
            [__colors setObject:[UIColor purpleColor]		forKey:@"purple"];
            [__colors setObject:[UIColor brownColor]		forKey:@"brown"];
        }
        
        UIColor *setColor = [__colors objectForKey:color.lowercaseString];
        if ( setColor )
        {
            return [setColor colorWithAlphaComponent:alpha];
        }
    }
    
    return nil;
}

#pragma mark - Private Method
+ (UIColor *)fromShortHexValue:(NSUInteger)hex alpha:(CGFloat)alpha
{
    NSUInteger r = ((hex >> 8) & 0x0000000F);
    NSUInteger g = ((hex >> 4) & 0x0000000F);
    NSUInteger b = ((hex >> 0) & 0x0000000F);
    
    float fr = (r * 1.0f) / 15.0f;
    float fg = (g * 1.0f) / 15.0f;
    float fb = (b * 1.0f) / 15.0f;
    
    return [UIColor colorWithRed:fr green:fg blue:fb alpha:alpha];
}

@end
