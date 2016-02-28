//
//  HZURLManager.h
//  ZHFramework
//
//  Created by xzh. on 15/8/21.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "HZURLNavigation.h"
#import "UIViewController+HZURLManager.h"
@class HZViewController;
/**
 *  生成控制器并跳转
 */
@interface HZURLManager : NSObject

/**
 *  将viewController push到当前的导航控制器,若当前导航控制器为nil则什么也不做
 */
+ (void)pushViewControllerWithString:(nonnull NSString *)urlstring animated:(BOOL)animated;
+ (void)pushViewControllerWithString:(nonnull NSString *)urlstring queryDic:(nullable NSDictionary *)query animated:(BOOL)animated;

/**
 *  将viewController present到当前的控制器上
 */
+ (void)presentViewControllerWithString:(nonnull NSString *)urlstring animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;
+ (void)presentViewControllerWithString:(nonnull NSString *)urlstring queryDic:(nullable NSDictionary *)query animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

/**
 *  1.若当前控制器的容器为导航控制器,则pop
 *  2.若当前控制器为模态视图控制器,则dismiss
 */
+ (void)dismissCurrentAnimated:(BOOL)animated;

@end
