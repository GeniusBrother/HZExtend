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


@property(nonatomic, readonly, nullable) UIView *leftCustomView;
@property(nonatomic, readonly, nullable) UIView *centerCustomView;
@property(nonatomic, readonly, nullable) UIView *rightCustomView;

/** 标题label,默认为nil,懒加载 */
@property(nonatomic, weak, readonly, nullable) UILabel *titleLabel;

/**
 *  创建带有标题的navBar实例
 */
+ (instancetype)navBarWithTitle:(NSString *)title;

/**
 *  创建带有默认按钮的的navBar实例
 */
+ (instancetype)navBarWithLeftButton:(NSString *)buttonName;

/**
 *  创建带有标题和默认按钮的navBar实例
 */
+ (instancetype)navBarWithTitle:(nullable NSString *)title leftButton:(nullable NSString *)buttonName;


- (void)addLeftCustomView:(UIView *)leftCustomView;

- (void)addCenterCustomView:(UIView *)centerCustomView;

- (void)addRightCustomView:(UIView *)rightCustomView;


/**
 *	左边增加一个默认按钮
 *  默认的点击效果为dismiss当前页面
 *
 *	@param buttonName  默认按钮图片的名称
 *  @param offset 离屏幕左边的水平位移,若传入nil,则默认为16
 */
- (void)addLeftButtonWithName:(NSString *)buttonName offset:(nullable NSNumber *)offset;


@end

NS_ASSUME_NONNULL_END
