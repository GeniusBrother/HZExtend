//
//  UIViewController+HZURLManager.h
//  HZURLManager <https://github.com/GeniusBrother/HZURLManager>
//
//  Created by GeniusBrother on 15/8/21.
//  Copyright (c) 2015 GeniusBrother. All rights reserved.
//
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
/**
 Provides view controller for `HZURLManager`.
 */
@interface UIViewController (HZURLManager)

/**
 The URL corresponding to the Controller
 */
@property(nonatomic, strong, readonly) NSString *originURL;

/**
 Consists of a query string and additional parameters passed by user.
 */
@property(nonatomic, strong, readonly) NSDictionary *params;

/**
 Returns the controller corresponding to the URL.
 
 @discussion Before use the method, you should registe the URL in {"scheme":{"host/path":"ViewControllerName"}} format in plist file, ViewControllerName is a name of view controller. Then load it through HZURLManagerConfig.
 
 @param parmas Additional parameters passed to Controller.
 */
+ (UIViewController *)viewControllerForURL:(NSURL *)url;
+ (UIViewController *)viewControllerForURL:(NSURL *)url params:(nullable NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
