//
//  HZURLManager.m
//  ZHFramework
//
//  Created by xzh. on 15/8/21.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "HZURLManager.h"
#import "NSObject+HZExtend.h"
@implementation HZURLManager
singleton_m(Manager)
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


#pragma mark - push
+ (void)pushViewControllerWithString:(NSString *)urlstring animated:(BOOL)animated
{
    if (!urlstring.isNoEmpty) return;
    
    UIViewController *viewController = [UIViewController viewControllerWithString:urlstring];
    if (viewController)
    [HZURLNavigation pushViewController:viewController animated:animated];
}

+ (void)pushViewControllerWithString:(NSString *)urlstring queryDic:(NSDictionary *)query animated:(BOOL)animated
{
    if (!urlstring.isNoEmpty) return;
    
    UIViewController *viewController = [UIViewController viewControllerWithString:urlstring queryDic:query];
    if (viewController)
    [HZURLNavigation pushViewController:viewController animated:animated];
}

#pragma mark - Present
+ (void)presentViewControllerWithString:(NSString *)urlstring animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion
{
    if (!urlstring.isNoEmpty) return;
    
    UIViewController *viewController = [UIViewController viewControllerWithString:urlstring];
    if (viewController)
    [HZURLNavigation presentViewController:viewController animated:animated completion:completion];
}

+ (void)presentViewControllerWithString:(NSString *)urlstring queryDic:(NSDictionary *)query animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion
{
    if (!urlstring.isNoEmpty) return;
    
    UIViewController *viewController = [UIViewController viewControllerWithString:urlstring queryDic:query];
    if (viewController)
    [HZURLNavigation presentViewController:viewController animated:animated completion:completion];
}


#pragma mark - Dismiss
+ (void)dismissCurrentAnimated:(BOOL)animated
{
    [HZURLNavigation dismissCurrentAnimated:animated];
}

@end
