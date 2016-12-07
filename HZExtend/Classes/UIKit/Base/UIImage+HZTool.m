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

- (UIImage *)resizeImageToSize:(CGSize)newSize option:(HZResizeOption)option
{
    CGRect scaledImageRect = CGRectZero;
    
    CGFloat aspectWidth = newSize.width / self.size.width;
    CGFloat aspectHeight = newSize.height / self.size.height;
    CGFloat aspectRatio = option == HZResizeOptionAspectFill?MAX(aspectWidth, aspectHeight): MIN ( aspectWidth, aspectHeight );
    scaledImageRect.size.width = self.size.width * aspectRatio;
    scaledImageRect.size.height = self.size.height * aspectRatio;
    scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0f;
    scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0f;
    UIGraphicsBeginImageContextWithOptions( newSize, NO, 0 );
    [self drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
@end
