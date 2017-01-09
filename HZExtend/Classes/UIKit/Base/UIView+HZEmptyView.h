//
//  UIView+EmptyView.h
//  Pods
//
//  Created by xzh on 2016/12/18.
//
//

#import <UIKit/UIKit.h>

@interface UIView (HZEmptyView)

/**
 *  空视图容器view,默认为nil,懒加载
 */
@property(nonatomic, weak, readonly) UIView *emptyContentView;

/**
 *	增加一个空视图
 *
 *	@param view  自定义的空视图,采用自动布局,需要设置好size约束
 */
- (void)hz_addEmptyView:(UIView *)view;

/**
 *	移除空视图,移除了空视图容器view
 */
- (void)hz_removeEmptyView;

@end
