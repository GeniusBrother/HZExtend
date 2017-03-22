//
//  UIScrollView+HZExtend.m
//  HZNetworkDemo
//
//  Created by xzh on 16/3/24.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "UIScrollView+HZExtend.h"

@implementation UIScrollView (HZExtend)

- (CGFloat)contentWidth
{
    return self.contentSize.width;
}

- (void)setContentWidth:(CGFloat)contentWidth
{
    CGSize contentSize = self.contentSize;
    contentSize.width = contentWidth;
    self.contentSize = contentSize;
}

- (CGFloat)contentHeight
{
    return self.contentSize.height;
}

- (void)setContentHeight:(CGFloat)contentHeight
{
    CGSize contentSize = self.contentSize;
    contentSize.height = contentHeight;
    self.contentSize = contentSize;
}

- (CGFloat)offsetX
{
    return self.contentOffset.x;
}

- (CGFloat)offsetY
{
    return self.contentOffset.y;
}

- (CGFloat)insetTop
{
    return self.contentInset.top;
}

- (void)setInsetTop:(CGFloat)insetTop
{
    UIEdgeInsets insets = self.contentInset;
    insets.top = insetTop;
    self.contentInset = insets;
}

- (CGFloat)insetBottom
{
    return self.contentInset.bottom;
}

- (void)setInsetBottom:(CGFloat)insetBottom
{
    UIEdgeInsets insets = self.contentInset;
    insets.bottom = insetBottom;
    self.contentInset = insets;
}

- (UIImage *)imageRepresentation
{
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize contentSize = self.contentSize;
    CGFloat contentHeight = contentSize.height;
    CGPoint offset = self.contentOffset;
    
    [self setContentOffset:CGPointMake(0, 0)];
    NSMutableArray *images = [NSMutableArray array];
    while (contentHeight > 0) {
        UIGraphicsBeginImageContextWithOptions(boundsSize, NO, 0.0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [images addObject:image];
        
        CGFloat offsetY = self.contentOffset.y;
        [self setContentOffset:CGPointMake(0, offsetY + boundsHeight)];
        
        contentHeight -= boundsHeight;
    }
    
    self.contentOffset = offset;
    
    CGSize imageSize = CGSizeMake(contentSize.width * scale,
                                  contentSize.height * scale);
    UIGraphicsBeginImageContext(imageSize);
    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        [image drawInRect:CGRectMake(0,
                                     scale * boundsHeight * idx,
                                     scale * boundsWidth,
                                     scale * boundsHeight)];
    }];
    
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return fullImage;
    
}

@end
