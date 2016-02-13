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
@interface ViewController () <HZViewModelDelegate>
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property(nonatomic, strong)  SubjectViewModel*viewModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _viewModel = [SubjectViewModel viewModelWithDelegate:self];
}

- (void)viewModelConnetedNotifyForTask:(SessionTask *)task type:(NSString *)type
{
    if (task.succeed) {
        [self showSuccessWithText:@"请求成功"];
        self.pageLabel.text = [NSString stringWithFormat:@"当前分页数为:%ld",self.viewModel.subjectList.pagination.page.integerValue];
        SubjectDay *day = [self.viewModel.subjectList.list firstObject];
        [SubjectDay open];
        SubjectDay *existDay = [SubjectDay modelWithSql:@"select *from SubjectDay where title = ?" withParameters:@[day.title]];
        if (!existDay) {
            [day safeSave];
        }
        [SubjectDay close];
    }else {
        [self showFailWithText:task.message yOffset:0];
    }
}

//本地缓存数据到来调用(多种状态)(第一次再页面显示之前就会回调)
- (void)viewModelSendingNotifyForTask:(SessionTask *)task type:(NSString *)type
{
    if (task.cacheSuccess) {
        [self showSuccessWithText:@"获得缓存"];
        NSLog(@"%@",task.responseObject);
    }
}

//无网情况下缓存数据到来调用(多种状态)(第一次再页面显示之前就会回调)
- (void)viewModelLostedNotifyForTask:(SessionTask *)task type:(NSString *)type
{
    if (task.cacheSuccess) {
        [self showSuccessWithText:@"获得缓存"];
        NSLog(@"%@",task.responseObject);
    }
}

- (IBAction)sendTask:(id)sender
{
    if (self.viewModel.task.runable) {
        [self.viewModel pageIncrease:self.viewModel.task];
        [self.viewModel sendTask:self.viewModel.task];
    }
    
}

- (IBAction)listSubject:(id)sender {
    
    [SubjectDay open];
    //等价于[SubjectDay findAll]
    NSArray *array = [SubjectDay findWithSql:@"select *from SubjectDay" withParameters:nil];
    for (SubjectDay *day in array) {
        NSLog(@"title:%@-----------des:%@",day.title,day.desc);
    }
    [SubjectDay close];
}

@end
