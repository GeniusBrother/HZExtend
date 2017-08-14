//
//  UIAlertController+HZExtend.m
//  Pods
//
//  Created by xzh on 2017/8/11.
//
//

#import "UIAlertController+HZExtend.h"
@implementation UIAlertController (HZExtend)

#pragma mark - Public Method
+ (void)showDestructiveActionSheetWithTitle:(NSString *)title
                           destructiveTitle:(NSString *)destrucTitle
                                cancleTitle:(NSString *)cancelTitle
                                    handler:(void (^)(UIAlertAction *))handler
{
    [self showAlertWithStyle:UIAlertControllerStyleActionSheet title:title message:@"" destructiveTitle:destrucTitle cancleTitle:cancelTitle handler:handler];
}

+ (void)showDestructiveAlertWithTitle:(NSString *)title
                              message:(NSString *)message
                     destructiveTitle:(NSString *)destrucTitle
                          cancleTitle:(NSString *)cancelTitle
                              handler:(void (^)(UIAlertAction * _Nonnull))handler
{
    [self showAlertWithStyle:UIAlertControllerStyleAlert title:title message:message destructiveTitle:destrucTitle cancleTitle:cancelTitle handler:handler];
}

#pragma mark - Private Method
+ (void)showAlertWithStyle:(UIAlertControllerStyle)style
                     title:(NSString *)title
                   message:(NSString *)message
          destructiveTitle:(NSString *)destrucTitle
               cancleTitle:(NSString *)cancelTitle
                   handler:(void (^)(UIAlertAction *))handler
{
    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    UIAlertAction *destrucAction = [UIAlertAction actionWithTitle:destrucTitle style:UIAlertActionStyleDestructive handler:handler];
    [alerController addAction:destrucAction];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:handler];
    [alerController addAction:cancleAction];
    [[self currentViewController] presentViewController:alerController animated:YES completion:nil];
}

+ (id<UIApplicationDelegate>)applicationDelegate
{
    return [UIApplication sharedApplication].delegate;
}

+ (UIViewController *)currentViewController
{
    UIViewController* rootViewController = self.applicationDelegate.window.rootViewController;
    return [self currentViewControllerFrom:rootViewController];
}

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

@end
