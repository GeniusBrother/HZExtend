//
//  UIViewController+HZViewController.m
//  mcapp
//
//  Created by xzh on 2017/1/8.
//  Copyright © 2017年 发条橙. All rights reserved.
//

#import "UIViewController+HZViewController.h"
static const char kNavBar = '\0';

@implementation UIViewController (HZViewController)

#pragma mark - Bar
- (HZNavBar *)navBar
{
    HZNavBar *navBar = objc_getAssociatedObject(self, &kNavBar);
    if(!navBar){
        navBar = [HZNavBar navBarWithTitle:@""];
        [self.view addSubview:navBar];
        objc_setAssociatedObject(self, &kNavBar, navBar, OBJC_ASSOCIATION_ASSIGN);
        
        //加载使用自定义bar的配置
        [self loadCustomNavBarConfig];
        
        //继承navgationBar的样式
        UIColor *barColor = [UINavigationBar appearance].barTintColor;
        if(barColor) navBar.backgroundColor = barColor;

        barColor = self.navigationController.navigationBar.barTintColor;
        if(barColor) navBar.backgroundColor = barColor;

    }
    
    return navBar;
}

- (void)loadCustomNavBarConfig
{
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
}

@end
