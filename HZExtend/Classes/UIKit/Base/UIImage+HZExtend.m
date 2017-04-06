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

- (UIImage *)imageByScalingToMaxSize {
    CGFloat maxWith = 640.0f;
    if (self.size.width < maxWith) return self;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (self.size.width > self.size.height) {
        btHeight = maxWith;
        btWidth = self.size.width * (maxWith / self.size.height);
    } else {
        btWidth = maxWith;
        btHeight = self.size.height * (maxWith / self.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingToSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingToSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [self drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end
