//
//  UIView+EmptyView.m
//  Pods
//
//  Created by xzh on 2016/12/18.
//
//

#import "UIView+HZEmptyView.h"
#import <objc/runtime.h>
static const char EMPTY_CONTENT_VIEW = '\0';
@interface UIView ()

@end

@implementation UIView (HZEmptyView)

#pragma mark - Public Method
- (void)hz_addEmptyView:(UIView *)view
{
    if (!view) return;
    
    [self.emptyContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *superView = self.safeEmptyContentView;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:view];
    [superView addConstraints:@[[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]]];
}

- (void)hz_removeEmptyView
{
    [self.emptyContentView removeFromSuperview];
    self.emptyContentView = nil;
}

#pragma mark - Property

- (UIView *)safeEmptyContentView
{
    UIView *emptyContentView = self.emptyContentView;
    if (!emptyContentView) {
        emptyContentView = [[UIView alloc] initWithFrame:CGRectZero];
        emptyContentView.translatesAutoresizingMaskIntoConstraints = NO;
        //        emptyContentView.backgroundColor = [UIColor redColor];
        [self addSubview:emptyContentView];
        [self addConstraints:@[[NSLayoutConstraint constraintWithItem:emptyContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0],[NSLayoutConstraint constraintWithItem:emptyContentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0],[NSLayoutConstraint constraintWithItem:emptyContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0],[NSLayoutConstraint constraintWithItem:emptyContentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]]];
        [self setEmptyContentView:emptyContentView];
    }
    
    return emptyContentView;
}

- (UIView *)emptyContentView
{
    UIView *emptyContentView = objc_getAssociatedObject(self, &EMPTY_CONTENT_VIEW);

    return emptyContentView;
}

- (void)setEmptyContentView:(UIView *)emptyContentView
{
    UIView *existEmptyContentView = objc_getAssociatedObject(self, &EMPTY_CONTENT_VIEW);
    if (existEmptyContentView != emptyContentView) {
        [self willChangeValueForKey:@"emptyContentView"];
        objc_setAssociatedObject(self, &EMPTY_CONTENT_VIEW, emptyContentView, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"emptyContentView"];
    }
}

@end
