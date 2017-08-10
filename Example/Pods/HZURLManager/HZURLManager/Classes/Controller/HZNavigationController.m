//
//  HZNavigationController.m
//  ZHFramework
//
//  Created by xzh. on 15/8/25.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "HZNavigationController.h"
@interface HZNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property(nonatomic, strong) UIPanGestureRecognizer *pan;

@end

@implementation HZNavigationController

#pragma mark - Init
- (void)setup
{
    _swipeEnable = YES;
    self.delegate = self;
    [self configGestureRecognizer];
}

/**
 *  在self.view检测到侧滑时调用系统的侧滑selector
 */
- (void)configGestureRecognizer
{
    id target = self.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    self.pan = pan;
    
    //禁掉系统的侧滑手势
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
}
- (void)handleNavigationTransition {}
#pragma mark - Appearance
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.topViewController.preferredStatusBarStyle;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL rs = (self.viewControllers.count > 1) && ![[self valueForKey:@"_isTransitioning"] boolValue] && self.swipeEnable;
    if (rs) {
        if (self.edgeRecognize) {
            CGPoint point = [gestureRecognizer locationInView:self.view];
            return CGRectContainsPoint(CGRectMake(0, 0, 100,[UIScreen mainScreen].bounds.size.width) , point);
        }
    }
    return rs;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.pan.enabled = YES;//push完毕开启手势
    
}

#pragma mark - Override
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.pan.enabled = NO;  //push 时禁掉手势防止触发手势
    
    [super pushViewController:viewController animated:animated];
}

@end
