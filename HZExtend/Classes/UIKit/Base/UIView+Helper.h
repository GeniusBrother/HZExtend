//
//  UIView+Helper.h
//  mcapp
//
//  Created by xzh on 2016/11/6.
//  Copyright © 2016年 发条橙. All rights reserved.
//

#import <UIKit/UIKit.h>
//便捷添加视图
@interface UIView (Helper)

@property(nonatomic, weak, readonly) UIView *lineView;


- (void)addBottomLineViewWithColor:(UIColor *)lineColor height:(CGFloat)height;
- (void)addTopLineViewWithColor:(UIColor *)lineColor height:(CGFloat)height;

- (void)addBottomLineViewWithColor:(UIColor *)lineColor;
- (void)addTopLineViewWithColor:(UIColor *)lineColor;

- (void)addDefalutBottomLineView;

@end
