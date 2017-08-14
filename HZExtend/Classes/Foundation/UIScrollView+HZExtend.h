//
//  UIScrollView+HZExtend.h
//  HZNetworkDemo
//
//  Created by xzh on 16/3/24.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (HZExtend)

@property(nonatomic, assign) CGFloat contentWidth;
@property(nonatomic, assign) CGFloat contentHeight;

@property(nonatomic, assign, readonly) CGFloat offsetY;
@property(nonatomic, assign, readonly) CGFloat offsetX;

@property(nonatomic, assign) CGFloat insetTop;
@property(nonatomic, assign) CGFloat insetBottom;

- (UIImage *)imageRepresentation;
@end

NS_ASSUME_NONNULL_END
