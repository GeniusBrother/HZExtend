//
//  UIImage+HZTool.m
//  Pods
//
//  Created by xzh on 2016/12/6.
//
//

#import "UIImage+HZTool.h"

@implementation UIImage (HZTool)

+ (UIImage *)capatureImageInView:(UIView *)view
{
    if (!view) return nil;
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size,NO,0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //将图层内容渲染到上下文
    [view.layer renderInContext:context];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
