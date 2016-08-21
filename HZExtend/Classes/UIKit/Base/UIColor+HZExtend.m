//
//  UIColor+HzExtend.m
//  ZHFramework
//
//  Created by xzh. on 15/7/20.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "UIColor+HZExtend.h"
@implementation UIColor (HZExtend)
+ (UIColor *)colorForHex:(NSInteger)colorHex
{
    return [UIColor colorWithRed:((float)((colorHex & 0xFF0000) >> 16)) / 0xFF green:((float)((colorHex & 0xFF00) >> 8))  / 0xFF blue:((float)(colorHex & 0xFF)) / 0xFF alpha:1.0f];
}

+ (UIColor *)colorForHex:(NSInteger)colorHex alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((colorHex & 0xFF0000) >> 16)) / 0xFF green:((float)((colorHex & 0xFF00) >> 8))  / 0xFF blue:((float)(colorHex & 0xFF)) / 0xFF alpha:alpha];
}

@end
