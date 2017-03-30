//
//  UIView+EmptyView.m
//  Pods
//
//  Created by xzh on 2016/12/18.
//
//

#import "UIView+HZEmptyView.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>
static const char EMPTY_CONTENT_VIEW = '\0';
@interface UIView ()

@end

@implementation UIView (HZEmptyView)

#pragma mark - Public Method
- (void)hz_addEmptyView:(UIView *)view
{
    if (!view) return;
    
    [self.emptyContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.safeEmptyContentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];
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
        //        emptyContentView.backgroundColor = [UIColor redColor];
        [self addSubview:emptyContentView];
        [emptyContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
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
