//
//  HZURLManageConfig.m
//  HZNetworkDemo
//
//  Created by xzh on 16/2/27.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "HZURLManageConfig.h"

@implementation HZURLManageConfig
singleton_m(Config)
- (instancetype)init
{
    self = [super init];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });
    return self;
}


@end
