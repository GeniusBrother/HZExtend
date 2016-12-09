//
//  UIColor+HzExtend.h
//  ZHFramework
//
//  Created by xzh. on 15/7/20.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HZExtend)

+ (UIColor *)colorForHex:(NSInteger)colorHex;

+ (UIColor *)colorForHex:(NSInteger)colorHex alpha:(CGFloat)alpha;

+ (UIColor *)colorForString:(NSString *)string;

@end
