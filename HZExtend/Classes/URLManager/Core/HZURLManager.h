//
//  HZURLManager.h
//  HZURLManager <https://github.com/GeniusBrother/HZURLManager>
//
//  Created by GeniusBrother on 2015/8/21.
//  Copyright (c) 2015 GeniusBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifndef HZURLManager_h
#define HZURLManager_h

#import "HZURLHandler.h"
#import "HZURLManagerConfig.h"
#import "HZURLManager.h"
#import "HZURLNavigation.h"
#import "UIViewController+HZURLManager.h"
#import "HZNavigationController.h"

#endif /* HZURLManager_h */
@class HZViewController;
#define URL_MANAGERN [HZURLManager sharedManager]

NS_ASSUME_NONNULL_BEGIN
extern NSString *const HZRedirectPresentMode;

/**
 `HZURLManager` is an URL routing library for iOS,support URL rewrite.
 */
@interface HZURLManager : NSObject

/**
 Calls module method specified by the given URL.
 
 @discussion Before use the method, you should registe the URL in {"scheme":{"host/path":"URLHandlerName"}} format in plist file, URLHandlerName is a name of class which implement HZURLHandler protocol. Then load it through HZURLManagerConfig.
 
 @param URL The URL corresponding to the module method.
 @param params Additional parameters passed to URLHandler.
 */
+ (id)handleURL:(NSString *)URL withParams:(nullable id)params;

/**
 Navigate to the controller corresponding to the URL.

 @discussion Before use the method, you should registe the URL in {"scheme":{"host/path":"ViewControllerName"}} format in plist file, ViewControllerName is a name of view controller. Then load it through HZURLManagerConfig.
 
 @param URL The URL corresponding to the Controller
 @param animated Specify YES to animate the transition or NO if you do not want the transition to be animated.
 @param parmas Additional parameters passed to Controller. You can get the parmas by `pramas`  property see `UIViewController+HZURLManager.h` for more information.

 @param options Specify HZRedirectPresentMode equal YES to transition by present way or default is push way.
 @param completion The block to execute after the presentation finishes.
 */
+ (void)redirectToURL:(NSString *)URL
             animated:(BOOL)animated
               parmas:(nullable NSDictionary *)parmas
              options:(nullable NSDictionary *)options
           completion:(nullable void(^)())completion;

/**
 Navigate to the controller corresponding to the URL by push way.
 */
+ (void)pushToURL:(NSString *)URL animated:(BOOL)animated params:(nullable NSDictionary *)params;
+ (void)pushToURL:(NSString *)URL animated:(BOOL)animated;


+ (void)pushViewController:(UIViewController *)ctrl animated:(BOOL)animated;
+ (void)presentViewController:(UIViewController *)ctrl animated:(BOOL)animated completion:(nullable void (^)(void))completion;
+ (void)dismissCurrentAnimated:(BOOL)animated;

@end

@interface HZURLManager (URLManagerDeprecated)

+ (void)pushViewControllerWithString:(NSString *)urlstring animated:(BOOL)animated __deprecated_msg("请使用- (void)redirectToURL:animated:");
+ (void)pushViewControllerWithString:(NSString *)urlstring queryDic:(NSDictionary *)query animated:(BOOL)animated __deprecated_msg("- (void)redirectToURL:animated:params");
+ (void)presentViewControllerWithString:(NSString *)urlstring animated:(BOOL)animated completion:(nullable void (^)(void))completion __deprecated_msg("请使用- (void)redirectToURL:animated:params:options:completion");
+ (void)presentViewControllerWithString:( NSString *)urlstring queryDic:(NSDictionary *)query animated:(BOOL)animated completion:(nullable void (^)(void))completion __deprecated_msg("请使用- (void)redirectToURL:animated:params:options:completion");
@end


NS_ASSUME_NONNULL_END
