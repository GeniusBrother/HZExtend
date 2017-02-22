//
//  HZURLManager.h
//  ZHFramework
//
//  Created by xzh. on 15/8/21.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZSingleton.h"
#import "HZURLNavigation.h"
#import "UIViewController+HZURLManager.h"
@class HZViewController;
/**
 *  生成控制器并跳转
 */
@interface HZURLManager : NSObject

/**
 *  push ctrl到当前的导航控制器,若当前导航控制器为nil则什么也不做
 */
+ (void)pushViewControllerWithString:(NSString *)urlstring animated:(BOOL)animated;
+ (void)pushViewControllerWithString:(NSString *)urlstring queryDic:(NSDictionary *)query animated:(BOOL)animated;
+ (void)pushViewController:(UIViewController *)ctrl animated:(BOOL)animated;

/**
 *  present ctrl到当前的控制器上
 */
+ (void)presentViewControllerWithString:(NSString *)urlstring animated:(BOOL)animated completion:(void (^)(void))completion;
+ (void)presentViewControllerWithString:( NSString *)urlstring queryDic:(NSDictionary *)query animated:(BOOL)animated completion:(void (^)(void))completion;
+ (void)presentViewController:(UIViewController *)ctrl animated:(BOOL)animated completion:(void (^)(void))completion;

/**
 * pop/dismiss当前控制器
 */
+ (void)dismissCurrentAnimated:(BOOL)animated;

@end
