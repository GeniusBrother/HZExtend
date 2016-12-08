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
#import <HZExtend/HZExtend.h>
#import "Masonry.h"
#import "NetworkPath.h"
#import "HZSessionTask+Params.h"
@interface ViewController () <HZViewModelDelegate>
@property (weak, nonatomic) UILabel *pageLabel;
@property(nonatomic, strong)  SubjectViewModel*viewModel;
@end

@implementation ViewController

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

- (void)viewModel:(HZViewModel *)viewModel taskDidCompleted:(HZSessionTask *)task taskIdentifier:(nullable NSString *)taskIdentifier
{
    NSLog(@"%s",__func__);
    HZNETWORK_CONVERT_VIEWMODEL(SubjectViewModel);
    if (task.state == HZSessionTaskStateSuccess) {
        [self showSuccessWithText:@"请求成功" image:@"success"];
        self.pageLabel.text = [NSString stringWithFormat:@"当前分页数为:%ld",(long)selfViewModel.subjectList.pagination.page.integerValue];

        //数据处理均在viewModel处理
        [self.viewModel saveSubject];
    }else {
        [self showFailWithText:task.message image:@"error" yOffset:0];
    }
}

- (void)viewModel:(HZViewModel *)viewModel taskSending:(HZSessionTask *)task taskIdentifier:(nullable NSString *)taskIdentifier
{
    NSLog(@"%s",__func__);
    if (task.cacheImportState == HZSessionTaskCacheImportStateSuccess) {
        [self showSuccessWithText:@"获得缓存" image:@"success"];
//        NSLog(@"%@",task.responseObject);
    }
}

- (void)viewModel:(HZViewModel *)viewModel taskDidLose:(HZSessionTask *)task taskIdentifier:(nullable NSString *)taskIdentifier
{
    NSLog(@"%s",__func__);
    if (task.cacheImportState == HZSessionTaskCacheImportStateSuccess) {
        [self showSuccessWithText:@"获得缓存" image:@"success"];
//        NSLog(@"%@",task.responseObject);
    }
}

- (void)viewModel:(HZViewModel *)viewModel taskDidCancel:(HZSessionTask *)task taskIdentifier:(NSString *)taskIdentifier
{
    [self showFailWithText:task.message image:@"error" yOffset:0];
}

- (void)sendTask:(id)sender
{
    if (self.viewModel.task.state == HZSessionTaskStateRunable) {
        self.viewModel.task.page++;
        [self.viewModel.task startWithCompletionCallBack:^(HZSessionTask * _Nonnull task) {
            NSLog(@"comple%@",task.state ==  HZSessionTaskStateSuccess?@"YES":@"NO");
        } sendingCallBack:^(HZSessionTask * _Nonnull task) {
            NSLog(@"sending %@",task.cacheImportState == HZSessionTaskCacheImportStateSuccess?@"YES":@"NO");
        } lostCallBack:^(HZSessionTask * _Nonnull task) {
            NSLog(@"lost %@",task.cacheImportState == HZSessionTaskCacheImportStateSuccess?@"YES":@"NO");
        }];
    }
}

- (void)listSubject:(id)sender {
    

    //等价于[SubjectDay findAll]
    NSArray *array = [SubjectDay findWithSql:@"select *from SubjectDay" withParameters:nil];
    for (SubjectDay *day in array) {
        NSLog(@"title:%@-----------des:%@",day.title,day.desc);
    }

}

@end
