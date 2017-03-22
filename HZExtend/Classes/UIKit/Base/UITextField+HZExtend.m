//
//  UITextField+HZExtend.m
//  Pods
//
//  Created by xzh on 2017/3/22.
//
//

#import "UITextField+HZExtend.h"

@implementation UITextField (HZExtend)

- (void)setPlaceholderTextColor:(UIColor *)color
{
    if (color) [self setValue:color forKeyPath:@"placeholderLabel.textColor"];
}

@end
