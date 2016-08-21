//
//  HZViewController.m
//  ZHFramework
//
//  Created by xzh. on 15/8/21.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "HZViewController.h"
#import "HZConst.h"
@implementation HZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (HZNavigationController *)nav
{
    if ([self.navigationController isKindOfClass:[HZNavigationController class]]) {
        return (HZNavigationController *)self.navigationController;
    }else {
        return nil;
    }
    
}

- (void)setupSuccessDataWithTask:(SessionTask *)task type:(NSString *)type {}
- (void)requestFailWithTask:(SessionTask *)task type:(NSString *)type {}

- (void)dealloc
{
    HZLog(@"%@----Ctrl销毁了",self);
}
@end
