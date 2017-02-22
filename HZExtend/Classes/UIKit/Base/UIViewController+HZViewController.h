//
//  UIViewController+HZViewController.h
//  mcapp
//
//  Created by xzh on 2017/1/8.
//  Copyright © 2017年 发条橙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZNavBar.h"
@interface UIViewController (HZViewController)

/** 自定义的导航条,默认为nil,懒加载 */
@property(nonatomic, weak, readonly) HZNavBar *navBar;

- (void)performTask:(void(^)(BOOL done))block;


@end
