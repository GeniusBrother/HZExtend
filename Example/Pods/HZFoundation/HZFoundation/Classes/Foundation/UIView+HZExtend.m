//
//  UIView+HZExtend.m
//  ZHFramework
//
//  Created by xzh. on 15/7/26.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "UIView+HZExtend.h"

@implementation UIView (HZExtend)

#pragma mark - Properties
- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect newframe = self.frame;
    newframe.origin = origin;
    self.frame = newframe;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    CGRect newframe = self.frame;
    newframe.origin.y = top;
    self.frame = newframe;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    CGRect newframe = self.frame;
    newframe.origin.x = left;
    self.frame = newframe;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom: (CGFloat)bottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = bottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect newframe = self.frame;
    newframe.origin.x = right - self.frame.size.width;
    self.frame = newframe;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint newCenter = self.center;
    newCenter.x = centerX;
    self.center = newCenter;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint newCenter = self.center;
    newCenter.y = centerY;
    self.center = newCenter;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect newframe = self.frame;
    newframe.size = size;
    self.frame = newframe;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect newframe = self.frame;
    newframe.size.height = height;
    self.frame = newframe;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect newframe = self.frame;
    newframe.size.width = width;
    self.frame = newframe;
}

- (UIViewController *)viewController
{
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - Public Method
- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

@end

@implementation UIView (HZLayout)

- (void)alignRight:(CGFloat)rightOffset
{
    [self checkSuperView];
    
    UIView *supView = self.superview;
    self.right = supView.width + rightOffset;
}

- (void)alignBottom:(CGFloat)bottomOffset
{
    [self checkSuperView];
    
    UIView *supView = self.superview;
    self.bottom = supView.height + bottomOffset;
}

- (void)alignCenter
{
    [self checkSuperView];
    UIView *supView = self.superview;
    self.origin = CGPointMake((supView.width-self.width)/2, (supView.height-self.height)/2);
}

- (void)alignCenterX
{
    [self checkSuperView];
    UIView *supView = self.superview;
    self.left = (supView.width-self.width)/2;
}

- (void)alignCenterY
{
    [self checkSuperView];
    UIView *supView = self.superview;
    self.top = (supView.height-self.height)/2;
}

- (void)bottomOverView:(UIView *)view offset:(CGFloat)offset
{
    [self checkHierarchySameWithContrastView:view];
    self.bottom = view.top+offset;
}

- (void)topBehindView:(UIView *)view offset:(CGFloat)offset
{
    [self checkHierarchySameWithContrastView:view];
    self.top = view.bottom+offset;
}

- (void)rightOverView:(UIView *)view offset:(CGFloat)offset
{
    [self checkHierarchySameWithContrastView:view];
    self.right = view.left+offset;
}

- (void)leftBehindView:(UIView *)view offset:(CGFloat)offset
{
    [self checkHierarchySameWithContrastView:view];
    self.left = view.right+offset;
}


#pragma mark - Private Method
- (void)checkSuperView
{
    NSAssert(self.superview != nil, @"view did have superView");
}

- (void)checkHierarchySameWithContrastView:(UIView *)contrastView
{
    NSAssert((self.superview != nil && self.superview == contrastView.superview), @"views hierarchy not same");
}

@end
