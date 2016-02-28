//
//  ExampleItemModel.m
//  HZExtend-Demo
//
//  Created by xzh on 16/2/28.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "ExampleItemModel.h"

@implementation ExampleItemModel
- (void)loadModel
{
    [super loadModel];
    
    [ExampleItemModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"example":@"ExampleItemModel"
                 };
    }];
}
@end
