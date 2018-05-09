//
//  HZURLManager.m
//  HZURLManager <https://github.com/GeniusBrother/HZURLManager>
//
//  Created by GeniusBrother on 2015/8/21.
//  Copyright (c) 2015 GeniusBrother. All rights reserved.
//

#import "HZURLManager.h"
#import "NSObject+HZURLHandler.h"
#import "HZURLRewrite.h"
NSString *const HZRedirectPresentMode = @"HZRedirectPresentMode";
@interface HZURLManager ()



@end

@implementation HZURLManager
#pragma mark - Public Method
+ (id)handleURL:(NSString *)url withParams:(nullable id)parmas
{
    if (!([url isKindOfClass:[NSString class]] && url.length > 0)) return nil;
    
    NSURL *formatedURL = [self formatedURL:url];
    id<HZURLHandler> handler = [NSObject urlHandlerForURL:formatedURL];
    if ([handler respondsToSelector:@selector(handleURL:withParams:)]) {
        return [handler handleURL:formatedURL withParams:parmas];
    }
    
    return nil;
}

+ (void)redirectToURL:(NSString *)url
             animated:(BOOL)animated
               parmas:(nullable NSDictionary *)parmas
              options:(nullable NSDictionary *)options
           completion:(nullable void(^)())completion
{
    NSURL *formatedURL = [self formatedURL:url];
    NSURL *rewritedURL = [HZURLRewrite rewriteURLForURL:formatedURL];
    UIViewController *viewController = [UIViewController viewControllerForURL:rewritedURL params:parmas];
    if ([[options objectForKey:HZRedirectPresentMode] boolValue]) {
        [HZURLNavigation presentViewController:viewController animated:animated completion:completion];
    }else {
        [HZURLNavigation pushViewController:viewController animated:animated];
    }
}

+ (void)pushToURL:(NSString *)url animated:(BOOL)animated
{
    [self redirectToURL:url animated:animated parmas:nil options:nil completion:nil];
}

+ (void)pushToURL:(NSString *)url animated:(BOOL)animated params:(nullable NSDictionary *)params
{
    [self redirectToURL:url animated:animated parmas:params options:nil completion:nil];
}

+ (void)pushViewController:(UIViewController *)ctrl animated:(BOOL)animated
{
    [HZURLNavigation pushViewController:ctrl animated:animated];
}

+ (void)presentViewController:(UIViewController *)ctrl animated:(BOOL)animated completion:(void (^)(void))completion
{
    [HZURLNavigation presentViewController:ctrl animated:animated completion:completion];
}

+ (void)dismissCurrentAnimated:(BOOL)animated
{
    [HZURLNavigation dismissCurrentAnimated:animated];
}

#pragma mark - Private Method
//格式化URL
+ (NSURL *)formatedURL:(NSString *)url
{
    if (!url) return nil;
    
    NSString *formatedURLString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [NSURL URLWithString:formatedURLString];
}



@end


@implementation HZURLManager (URLManagerDeprecated)

#pragma mark - push
+ (void)pushViewControllerWithString:(NSString *)urlstring animated:(BOOL)animated
{
    if (!([urlstring isKindOfClass:[NSString class]] && urlstring.length > 0)) return;
    
    UIViewController *viewController = [UIViewController viewControllerForURL:[NSURL URLWithString:urlstring]];
    if (viewController)
        [HZURLNavigation pushViewController:viewController animated:animated];
}

+ (void)pushViewControllerWithString:(NSString *)urlstring queryDic:(NSDictionary *)query animated:(BOOL)animated
{
    if (!([urlstring isKindOfClass:[NSString class]] && urlstring.length > 0)) return;
    
    UIViewController *viewController = [UIViewController viewControllerForURL:[NSURL URLWithString:urlstring] params:query];
    if (viewController)
        [HZURLNavigation pushViewController:viewController animated:animated];
}



#pragma mark - Present
+ (void)presentViewControllerWithString:(NSString *)urlstring animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion
{
    if (!([urlstring isKindOfClass:[NSString class]] && urlstring.length > 0)) return;
    
    UIViewController *viewController = [UIViewController viewControllerForURL:[NSURL URLWithString:urlstring]];
    if (viewController)
        [HZURLNavigation presentViewController:viewController animated:animated completion:completion];
}

+ (void)presentViewControllerWithString:(NSString *)urlstring queryDic:(NSDictionary *)query animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion
{
    if (!([urlstring isKindOfClass:[NSString class]] && urlstring.length > 0)) return;
    
    UIViewController *viewController = [UIViewController viewControllerForURL:[NSURL URLWithString:urlstring] params:query];
    if (viewController)
        [HZURLNavigation presentViewController:viewController animated:animated completion:completion];
}

@end
