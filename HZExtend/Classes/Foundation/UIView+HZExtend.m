//
//  UIApplication+HZExtend.m
//  HZFoundation <https://github.com/GeniusBrother/HZFoundation>
//
//  Created by GeniusBrother on 2017/8/4.
//  Copyright (c) 2017 GeniusBrother. All rights reserved.
//

#import "UIView+HZExtend.h"
#import <objc/runtime.h>
static const char kBlock = '\0';
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

- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (void)tapPeformBlock:(HZViewTapBlock)block
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    [self setBlock:block];
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    HZViewTapBlock block = [self block];
    if (block) {
        block(self);
    }
}

- (void)setBlock:(HZViewTapBlock)block
{
    if (block) {
        objc_setAssociatedObject(self, &kBlock, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (HZViewTapBlock)block
{
    return objc_getAssociatedObject(self, &kBlock);
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

- (NSLayoutConstraint *)constraintForAttribute:(NSLayoutAttribute)attribute
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d && firstItem = %@",attribute, self];
    NSArray *constrains = (attribute == NSLayoutAttributeWidth || attribute == NSLayoutAttributeHeight)?self.constraints : [self.superview constraints];
    NSArray *matchedConstraints = [constrains filteredArrayUsingPredicate:predicate];
    if (matchedConstraints.count == 0) return nil;
    return matchedConstraints.firstObject;
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
