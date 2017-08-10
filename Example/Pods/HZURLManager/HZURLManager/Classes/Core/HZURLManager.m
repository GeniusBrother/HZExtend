//
//  HZURLManager.m
//  HZURLManager <https://github.com/GeniusBrother/HZURLManager>
//
//  Created by GeniusBrother on 2015/8/21.
//  Copyright (c) 2015 GeniusBrother. All rights reserved.
//

#import "HZURLManager.h"
#import <HZFoundation/HZFoundation.h>
#import "NSObject+HZURLHandler.h"
#import "HZURLRewrite.h"
NSString *const HZRedirectPresentMode = @"HZRedirectPresentMode";
@interface HZURLManager ()



@end

@implementation HZURLManager
#pragma mark - Initialization
singleton_m
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
        });
    }
    return self;
}

#pragma mark - Public Method
- (id)handleURL:(NSString *)url withTarget:(id)target withParams:(nullable id)parmas
{
    if (!url.isNoEmpty) return nil;
    
    NSURL *formatedURL = [self formatedURL:url];
    id<HZURLHandler> handler = [NSObject urlHandlerForURL:formatedURL];
    if (handler) {
        return [handler handleURL:formatedURL.absoluteString withTarget:target withParams:parmas];
    }
    
    return nil;
}

- (void)redirectToURL:(NSString *)url
             animated:(BOOL)animated
               parmas:(nullable NSDictionary *)parmas
              options:(nullable NSDictionary *)options
           completion:(nullable void(^)())completion
{
    NSURL *formatedURL = [self formatedURL:url];
    NSURL *rewritedURL = [HZURLRewrite rewriteURLForURL:formatedURL];
    UIViewController *viewController = [UIViewController viewControllerForURL:rewritedURL params:parmas];
    if ([options boolValueForKeyPath:HZRedirectPresentMode default:NO]) {
        [HZURLNavigation presentViewController:viewController animated:animated completion:completion];
    }else {
        [HZURLNavigation pushViewController:viewController animated:animated];
    }
}

- (void)redirectToURL:(NSString *)url animated:(BOOL)animated
{
    [self redirectToURL:url animated:animated parmas:nil options:nil completion:nil];
}

- (void)redirectToURL:(NSString *)url animated:(BOOL)animated params:(nullable NSDictionary *)params
{
    [self redirectToURL:url animated:animated parmas:params options:nil completion:nil];
}

#pragma mark - Private Method
//格式化URL
- (NSURL *)formatedURL:(NSString *)url
{
    if (!url.isNoEmpty) return nil;
    
    NSString *formatedURLString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [NSURL URLWithString:formatedURLString];
}



@end


@implementation HZURLManager (URLManagerDeprecated)

#pragma mark - push
+ (void)pushViewControllerWithString:(NSString *)urlstring animated:(BOOL)animated
{
    if (!urlstring.isNoEmpty) return;
    
    UIViewController *viewController = [UIViewController viewControllerForURL:[NSURL URLWithString:urlstring]];
    if (viewController)
        [HZURLNavigation pushViewController:viewController animated:animated];
}

+ (void)pushViewControllerWithString:(NSString *)urlstring queryDic:(NSDictionary *)query animated:(BOOL)animated
{
    if (!urlstring.isNoEmpty) return;
    
    UIViewController *viewController = [UIViewController viewControllerForURL:[NSURL URLWithString:urlstring] params:query];
    if (viewController)
        [HZURLNavigation pushViewController:viewController animated:animated];
}

+ (void)pushViewController:(UIViewController *)ctrl animated:(BOOL)animated
{
    [HZURLNavigation pushViewController:ctrl animated:animated];
}

#pragma mark - Present
+ (void)presentViewControllerWithString:(NSString *)urlstring animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion
{
    if (!urlstring.isNoEmpty) return;
    
    UIViewController *viewController = [UIViewController viewControllerForURL:[NSURL URLWithString:urlstring]];
    if (viewController)
        [HZURLNavigation presentViewController:viewController animated:animated completion:completion];
}

+ (void)presentViewControllerWithString:(NSString *)urlstring queryDic:(NSDictionary *)query animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion
{
    if (!urlstring.isNoEmpty) return;
    
    UIViewController *viewController = [UIViewController viewControllerForURL:[NSURL URLWithString:urlstring] params:query];
    if (viewController)
        [HZURLNavigation presentViewController:viewController animated:animated completion:completion];
}

+ (void)presentViewController:(UIViewController *)ctrl animated:(BOOL)animated completion:(void (^)(void))completion
{
    [HZURLNavigation presentViewController:ctrl animated:animated completion:completion];
}

+ (void)dismissCurrentAnimated:(BOOL)animated
{
    [HZURLNavigation dismissCurrentAnimated:animated];
}

@end
