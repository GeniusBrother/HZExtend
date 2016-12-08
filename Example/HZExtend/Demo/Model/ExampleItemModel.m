//
//  ExampleItemModel.m
//  HZExtend-Demo
//
//  Created by xzh on 16/2/28.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "ExampleItemModel.h"

@implementation ExampleItemModel
+ (void)initialize {
    if ([ExampleItemModel self] == self) {
        [ExampleItemModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"example":@"ExampleItemModel"};
        }];
        
    }
}

@end
