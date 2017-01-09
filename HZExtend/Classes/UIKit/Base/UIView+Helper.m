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
    [self addLineViewWithColor:lineColor height:height bottom:NO];
}

- (void)addBottomLineViewWithColor:(UIColor *)lineColor height:(CGFloat)height
{
    [self addLineViewWithColor:lineColor height:height bottom:YES];
}

- (void)addLineViewWithColor:(UIColor *)lineColor height:(CGFloat)height bottom:(BOOL)isBottom
{
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = lineColor;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
        make.leading.equalTo(@0);
        make.trailing.equalTo(@(0));
        if (isBottom) {
            make.bottom.equalTo(lineView.superview);
        }else {
            make.top.equalTo(0);
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
