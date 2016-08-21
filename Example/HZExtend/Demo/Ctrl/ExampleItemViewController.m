//
//  ExampleItemViewController.m
//  HZExtend-Demo
//
//  Created by xzh on 16/2/28.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "ExampleItemViewController.h"
#import "BaseModel.h"
#import "HZExtend.h"
@interface ExampleItemViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic)  UITableView *tableView;
@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, strong) BaseModel *model;
@end

@implementation ExampleItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    NSDictionary *dataDic = @{@"example":@[
                                      @{
                                          @"title":@"网络请求模块",
                                          @"url":@"hz://network"
                                        }
                                      ,
                                      @{
                                          @"title":@"URLManager模块",
                                          @"url":@"hz://urlmanager"
                                          }
                                      ]};
    _model = [BaseModel modelWithDic:dataDic];
    self.dataArray = self.model.example;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    ExampleItemModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExampleItemModel *model = [self.dataArray objectAtIndex:indexPath.row];
    NSString *urlstring = model.url;
    
    [HZURLManager pushViewControllerWithString:urlstring animated:YES];
}

@end
