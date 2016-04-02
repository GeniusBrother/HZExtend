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

@end
