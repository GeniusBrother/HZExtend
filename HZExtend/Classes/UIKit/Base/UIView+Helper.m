//
//  UIView+Helper.m
//  mcapp
//
//  Created by xzh on 2016/11/6.
//  Copyright © 2016年 发条橙. All rights reserved.
//

#import "UIView+Helper.h"
#import <Masonry/Masonry.h>
#import "UIColor+HZExtend.h"
#import <objc/runtime.h>
static const char kLineView = '\0';

@implementation UIView (Helper)

#pragma mark - Corner
- (void)addCorner:(UIRectCorner)postions radius:(CGFloat)radius
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:postions cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

#pragma mark - Line
- (void)addTopLineViewWithColor:(UIColor *)lineColor
{
    [self addTopLineViewWithColor:lineColor height:0.5];
}

- (void)addBottomLineViewWithColor:(UIColor *)lineColor
{
    [self addBottomLineViewWithColor:lineColor height:0.5];
}

- (void)addTopLineViewWithColor:(UIColor *)lineColor height:(CGFloat)height
{
    [self addTopLineViewWithColor:lineColor height:height space:0];
}

- (void)addTopLineViewWithColor:(UIColor *)lineColor
                         height:(CGFloat)height
                          space:(CGFloat)space
{
    [self addLineViewWithColor:lineColor height:height bottom:NO left:space right:space];
}

- (void)addBottomLineViewWithColor:(UIColor *)lineColor height:(CGFloat)height
{
    [self addBottomLineViewWithColor:lineColor height:height space:0];
}

- (void)addBottomLineViewWithColor:(UIColor *)lineColor
                            height:(CGFloat)height
                             space:(CGFloat)space
{
    [self addLineViewWithColor:lineColor height:height bottom:YES left:space right:space];
}

- (void)addLineViewWithColor:(UIColor *)lineColor
                      height:(CGFloat)height
                      bottom:(BOOL)isBottom
                        left:(CGFloat)leftSpace
                       right:(CGFloat)rightSpace
{
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = lineColor;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
        make.left.equalTo(@(leftSpace));
        make.right.equalTo(@(-rightSpace));
        if (isBottom) {
            make.bottom.equalTo(lineView.superview);
        }else {
            make.top.equalTo(@0);
        }
    }];
    [self setLineView:lineView];
}

- (void)addDefalutBottomLineView
{
    [self addBottomLineViewWithColor:[UIColor colorForHex:0xE2E3E4]];
}

- (UIView *)lineView
{
    return objc_getAssociatedObject(self, &kLineView);
}

- (void)setLineView:(UIView *)lineView
{
    UIView *view = objc_getAssociatedObject(self, &kLineView);
    if (view != lineView) {
        [self willChangeValueForKey:@"lineView"];
        objc_setAssociatedObject(self, &kLineView, lineView, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"lineView"];
    }
}

@end
