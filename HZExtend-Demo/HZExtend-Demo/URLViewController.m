//
//  URLViewController.m
//  HZExtend-Demo
//
//  Created by xzh on 16/2/28.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "URLViewController.h"
#import "HZExtend.h"
#import "Masonry.h"
@interface URLViewController ()

@end

@implementation URLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *pageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pageBtn addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
    [pageBtn setTitle:@"URL-Push" forState:UIControlStateNormal];
    [pageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    pageBtn.backgroundColor = [UIColor brownColor];
    [self.view addSubview:pageBtn];
    [pageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];
    
    UIButton *dbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dbBtn addTarget:self action:@selector(present:) forControlEvents:UIControlEventTouchUpInside];
    [dbBtn setTitle:@"URL-Present" forState:UIControlStateNormal];
    [dbBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dbBtn.backgroundColor = [UIColor brownColor];
    [self.view addSubview:dbBtn];
    [dbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(pageBtn);
        make.top.equalTo(pageBtn.mas_bottom).offset(15);
    }];
}

- (void)push:(UIButton *)sender
{
    [HZURLManager pushViewControllerWithString:@"hz://urlItem?title=push" animated:YES];
}

- (void)present:(UIButton *)sender
{
    [HZURLManager presentViewControllerWithString:@"hz://urlItem?title=present" animated:YES completion:nil];
}

@end
