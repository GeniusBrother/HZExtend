//
//  SubjectList.m
//  HZExtend-Demo
//
//  Created by xzh on 16/2/13.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "SubjectList.h"

@implementation SubjectList
- (void)loadModel
{
    [super loadModel];
    
    [SubjectList mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"list":@"SubjectDay"};
    }];
}
@end
