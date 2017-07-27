//
//  HZURLNavigation.h
//  ZHFramework
//
//  Created by xzh. on 15/8/21.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  负责跳转,获得当前viewCtrl&navgationController
 */
@interface HZURLNavigation : NSObject
/**
 *  获得当前的控制器,从rootViewCtrl开始寻找
 */
+ (UIViewController *)currentViewController;

/**
 *  获得当前的navgationCtrl
 */
+ (nullable UINavigationController *)currentNavigationViewController;

/**
 *  将viewController push到当前的导航控制器,若当前导航控制器为nil则什么也不做
 */
+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
+ (void)pushViewControllerArray:(NSArray *)viewControllers animated:(BOOL)animated;

/**
 *  replace:YES 用viewController取代visibleViewController
 */
+ (void)pushViewControllerArray:(NSArray *)viewControllers animated:(BOOL)animated replace:(BOOL)replace;

/**
 *  将viewController present到当前的控制器上
 */
+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

/** 
 *  1.若当前控制器的容器为导航控制器,则pop
 *  2.若当前控制器为模态视图控制器,则dismiss
 */
+ (void)dismissCurrentAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
