//
//  URLItemViewController.m
//  HZExtend-Demo
//
//  Created by xzh on 16/2/28.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "URLItemViewController.h"
#import "HZExtend.h"
#import "Masonry.h"
@interface URLItemViewController ()

@end

@implementation URLItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [self.queryDic objectForKey:@"title"];
    self.view.backgroundColor = [UIColor brownColor];
    
    UIButton *pageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pageBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [pageBtn setTitle:@"Dismiss" forState:UIControlStateNormal];
    [pageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    pageBtn.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:pageBtn];
    [pageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];
    
}

- (void)btnClick:(UIButton *)sender
{
    [HZURLManager dismissCurrentAnimated:YES];
}


@end
