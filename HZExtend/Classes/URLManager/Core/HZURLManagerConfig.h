//
//  HZURLManageConfig.h
//  HZURLManager <https://github.com/GeniusBrother/HZURLManager>
//
//  Created by GeniusBrother on 2016/2/27.
//  Copyright (c) 2016 GeniusBrother. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Provides Configs for `HZURLManager`
 */
@interface HZURLManagerConfig : NSObject

/** URL-Ctrl config */
@property(nonatomic, readonly) NSDictionary *urlControllerConfig;

/** URL-Method config */
@property(nonatomic, readonly) NSDictionary *urlMethodConfig;

/** URL rewrite rule */
@property(nonatomic, readonly) NSArray *rewriteRule;

/**
 The default name of Controller corresponding to the http(s) URL.
 */
@property(nonatomic, strong) NSString *classOfWebViewCtrl;

/**
 A Boolean value indicating whether the toolbar at the bottom of the screen is hidden when the view controller is pushed through URLManager on to a navigation controller. Default is YES.
 */
@property(nonatomic, assign) BOOL hideBottomWhenPushed;

/**
 Returns global HZURLManagerConfig instance.
 
 @return HZURLManagerConfig shared instance
 */
+ (instancetype)sharedConfig;

/**
 Loads config of URL-Controller and URL-Method.
 
 @param ctrlPath the path of URL-Controller-Config.plist.
 @param methodPath the path of URL-Method-Config.plist.
 */
- (void)loadURLCtrlConfig:(NSString *)ctrlPath urlMethodConfig:(NSString *)methodPath;

/**
 Adds URL rewrite rule.
 
 @discussion Each rewrite rule is represented by a dictionary, and the match key corresponds to the regular expression of the matching source URL The target key corresponds to the format of the new URL.
 
 The variable can be used in the target and starts with $, For example, $ 1 ... $ n represents the value of the corresponding tuple in the regular expression, $ query represents the query string part in the URL. 
 
 For example, when the @{@"match":@"(?:https://)?www.hz.com/articles/(\\d)\\?(.*)",@"target":@"hz://page.hz/article?$query&id=$1"} rule is applied, the rewrite engine rewrites the source URL as hz://page.hz/article?title=cool&id=3 when we redirect to https://ww.hz.com/articles/3?title=cool , Finally we'll jump to hz://page.hz/article?title=cool&id=3.
 
 @param rule The Rule of URL rewrite. see discussion for more information.
 */
- (void)addRewriteRules:(NSArray *)rule;

@end
