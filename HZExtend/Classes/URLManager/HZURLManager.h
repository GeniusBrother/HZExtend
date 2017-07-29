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
#import "HZCommonHeader.h"
@class HZViewController;

#define URL_MANAGERN [HZURLManager sharedManager]
NS_ASSUME_NONNULL_BEGIN

@interface HZURLManager : NSObject
singleton_h(Manager)

/**
 *	加载URLController和URLMethod配置
 *
 *	@param ctrlPath URL-Controller-Config.plist文件的路径
 *  @param methodPath URL-Method-Config.plist文件的路径
 */
- (void)loadURLCtrlConfig:(NSString *)ctrlPath urlMethodConfig:(NSString *)methodPath;

/**
 *	添加重写规则
 *
 *	@param rule 重写规则,规则形式见文档
 */
- (void)addRewriteRules:(NSArray *)rule;

/**
 *	调用模块方法
 *
 *	@param url  与模块方法相对应的URL
 */
- (id)handleURL:(NSString *)url withTarget:(id)target withParams:(nullable id)parmas;

/**
 *	跳转到指定界面
 *
 *	@param url  与界面相对应的URL
 *  @param animated 指定跳转时是否有动画
 *  @param parmas
 *  @param options 若HZRedirectPresentMode = YES,则以present方式跳转
 *  @param completion 当以present方式跳转时，完成跳转后调用
 */
- (void)redirectToURL:(NSString *)url
             animated:(BOOL)animated
               parmas:(nullable NSDictionary *)parmas
              options:(nullable NSDictionary *)options
           completion:(nullable HZVoidBlock)completion;

/**
 *	跳转到指定界面
 *
 *  以push的方式进行跳转
 */
- (void)redirectToURL:(NSString *)url animated:(BOOL)animated params:(nullable NSDictionary *)params;
- (void)redirectToURL:(NSString *)url animated:(BOOL)animated;




@end

@interface HZURLManager (URLManagerDeprecated)

+ (void)pushViewControllerWithString:(NSString *)urlstring animated:(BOOL)animated __deprecated_msg("请使用- (void)redirectToURL:animated:");
+ (void)pushViewControllerWithString:(NSString *)urlstring queryDic:(NSDictionary *)query animated:(BOOL)animated __deprecated_msg("- (void)redirectToURL:animated:params");
+ (void)pushViewController:(UIViewController *)ctrl animated:(BOOL)animated __deprecated_msg("请通过HZURLNavigation实现");
+ (void)presentViewControllerWithString:(NSString *)urlstring animated:(BOOL)animated completion:(nullable void (^)(void))completion __deprecated_msg("请使用- (void)redirectToURL:animated:params:options:completion");
+ (void)presentViewControllerWithString:( NSString *)urlstring queryDic:(NSDictionary *)query animated:(BOOL)animated completion:(nullable void (^)(void))completion __deprecated_msg("请使用- (void)redirectToURL:animated:params:options:completion");
+ (void)presentViewController:(UIViewController *)ctrl animated:(BOOL)animated completion:(nullable void (^)(void))completion __deprecated_msg("请通过HZURLNavigation实现");
+ (void)dismissCurrentAnimated:(BOOL)animated __deprecated_msg("请通过HZURLNavigation实现");
@end


NS_ASSUME_NONNULL_END
