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

@interface HZURLManager : NSObject


/**
 * pop/dismiss当前控制器
 */
+ (void)dismissCurrentAnimated:(BOOL)animated;

@end

@interface HZURLManager (URLManagerDeprecated)

+ (void)pushViewControllerWithString:(NSString *)urlstring animated:(BOOL)animated __deprecated_msg("");
+ (void)pushViewControllerWithString:(NSString *)urlstring queryDic:(NSDictionary *)query animated:(BOOL)animated __deprecated_msg("");
+ (void)pushViewController:(UIViewController *)ctrl animated:(BOOL)animated __deprecated_msg("");
+ (void)presentViewControllerWithString:(NSString *)urlstring animated:(BOOL)animated completion:(void (^)(void))completion __deprecated_msg("");
+ (void)presentViewControllerWithString:( NSString *)urlstring queryDic:(NSDictionary *)query animated:(BOOL)animated completion:(void (^)(void))completion __deprecated_msg("");
+ (void)presentViewController:(UIViewController *)ctrl animated:(BOOL)animated completion:(void (^)(void))completion __deprecated_msg("");

@end
