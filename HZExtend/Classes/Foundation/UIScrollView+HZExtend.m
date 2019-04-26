//
//  UIScrollView+HZExtend.m
//  HZNetworkDemo
//
//  Created by xzh on 16/3/24.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "UIScrollView+HZExtend.h"
#import <objc/runtime.h>
static const char kLastContentOffset = '\0';
static const char kDirection = '\0';
@implementation UIScrollView (HZExtend)

#pragma mark - Data
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
    return self.safeContentInset.top;
}

- (void)setInsetTop:(CGFloat)insetTop
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = insetTop;
    if (@available(iOS 11, *)) {
        inset.top -= (self.adjustedContentInset.top - self.contentInset.top);
    }
    self.contentInset = inset;
}

- (CGFloat)insetBottom
{
    return self.safeContentInset.bottom;
}

- (void)setInsetBottom:(CGFloat)insetBottom
{
    UIEdgeInsets insets = self.contentInset;
    insets.bottom = insetBottom;
    self.contentInset = insets;
    
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = insetBottom;
    if (@available(iOS 11, *)) {
        inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom);
    }
    self.contentInset = inset;
}

- (CGFloat)insetLeft
{
    return self.safeContentInset.left;
}

- (void)setInsetLeft:(CGFloat)insetLeft
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = insetLeft;
    if (@available(iOS 11, *)) {
        inset.left -= (self.adjustedContentInset.left - self.contentInset.left);
    }
    self.contentInset = inset;
}

- (CGFloat)insetRight
{
    return self.safeContentInset.right;
}

- (void)setInsetRight:(CGFloat)insetRight
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = insetRight;
    if (@available(iOS 11, *)) {
        inset.right -= (self.adjustedContentInset.right - self.contentInset.right);
    }
    self.contentInset = inset;
}

- (UIEdgeInsets)safeContentInset
{
    if (@available(iOS 11, *)) {
        return self.adjustedContentInset;
    }else {
        return self.contentInset;
    }
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

#pragma mark - Observer
- (void)didScrollWithExpand:(HZScrollViewContentExpand)expand
{
    CGFloat offsetDistance = expand == HZScrollViewContentExpandHorizontal?self.offsetX:self.offsetY;
    
    if (offsetDistance > self.lastContentOffset && self.direction != HZScrollDirectionGo) {  //go
        self.direction = HZScrollDirectionGo;
    }else if (offsetDistance < self.lastContentOffset  && self.direction != HZScrollDirectionBack) {  //back
        self.direction = HZScrollDirectionBack;
    }

    self.lastContentOffset = offsetDistance;
}

#pragma mark - Properties
- (CGFloat)lastContentOffset
{
    NSNumber *value = objc_getAssociatedObject(self, &kLastContentOffset);
    return [value doubleValue];
}

- (void)setLastContentOffset:(CGFloat)lastContentOffset
{
    CGFloat value = [self lastContentOffset];
    if (lastContentOffset != value) {
        [self willChangeValueForKey:@"lastContentOffsetDistance"];
        objc_setAssociatedObject(self, &kLastContentOffset, @(lastContentOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"lastContentOffsetDistance"];
    }
}

- (HZScrollDirection)direction
{
    NSNumber *value = objc_getAssociatedObject(self, &kDirection);
    return [value doubleValue];
}

- (void)setDirection:(HZScrollDirection)direction
{
    NSInteger value = [self direction];
    if (direction != value) {
        [self willChangeValueForKey:@"direction"];
        objc_setAssociatedObject(self, &kDirection, @(direction), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"direction"];
    }
}
@end
