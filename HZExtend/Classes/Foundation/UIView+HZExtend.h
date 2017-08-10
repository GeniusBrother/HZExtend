//
//  UIView+HZExtend.h
//  HZFoundation <https://github.com/GeniusBrother/HZFoundation>
//
//  Created by GeniusBrother on 15/7/26.
//  Copyright (c) 2015 GeniusBrother. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for `UIView`.
 */
@interface UIView (HZExtend)

/** Shortcut for frame.origin. */
@property(nonatomic, assign) CGPoint origin;

/** Shortcut for frame.origin.y. */
@property(nonatomic, assign) CGFloat top;

/** Shortcut for frame.origin.x. */
@property(nonatomic, assign) CGFloat left;

/** Shortcut for frame.origin.y + frame.size.height. */
@property(nonatomic, assign) CGFloat bottom;

/** Shortcut for frame.origin.x + frame.size.width. */
@property(nonatomic, assign) CGFloat right;

/** Shortcut for center.y. */
@property(nonatomic, assign) CGFloat centerY;

/** Shortcut for center.x. */
@property(nonatomic, assign) CGFloat centerX;

/** Shortcut for frame.size.height. */
@property(nonatomic, assign) CGFloat height;

/** Shortcut for frame.size.width. */
@property(nonatomic, assign) CGFloat width;

/** Shortcut for frame.size. */
@property(nonatomic, assign) CGSize size;

/** Returns the view's view controller. */
@property (nullable, nonatomic, readonly) UIViewController *viewController;

/**
 Returns a snapshot image of the complete view hierarchy.
 
 @param afterUpdates A Boolean value that indicates whether the snapshot should be rendered after recent changes have been incorporated.
 Specify the value NO if you want to render a snapshot in the view hierarchy’s current state, which might not include recent changes.
 */
- (nullable UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;



@end

@interface UIView (HZLayout)

/**
 Sets frame.origin.x = superview.width - frame.size.width + rightOffset.
 
 @discussion If receiver don't have any superview, it will not work.
 */
- (void)alignRight:(CGFloat)rightOffset;

/**
 Sets frame.origin.y = superview.height - frame.size.height + bottomOffset.
 
 @discussion If the receiver don't have any superview, this method has no effect.
 */
- (void)alignBottom:(CGFloat)bottomOffset;

/**
 Sets center = (superview.width/2,superview.height/2).
 
 @discussion If the receiver don't have any superview, this method has no effect.
 */
- (void)alignCenter;

/**
 Sets center.x = superview.width/2.
 
 @discussion If the receiver don't have any superview, this method has no effect.
 */
- (void)alignCenterX;

/**
 Sets center.y = superview.height/2.
 
 @discussion If the receiver don't have any superview, this method has no effect.
 */
- (void)alignCenterY;

/**
 Sets frame.origin.y = view.frame.origin.y + offset - frame.size.height.
 
 @discussion If the receiver don't have any superview, this method has no effect.
 */
- (void)bottomOverView:(UIView *)view offset:(CGFloat)offset;

/**
 Sets frame.origin.y = CGRectGetMaxY(view) + offset.
 
 @discussion If the receiver don't have any superview, this method has no effect.
 */
- (void)topBehindView:(UIView *)view offset:(CGFloat)offset;

/**
 Sets frame.origin.x = view.frame.origin.x + offset - frame.size.width.
 
 @discussion If the receiver don't have any superview, this method has no effect.
 */
- (void)rightOverView:(UIView *)view offset:(CGFloat)offset;

/**
 Sets frame.origin.x = CGRectGetMaxX(view)+ offset.
 
 @discussion If the receiver don't have any superview, this method has no effect.
 */
- (void)leftBehindView:(UIView *)view offset:(CGFloat)offset;

@end

NS_ASSUME_NONNULL_END
