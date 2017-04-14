//
//  HZNavBar.h
//  mcapp
//
//  Created by xzh on 2016/12/13.
//  Copyright © 2016年 GeniusBrother All rights reserved.
//
/****************     能够添加自定义视图和布局的导航条     ****************/
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static const CGFloat kNavBarDefaultSpace = 16.0f;

@interface HZNavBar : UIView


@property(nonatomic, readonly, weak, nullable) UIView *leftCustomView;
@property(nonatomic, readonly, weak, nullable) UIView *centerCustomView;
@property(nonatomic, readonly, weak, nullable) UIView *rightCustomView;

/** 标题label,默认为nil,懒加载 */
@property(nonatomic, weak, readonly, nullable) UILabel *titleLabel;

/**
 *  创建带有标题的navBar实例
 */
+ (instancetype)navBarWithTitle:(NSString *)title;

- (void)addLeftCustomView:(UIView *)leftCustomView;

- (void)addCenterCustomView:(UIView *)centerCustomView;

- (void)addRightCustomView:(UIView *)rightCustomView;


@end

NS_ASSUME_NONNULL_END
