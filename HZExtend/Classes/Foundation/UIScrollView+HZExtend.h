//
//  UIScrollView+HZExtend.h
//  HZNetworkDemo
//
//  Created by xzh on 16/3/24.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HZScrollDirection) {
    HZScrollDirectionNone,
    HZScrollDirectionBack,
    HZScrollDirectionGo
};

typedef NS_ENUM(NSInteger, HZScrollViewContentExpand) {
    HZScrollViewContentExpandVertical,
    HZScrollViewContentExpandHorizontal,
};

@interface UIScrollView (HZExtend)

@property(nonatomic, assign) CGFloat contentWidth;
@property(nonatomic, assign) CGFloat contentHeight;

@property(nonatomic, assign, readonly) CGFloat offsetY;
@property(nonatomic, assign, readonly) CGFloat offsetX;

@property(nonatomic, assign) CGFloat insetTop;
@property(nonatomic, assign) CGFloat insetBottom;
@property(nonatomic, assign) CGFloat insetLeft;
@property(nonatomic, assign) CGFloat insetRight;
@property(nonatomic, readonly) UIEdgeInsets safeContentInset;

@property(nonatomic, assign, readonly) HZScrollDirection direction;

@property(nonatomic, assign) CGFloat lastContentOffset;

- (UIImage *)imageRepresentation;

- (void)didScrollWithExpand:(HZScrollViewContentExpand)expand;
@end

NS_ASSUME_NONNULL_END
