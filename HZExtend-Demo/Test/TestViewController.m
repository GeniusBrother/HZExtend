//
//  TestViewController.m
//  HZExtend-Demo
//
//  Created by TianCai on 16/5/19.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "TestViewController.h"
#import "HZExtend.h"
@interface TestViewController ()<UIAlertViewDelegate>

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor purpleColor]];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(100, 100, 100, 100);
}

- (void)click:(UIButton *)sender
{
//    [UIViewController showWindowSuccessWithText:@"请求失败，请稍后再试，误闯入无效ID，请仔细检查id后再操作" image:@"success"];
//    [UIViewController showWindowFailWithText:@"请求失败，请稍后再试，误闯入无效ID，请仔细检查id后再操作" image:@"error"];
//    [self showSuccessWithText:@"请求失败，请稍后再试，误闯入无效ID，请仔细检查id后再操作" image:@"success"];
//     [self showFailWithText:@"请求失败，请稍后再试，误闯入无效ID，请仔细检查id后再操作" image:@"error"];
//    [self showMessage:@"请求失败，请稍后再试，误闯入无效ID，请仔细检查id后再操作"];
//    [UIViewController showWindowIndicatorWithText:@"等待中..."];
    [self showIndicatorWithText:@"等待中..." forKey:@"loading"];
    [self performSelector:@selector(hideHud) withObject:nil afterDelay:2];
}

- (void)hideHud
{
//    [self hideHudForKey:@"loading"];
    [UIViewController hideHUD:[self.huds objectForKey:@"loading"]];
}

- (void)successhud
{
    [UIViewController successWithText:@"请求成功" image:@"success"];
//    [self successWithText:@"请求成功" image:@"success" forKey:@"loading"];
}

- (void)failHud
{
    [UIViewController failWithText:@"请求失败，请稍后再试，误闯入无效ID，请仔细检查id后再操作" image:@"error"];
//    [self failWithText:@"请求失败，请稍后再试，误闯入无效ID，请仔细检查id后再操作" image:@"error" forKey:@"loading"];
}


@end
