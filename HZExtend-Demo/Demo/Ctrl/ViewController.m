//
//  ViewController.m
//  HZExtend-Demo
//
//  Created by xzh on 16/2/13.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "ViewController.h"
#import "SubjectViewModel.h"
#import "UIViewController+HZHUD.h"
#import "SubjectDay.h"
#import "HZExtend.h"
#import "Masonry.h"
@interface ViewController () <HZViewModelDelegate>
@property (weak, nonatomic) UILabel *pageLabel;
@property(nonatomic, strong)  SubjectViewModel*viewModel;
@end

@implementation ViewController
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    for (UIView *view in self.view.subviews) {
//        NSLog(@"%@",view);
//    }
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _viewModel = [SubjectViewModel viewModelWithDelegate:self];
    
    UILabel *pageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    pageLabel.text = @"当前分页数为:0  ";
    pageLabel.textColor = [UIColor blackColor];
    pageLabel.font = [UIFont systemFontOfSize:16];
//    pageLabel.backgroundColor = [UIColor brownColor];
    [self.view addSubview:pageLabel];
    self.pageLabel = pageLabel;
    [pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@150);
    }];
    
    UIButton *pageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pageBtn addTarget:self action:@selector(sendTask:) forControlEvents:UIControlEventTouchUpInside];
    [pageBtn setTitle:@"获得主题" forState:UIControlStateNormal];
    [pageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:pageBtn];
    [pageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(pageLabel);
        make.top.equalTo(pageLabel.mas_bottom).offset(15);
    }];
    
    UIButton *dbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dbBtn addTarget:self action:@selector(listSubject:) forControlEvents:UIControlEventTouchUpInside];
    [dbBtn setTitle:@"列出数据库所有主题" forState:UIControlStateNormal];
    [dbBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:dbBtn];
    [dbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(pageLabel);
        make.top.equalTo(pageBtn.mas_bottom).offset(15);
    }];
    
}

- (void)viewModelConnetedNotifyForTask:(SessionTask *)task type:(NSString *)type
{
    if (task.succeed) {
        [self showSuccessWithText:@"请求成功" image:@"success"];
        self.pageLabel.text = [NSString stringWithFormat:@"当前分页数为:%ld",self.viewModel.subjectList.pagination.page.integerValue];
        
        //数据处理均在viewModel处理
        [self.viewModel saveSubject];
    }else {
        [self showFailWithText:task.message image:@"error" yOffset:0];
    }
}

//本地缓存数据到来调用(多种状态)(第一次再页面显示之前就会回调)
- (void)viewModelSendingNotifyForTask:(SessionTask *)task type:(NSString *)type
{
    if (task.cacheSuccess) {
        [self showSuccessWithText:@"获得缓存" image:@"success"];
        NSLog(@"%@",task.responseObject);
    }
}

//无网情况下缓存数据到来调用(多种状态)(第一次再页面显示之前就会回调)
- (void)viewModelLostedNotifyForTask:(SessionTask *)task type:(NSString *)type
{
    if (task.cacheSuccess) {
        [self showSuccessWithText:@"获得缓存" image:@"success"];
        NSLog(@"%@",task.responseObject);
    }
}

- (void)sendTask:(id)sender
{
    if (self.viewModel.task.runable) {
        [self.viewModel pageIncrease:self.viewModel.task];
        [self.viewModel sendTask:self.viewModel.task];
    }
    
}

- (void)listSubject:(id)sender {
    
    [SubjectDay open];
    //等价于[SubjectDay findAll]
    NSArray *array = [SubjectDay findWithSql:@"select *from SubjectDay" withParameters:nil];
    for (SubjectDay *day in array) {
        NSLog(@"title:%@-----------des:%@",day.title,day.desc);
    }
    [SubjectDay close];
}

@end
