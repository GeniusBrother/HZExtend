//
//  UIImage+HZTool.m
//  Pods
//
//  Created by xzh on 2016/12/6.
//
//

#import "UIImage+HZExtend.h"
#import "NSObject+HZExtend.h"
#import "HZMacro.h"

@implementation UIImage (HZExtend)

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

+ (UIImage *)imageWithName:(NSString *)name
{
    if (!name.isNoEmpty) return nil;
    
    NSInteger scale = [UIScreen mainScreen].scale;
    NSString *fileName = [NSString stringWithFormat:@"%@@%ldx.png",name,scale];
    UIImage *image = [UIImage imageWithContentsOfFile:HZAssetPath(fileName)];
    return image;
    
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
