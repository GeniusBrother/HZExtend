//
//  UIImage+HZExtend.m
//  Pods
//
//  Created by xzh on 16/9/13.
//
//

#import "UIImage+HZExtend.h"

@implementation UIImage (HZExtend)

- (UIImage *)compressImageToScale:(CGFloat)scale
{
    CGSize newSize = CGSizeMake(self.size.width *scale, self.size.height *scale);
    return [self compressImageToSize:newSize];
}

- (UIImage *)compressImageToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"%@",NSStringFromCGSize(compressedImage.size));
    return compressedImage;
}

@end
