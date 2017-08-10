//
//  HZURLNavigation.m
//  HZURLManager <https://github.com/GeniusBrother/HZURLManager>
//
//  Created by GeniusBrother on 2015/8/21.
//  Copyright (c) 2015 GeniusBrother. All rights reserved.
//

#import "HZURLNavigation.h"
#import "NSArray+HZExtend.h"
@implementation HZURLNavigation

#pragma mark - 获得控制器
+ (id<UIApplicationDelegate>)applicationDelegate
{
    return [UIApplication sharedApplication].delegate;
}

+ (UINavigationController*)currentNavigationViewController
{
    UIViewController* currentViewController = [self currentViewController];
    return currentViewController.navigationController;
}

+ (UIViewController *)currentViewController
{
    UIViewController* rootViewController = self.applicationDelegate.window.rootViewController;
    return [self currentViewControllerFrom:rootViewController];
}

/**
 *  返回当前的控制器,以viewController为节点开始寻找
 */
+ (UIViewController*)currentViewControllerFrom:(UIViewController*)viewController
{
    //传入的根节点控制器是导航控制器
    if ([viewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController* navigationController = (UINavigationController *)viewController;
        return [self currentViewControllerFrom:navigationController.viewControllers.lastObject];
    }
    else if([viewController isKindOfClass:[UITabBarController class]]) //传入的根节点控制器是UITabBarController
    {
        UITabBarController* tabBarController = (UITabBarController *)viewController;
        return [self currentViewControllerFrom:tabBarController.selectedViewController];
    }
    else if(viewController.presentedViewController != nil)  //传入的根节点控制器是被展现出来的控制器
    {
        return [self currentViewControllerFrom:viewController.presentedViewController];
    }
    else
    {
        return viewController;
    }
}

#pragma mark - Push
+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController) {
        [self pushViewControllerArray:@[viewController] animated:animated replace:NO];
    }
    
}

+ (void)pushViewControllerArray:(NSArray *)viewControllers animated:(BOOL)animated
{
    [self pushViewControllerArray:viewControllers animated:animated replace:NO];
}

+ (void)pushViewControllerArray:(NSArray *)viewControllers animated:(BOOL)animated replace:(BOOL)replace
{
    if (!viewControllers.isNoEmpty) return;
    
    UINavigationController *currentNav = [self currentNavigationViewController];
    if (!currentNav) return;
    
    NSArray *oldViewCtrls = currentNav.childViewControllers;
    NSArray *newViewCtrls = nil;
    if (replace) {
        newViewCtrls = [[oldViewCtrls subarrayWithRange:NSMakeRange(0, oldViewCtrls.count-1)] arrayByAddingObjectsFromArray:viewControllers];
    }else {
        newViewCtrls = [oldViewCtrls arrayByAddingObjectsFromArray:viewControllers];
    }
    
    [currentNav setViewControllers:newViewCtrls animated:animated];
}

#pragma mark - Present
+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^ __nullable)(void))completion
{
    if (!viewController) return;
    
    UIViewController *currentCtrl = [self currentViewController];
    if (!currentCtrl) return;
    
    [currentCtrl presentViewController:viewController animated:animated completion:completion];
}

#pragma mark - Dismiss
+ (void)dismissCurrentAnimated:(BOOL)animated
{
    UIViewController *currentViewController = [self currentViewController];
    if(!currentViewController) return;
    
    if(currentViewController.navigationController)    //如果当前视图有导航控制器
    {
        if(currentViewController.navigationController.viewControllers.count == 1)
        {
            if(currentViewController.presentingViewController)  //modal出来一个导航控制器
            {
                [currentViewController dismissViewControllerAnimated:animated completion:nil];
            }
        }
        else
        {
            [currentViewController.navigationController popViewControllerAnimated:animated];
        }
    }
    else if(currentViewController.presentingViewController) //如果当前视图是modal
    {
        [currentViewController dismissViewControllerAnimated:animated completion:nil];
    }
 
}
@end
