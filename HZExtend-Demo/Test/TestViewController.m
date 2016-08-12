//
//  TestViewController.m
//  HZExtend-Demo
//
//  Created by TianCai on 16/5/19.
//  Copyright © 2016年 xzh. All rights reserved.
//




#import "TestViewController.h"
#import "HZExtend.h"
#import "SubjectItem.h"


static NSString *str = @"ENsjdhakjdhsadsdkj";
static CGFloat count = 0;
static NSInteger h = 1;


@interface TestViewController ()<UIAlertViewDelegate>

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
    
    NSArray *sortedArray = [@[@3,@1,@2] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result = NSOrderedSame;
        NSInteger value1 = [obj1 integerValue];
        NSInteger value2 = [obj2 integerValue];
        if (value1 > value2) {
            result =  NSOrderedAscending;
        } else if (value1 < value2) {
            result =  NSOrderedDescending;
        }
        return result;
    }];
    
    NSLog(@"%@",sortedArray);
    
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
