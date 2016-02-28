//
//  UIView+HZExtend.m
//  ZHFramework
//
//  Created by xzh. on 15/7/26.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "UIView+HZExtend.h"
#import "HZConst.h"
#import "NSObject+HZExtend.h"
@implementation UIView (HZExtend)

#pragma mark - Location
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

#pragma mark - Center
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

#pragma mark - Size
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

#pragma mark - Other Origin
- (void)setBottomRight:(CGPoint)bottomRight
{
    CGRect newframe = self.frame;
    newframe.origin.x = bottomRight.x-self.width;
    newframe.origin.y = bottomRight.y-self.height;
    self.frame = newframe;
}

- (CGPoint)bottomRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (void)setBottomLeft:(CGPoint)bottomLeft
{
    CGRect newframe = self.frame;
    newframe.origin.x = bottomLeft.x;
    newframe.origin.y = bottomLeft.y-self.height;
    self.frame = newframe;
}

- (CGPoint)bottomLeft
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (void)setTopRight:(CGPoint)topRight
{
    CGRect newframe = self.frame;
    newframe.origin.x = topRight.x-self.width;
    newframe.origin.y = topRight.y;
    self.frame = newframe;
}

- (CGPoint)topRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}

#pragma mark - Relative
- (void)alignRight:(CGFloat)rightOffset
{
    UIView *supView = self.superview;
    HZAssertNoReturn(self.superview == nil, @"view did have superView")
    self.right = supView.width + rightOffset;
}

- (void)alignBottom:(CGFloat)bottomOffset
{
    UIView *supView = self.superview;
    HZAssertNoReturn(supView == nil, @"view did have superView")
    
    self.bottom = supView.height + bottomOffset;
}

- (void)alignCenter
{
    UIView *supView = self.superview;
    HZAssertNoReturn(self.superview == nil, @"view did have superView")
    
    self.origin = CGPointMake((supView.width-self.width)/2, (supView.height-self.height)/2);
}

- (void)alignCenterX
{
    UIView *supView = self.superview;
    HZAssertNoReturn(self.superview == nil, @"view did have superView")
    
    self.left = (supView.width-self.width)/2;
}

- (void)alignCenterY
{
    UIView *supView = self.superview;
    HZAssertNoReturn(self.superview == nil, @"view did have superView")
    
    self.top = (supView.height-self.height/2);
}

- (void)bottomOverView:(UIView *)view offset:(CGFloat)offset
{
    HZAssertNoReturn(self.superview == nil || !(self.superview == view.superview), @"views hierarchy not same")
    
    self.bottom = view.top+offset;
}

- (void)topBehindView:(UIView *)view offset:(CGFloat)offset
{
    HZAssertNoReturn(self.superview == nil || !(self.superview == view.superview), @"views hierarchy not same")
    
    self.top = view.bottom+offset;
}

- (void)rightOverView:(UIView *)view offset:(CGFloat)offset
{
    HZAssertNoReturn(self.superview == nil || !(self.superview == view.superview), @"views hierarchy not same")
    
    self.right = view.left+offset;
}

- (void)leftBehindView:(UIView *)view offset:(CGFloat)offset
{
    HZAssertNoReturn(self.superview == nil || !(self.superview == view.superview), @"views hierarchy not same")
    
    self.left = view.right+offset;
}

- (UIImage *)saveImageWithScale:(float)scale
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
