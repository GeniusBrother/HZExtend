//
//  UIView+HZExtend.h
//  ZHFramework
//
//  Created by xzh. on 15/7/26.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HZExtend)

/********location********/
@property(nonatomic, assign) CGPoint origin;
@property(nonatomic, assign) CGFloat top;
@property(nonatomic, assign) CGFloat left;
@property(nonatomic, assign) CGFloat bottom;
@property(nonatomic, assign) CGFloat right;
@property(nonatomic, assign) CGPoint bottomLeft;
@property(nonatomic, assign) CGPoint bottomRight;
@property(nonatomic, assign) CGPoint topRight;

/********center********/
@property(nonatomic, assign) CGFloat centerY;
@property(nonatomic, assign) CGFloat centerX;

/********size********/
@property(nonatomic, assign) CGSize size;
@property(nonatomic, assign) CGFloat height;
@property(nonatomic, assign) CGFloat width;

/********有了父视图，且在同一个视图树才能使用********/
- (void)alignRight:(CGFloat)rightOffset;    //右边距离父视图rightOffset为负值
- (void)alignBottom:(CGFloat)bottomOffset;  //下边距离父视图bottomOffset为负值
- (void)alignCenter;                        //与父视图中心对齐
- (void)alignCenterX;                       //与父视图的中心x对齐
- (void)alignCenterY;                       

/**
 *  底部在参照视图(frame已经确定)顶部offset距离 offset为负值，需先设置Height
 */
- (void)bottomOverView:(UIView *)view offset:(CGFloat)offset;

/**
 *  顶部在参照视图(frame已经确定)底部offset距离 offset为正值
 */
- (void)topBehindView:(UIView *)view offset:(CGFloat)offset;

/**
 *  右边在参照视图前面(frame已经确定)offset距离 offset为负值
 */
- (void)rightOverView:(UIView *)view offset:(CGFloat)offset;

/**
 *  左边边在参照视图后面(frame已经确定)offset距离 offset为正值
 */
- (void)leftBehindView:(UIView *)view offset:(CGFloat)offset;


- (UIImage *)saveImageWithScale:(float)scale;
@end
